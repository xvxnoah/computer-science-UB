#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <signal.h>
#include <fcntl.h>

int get_column_fields_airport(int *column8, int *column9, char *line);

/* Inicialitzem els senyals */
int sigusr1 = 0;
int sigusr2 = 0;

/* Inicialitzem les funcions per actuar davant els diferents senyals */
void sigusr1_fun(int signo) {
    sigusr1 = 1;
}

void sigusr2_fun(int signo) {
    sigusr2 = 1;
}


int main(int argc, char *argv[]){
    int child1, child2, fd1, fd2;

    /* Comprovació de que l'usuari ha donat els 2 arguments necessaris */
    if(argc != 3) {
        printf("%s <file> <N>\n", argv[0]);
        exit(1);
    }

    /* Guardem en dues variables els dos arguments donats */
    char *filename = argv[1];
    const long int N = atoi(argv[2]);

    /* Comprovem que el valor de N sigui correcte */
    if(N < 1){
        printf("N must be > 1\n");
    }

    /* Definim els senyals */
    signal(SIGUSR1, sigusr1_fun);
    signal(SIGUSR2, sigusr2_fun);

    /* Fill 1 */
    child1 = fork();

    if (child1 == 0) {
        int fds;
        int buf8[N];
        int value;
        unsigned long int passenger_count = 0, num_elements=0;

        /* Esperem a que el productor ens notifiqui de la creació del fitxer */
        while (!sigusr1) {};
        sigusr1 = 0;
        kill(getppid(),SIGUSR1);

        fds = open("col8.bin", O_RDONLY);

        /* Espera activa a que el productor ens permeti llegir el fitxer */
        while(!sigusr1){};
        sigusr1 = 0;
        kill(getppid(),SIGUSR1);

        /* Comencem a llegir les dades */
        while(read(fds, buf8, sizeof(int) * N)){
            for(int i = 0; i < N; i++){
                passenger_count += buf8[i];
                num_elements++;

            }

            /* Espera activa */
            while(!sigusr1){};
            sigusr1 = 0;
            kill(getppid(),SIGUSR1);
        }

        /* Espera activa */
        while(!sigusr1){};
        sigusr1 = 0;
        kill(getppid(),SIGUSR1);

        while(read(fds, &value, sizeof(int))) {
            passenger_count += value;
            num_elements++;
        }

        /* Calculem la mitja de les dades llegides */
        float pc = 0;
        pc = (float)passenger_count/(float)num_elements;

        /* Indica la mitjana dels passatgers */
        printf("Col8: Aplication read %ld elements\n",num_elements);
        printf("Col8: Mean of passengers: %f\n",pc);
        close(fds);
        return 0;

    }

    /* Fill 2 */
    child2 = fork();
    if (child2 == 0) {
        int fds;
        int buf9[N];
        int value;
        unsigned long int trip_time_in_secs = 0, num_elements=0;

        /* Esperem a que el productor ens notifiqui de la creació del fitxer */
        while (!sigusr2) {};
        sigusr2 = 0;
        kill(getppid(),SIGUSR2);

        fds = open("col9.bin", O_RDONLY);

        /* Espera activa a que el productor ens permeti llegir el fitxer */
        while (!sigusr2) {};
        sigusr2 = 0;
        kill(getppid(),SIGUSR2);

        /* Comencem a llegir les dades */
        while(read(fds, buf9, sizeof(int) * N)){
            for(int i = 0; i < N; i++){
                trip_time_in_secs += buf9[i];
                num_elements++;
            }

            /* Espera activa */
            while (!sigusr2) {};
            sigusr2 = 0;
            kill(getppid(),SIGUSR2);
        }

        /* Espera activa */
        while (!sigusr2) {};
        sigusr2 = 0;
        kill(getppid(),SIGUSR2);

        while(read(fds, &value, sizeof(int))) {
          trip_time_in_secs += value;
          num_elements++;
        }

        /* Calculem la mitja de les dades llegides */
        float tt;
        tt = (float)trip_time_in_secs/(float)num_elements;

        /* Indica la mitjana del temps de viatge */
        printf("Col9: Aplication read %ld elements\n",num_elements);
        printf("Col9: Trip time in secs: %f\n",tt);

        close(fds);
        return 0;
    }

    /* Pare */

    /* Eliminem els buffers (fitxers) per si existien anteriorment */
    remove("col8.bin");
    remove("col9.bin");

    fd1 = open("col8.bin", O_WRONLY | O_CREAT | O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
    fd2 = open("col9.bin", O_WRONLY | O_CREAT | O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);

    /* Notifiquem als consumidors que els fitxers han estat creats */
    kill(child1, SIGUSR1);
    kill(child2, SIGUSR2);

    /* Espera activa */
    while (!sigusr1 || !sigusr2) {}
    sigusr1 = 0;
    sigusr2 = 0;

    FILE *file;
    char line[256];
    int invalid;
    int value_col8, value_col9, vector8[N], vector9[N];

    /* Obrim el fitxer de dades */
    file = fopen(filename, "r");

    /* Comprovem que el fitxer està correcte (existeix) */
    if (!file) {
      printf("ERROR: could not open '%s'\n", filename);
      exit(1);
      }

    /* Iniciem comptador que anirà fins a N */
    int counter = 0;

    /* We ignore the header of the file */
    fgets(line, sizeof(line), file);

    /* Read the whole file */
    while (fgets(line, sizeof(line), file)) {
      invalid = get_column_fields_airport(&value_col8, &value_col9, line);

      /* Escrivim col 8 i 9; augmentem count */
      if (!invalid) {
        vector8[counter] = value_col8;
        vector9[counter] = value_col9;
      }

      counter++;

      /* Si ja hem llegit N dades del bloc, avisem als consumidors */
      if (counter == N){
        write(fd1, &vector8, sizeof(int)*counter);
        write(fd2, &vector9, sizeof(int)*counter);
        counter = 0;

        kill(child1, SIGUSR1);
        kill(child2, SIGUSR2);


        while (!sigusr1 || !sigusr2) {};
        sigusr1 = 0;
        sigusr2 = 0;

      }
    }

    /* Si hem acabat de llegir el fitxer, però no quedaben N dades, tanquem els fitxers.
     * Els consumidors llegiran les dades dels fitxers, i quan arribin al final del fitxer sabran que no hi ha
     * més dades a llegir i terminarà el programa. */
    kill(child1, SIGUSR1);
    kill(child2, SIGUSR2);

    /* Espera activa */
    while (!sigusr1 || !sigusr2) {};
    sigusr1 = 0;
    sigusr2 = 0;

    write(fd1, &vector8, sizeof(int)*counter);
    write(fd2, &vector9, sizeof(int)*counter);

    kill(child1, SIGUSR1);
    kill(child2, SIGUSR2);

    /* Espera activa */
    while (!sigusr1 || !sigusr2) {};
    sigusr1 = 0;
    sigusr2 = 0;

    /* Tanquem el fitxer de dades */
    fclose(file);

    /* Tanquem els fitxers que actuaven com a buffers */
    close(fd1);
    close(fd2);

    /* Esperem a que acabin els fills */
    waitpid(child1, NULL, 0);
    waitpid(child2, NULL, 0);

    /* Eliminem els fitxers que feien com a buffers */
    remove("col8.bin");
    remove("col9.bin");
    printf("Pare finalitza!\n");

    return 0;
}

//Utilitzem aquesta funció per extreure informació del fitxer CSV que contingui informació sobre els trajectes
//Donada una línea llegida de fitxer la funció extrau les columnes 8 i 9
#define STRLEN_COLUMN 10
#define COLUMN8 8
#define COLUMN9 9

int get_column_fields_airport(int *column8, int *column9, char *line)
{
  /*Recorre la linea por caracteres*/
  char caracter;
  /* i sirve para recorrer la linea
   * iterator es para copiar el substring de la linea a char
   * coma_count es el contador de comas
   */
  int i, iterator, coma_count;
  /* start indica donde empieza el substring a copiar
   * end indica donde termina el substring a copiar
   * len indica la longitud del substring
   */
  int start, end, len;
  /* invalid nos permite saber si todos los campos son correctos
   * 1 hay error, 0 no hay error
   */
  int invalid = 0;
  /* found se utiliza para saber si hemos encontrado los dos campos:
   * origen y destino
   */
  int found = 0;
  /*
   * eow es el caracter de fin de palabra
   */
  char eow = '\0';
  /*
   * substring para extraer la columna
   */
  char substring[STRLEN_COLUMN];
  /*
   * Inicializamos los valores de las variables
   */
  start = 0;
  end = -1;
  i = 0;
  coma_count = 0;
  /*
   * Empezamos a contar comas
   */
  do {
    caracter = line[i++];
    if (caracter == ',') {
      coma_count ++;
      /*
       * Cogemos el valor de end
       */
      end = i;
      /*
       * Si es uno de los campos que queremos procedemos a copiar el substring
       */
      if (coma_count == COLUMN8 || coma_count == COLUMN9) {
        /*
         * Calculamos la longitud, si es mayor que 1 es que tenemos
         * algo que copiar
         */
        len = end - start;

        if (len > 1) {

          if (len > STRLEN_COLUMN) {
            printf("ERROR STRLEN_COLUMN\n");
            exit(1);
          }

          /*
           * Copiamos el substring
           */
          for(iterator = start; iterator < end-1; iterator ++){
            substring[iterator-start] = line[iterator];
          }
          /*
           * Introducimos el caracter de fin de palabra
           */
          substring[iterator-start] = eow;
          /*
           * Comprobamos que el campo no sea NA (Not Available)
           */

          switch (coma_count) {
            case COLUMN8:
              *column8 = atoi(substring);
              found++;
              break;
            case COLUMN9:
              *column9 = atoi(substring);
              found++;
              break;
            default:
              printf("ERROR in coma_count\n");
              exit(1);
          }

        } else {
          /*
           * Si el campo esta vacio invalidamos la linea entera
           */

          invalid = 1;
        }
      }
      start = end;
    }
  } while (caracter && invalid==0);

  if (found != 2)
    invalid = 1;

  return invalid;
}
