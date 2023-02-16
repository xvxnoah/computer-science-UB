#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <sys/wait.h>


int get_column_fields_airport(int *column8, int *column9, char *line);
void productor(FILE *file);

static int parent_pid, child1_pid, child2_pid;

int segusr1 = 0;
int segusr2 = 0;
static int n;

void sigusr1(int signo){
    segusr1 = 1;
}

void sigusr2(int signo){
    segusr2 = 1;
}

void productor(FILE *file){
    int invalid, value_col8, value_col9, count = 0;
    char line[256];
    int buf8[n];
    int buf9[n];

    remove("col8.bin");
    remove("col9.bin");

    /* Notifiquem als consumidors que els fitxers han estat creats */
    int col8 = open("col8.bin", O_WRONLY | O_CREAT | O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
    int col9 = open("col9.bin", O_WRONLY | O_CREAT | O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);

    kill(child1_pid, SIGUSR1);
    kill(child2_pid, SIGUSR2);

    /* Espera activa*/
    while(!segusr1 || !segusr2);
    segusr1 = 0;
    segusr2 = 0;

    /* We ignore the header of the file */
    fgets(line, sizeof(line), file);

    /* Read the whole file */
    while(fgets(line, sizeof(line), file)){
        invalid = get_column_fields_airport(&value_col8, &value_col9, line);

        /* Escrivim col 8 i 9; augmentem count */
        if(!invalid) {
            buf8[count] = value_col8;
            buf9[count] = value_col9;
        }

        count++;

        /* Si ja hem llegit N dades del bloc, avisem als consumidors */
        if(count == n){
            write(col8, &buf8, sizeof(int)*count);
            write(col9, &buf9, sizeof(int)*count);
            count = 0;

            kill(child1_pid, SIGUSR1);
            kill(child2_pid, SIGUSR2);

            while(!segusr1 || !segusr2);
            segusr1 = 0;
            segusr2 = 0;
        }
    }

    /* Si hem acabat de llegir el fitxer, però no quedaben N dades, tanquem els fitxers.
     *
     * Els consumidors llegiran les dades dels fitxers, i quan arribin al final del fitxer sabran que no hi ha
     * més dades a llegir i terminarà el programa. */

    kill(child1_pid, SIGUSR1);
    kill(child2_pid, SIGUSR2);

    while(!segusr1 || !segusr2);
    segusr1 = 0;
    segusr2 = 0;

    write(col8, &buf8, sizeof(int)*count);
    write(col9, &buf9, sizeof(int)*count);

    kill(child1_pid, SIGUSR1);
    kill(child2_pid, SIGUSR2);

    while(!segusr1 || !segusr2);
    segusr1 = 0;
    segusr2 = 0;

    fclose(file);
    close(col8);
    close(col9);

    /* Esperem a que els processos fills calculin els resultats */
    waitpid(child1_pid, NULL, 0);
    waitpid(child2_pid, NULL, 0);
    remove("col8.bin");
    remove("col9.bin");
    printf("Pare finalitza!\n");
}



void consumidor8(void){
    unsigned long int passenger_count = 0, num_elements_col8 = 0;
    int value, col8, buf8[n];

    /* Esperem a que el productor ens notifiqui de la creació del fitxer */
    while (!segusr1);
    segusr1 = 0;

    /* Avisem al productor de que hem rebut la notificació */
    kill(parent_pid, SIGUSR1);

    col8 = open("col8.bin", O_RDONLY);

    /*
    if(!col8){
        printf("Could not open file '%s'\n", "col8.bin");
        exit(1);
    }
    */
    while(!segusr1); /* Espera activa a que el productor ens permeti llegir el fitxer */
    segusr1 = 0;
    kill(parent_pid, SIGUSR1);

    /* Bucle per llegir les dades del fitxer creades pel productor */
    while(read(col8, buf8, sizeof(int)*n)){
        for(int i = 0; i < n; i++){
            passenger_count += buf8[i];
            num_elements_col8++;
        }

        while(!segusr1);
        segusr1 = 0;
        kill(parent_pid, SIGUSR1);
    }

    while(!segusr1);
    segusr1 = 0;
    kill(parent_pid, SIGUSR1);

    while(read(col8, &value, sizeof(int))){
        passenger_count += value;
        num_elements_col8++;
    }

    /*
    while(read(col8, &value, sizeof(int))){
        passenger_count += value;
        num_elements_col8++;
    }
    */

    /* Si no s'ha llegit res, retornem un error */
    if(num_elements_col8 == 0){
        printf("Number of elements is zero!!\n");
        exit(1);
    }

    /* Calculem la mitja de les dades llegides */
    float pc = 0;
    pc = (float)passenger_count / (float) num_elements_col8;

    /* Indica la mitjana dels passatgers */
    printf("Col8: Aplication read %ld elements\n", num_elements_col8);
    printf("Col8: Mean of passengers: %f\n", pc);

    close(col8);
}

void consumidor9(void){
    unsigned long int trip_time_in_secs = 0, num_elements_col9 = 0;
    int value, col9, buf9[n];

    /* Esperem a que el productor ens notifiqui de la creació del fitxer */
    while (!segusr2);
    segusr2 = 0;

    /* Avisem al productor de que hem rebut la notificació */
    kill(parent_pid, SIGUSR2);

    col9 = open("col9.bin", O_RDONLY);

    /*
    if(!col9){
        printf("Could not open file '%s'\n", "col8.bin");
        exit(1);
    }
    */
    while(!segusr2); /* Espera activa a que el productor ens permeti llegir el fitxer */
    segusr2 = 0;
    kill(parent_pid, SIGUSR2);


    while(read(col9, buf9, sizeof(int)*n)){
        for(int i = 0; i < n; i++){
            trip_time_in_secs += buf9[i];
            num_elements_col9++;
        }

        while(!segusr2);
        segusr2 = 0;
        kill(parent_pid, SIGUSR2);
    }

    while(!segusr2);
    segusr2 = 0;
    kill(parent_pid, SIGUSR2);

    while(read(col9, &value, sizeof(int))){
        trip_time_in_secs += value;
        num_elements_col9++;
    }

    /* Bucle per llegir les dades del fitxer creades pel productor */
    /*
    while(read(col9, &value, sizeof(int))){
        trip_time_in_secs += value;
        num_elements_col9++;
    }
    */
    /* Si no s'ha llegit res, retornem un error */
    if(num_elements_col9 == 0){
        printf("Number of elements is zero!!\n");
        exit(1);
    }

    /* Calculem la mitja de les dades llegides */
    float tt = 0;
    tt = (float)trip_time_in_secs / (float)num_elements_col9;

    /* Indica la mitjana del temps de viatge */
    printf("Col9: Aplication read %ld elements\n", num_elements_col9);
    printf("Col9: Mean of trip time: %f secs\n", tt);
    close(col9);
}

int main(int argc, char *argv[]){
    int child1, child2;
    FILE *data;

    //n = atoi(argv[2]);
    n = 400;

    /* Check if number of arguments is correct
    if(argc != 3){
        printf("%s <file> <N> \n", argv[0]);
        exit(1);
    } else if(n < 1){
        printf("N must be > 1\n");
        exit(1);
    }
     */

    /* Open the file and check if exists*/
    //char *filename = argv[1];
    data = fopen("data.csv", "r");

    if(!data){
        printf("ERROR: could not open '%s'\n", "data.csv");
        exit(1);
    }

    /* Definim els senyals */
    signal(SIGUSR1, sigusr1);
    signal(SIGUSR2, sigusr2);

    parent_pid = getpid();

    child1 = fork();

    if(child1 == 0){
        child1_pid = getpid();
        consumidor8();
        return 0;
    }

    child2 = fork();
    if(child2 == 0){
        child2_pid = getpid();
        consumidor9();
        return 0;
    }
    productor(data);

    return 0;
}


/**
 * Esta funcion se utiliza para extraer informacion del fichero CSV que
 * contiene informacion sobre los trayectos. En particular, dada una linea
 * leida de fichero, la funcion extrae las columnas 8 y 9.
 */

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
