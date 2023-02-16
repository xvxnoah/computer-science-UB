#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/wait.h>

#define MAXVALUE 1000

/* Handle sigusr1 signal */
void sigusr1(int signo)
{
  printf("El pare ha rebut el SIGUSR1\n");
}

/* Handle sigusr2 signal */
void sigusr2(int signo)
{
  printf("El fill ha rebut el SIGUSR2\n");
}

int main(void)
{
    /* Variables */
    int i, num_values, value, sum, fd[2];
    int ret, parent_pid, child_pid;
    
    /* Create the pipe */
    pipe(fd);

    /* Save parent process ID before fork */
    parent_pid = getpid();

    /* Do the fork */
    ret = fork();

    if (ret == 0) { // child
        /* Inserir codi aqui per gestionar senyals (esperem al pare) */
        sleep(1);
       
        /* Esperar a rebre senyal del pare */
        signal(SIGUSR2,sigusr2);
        
        /* Llegir el nombre de valors que ens envia el pare */
        read(fd[0], &num_values, sizeof(num_values));

        i = 0;
        sum = 0;
        while (i < num_values) {
            /* Llegir valors de la canonada i fer la suma */
            read(fd[0], &value, sizeof(value));
            sum += value;
            i++;
        }
    
        printf("El fill escriu el resultat: %d\n", sum);

        /* Escriure el valor de la suma a la canonada */
        write(fd[1], &sum, sizeof(sum));

        /* Avisar al pare que s'han escrit els valors */ 
        kill(parent_pid, SIGUSR1);

        exit(0);
    } else { // parent
 
        /* Inserir codi aqui per esperar senyal del fill */
        signal(SIGUSR1,sigusr1);

        /* Save child's process ID */
        child_pid = ret;

        /* Random seed */
        srand(time(NULL));

        i = 0;
       
        /* Escriure aquest valor a la canonada */
        num_values = 50000;
        write(fd[1], &num_values, sizeof(num_values));

        while (i < num_values) {  
            /* Generar valor aleatori i inserir a la canonada */
            value = rand() % MAXVALUE + 1;
            write(fd[1], &value, sizeof(value));
            i++;
        }

        /* Send signal to child */
        kill(child_pid, SIGUSR2);

        /* Waiting for answer */
        printf("El pare espera la suma...\n");

        /* Inserir codi aqui per gestionar senyals */
        wait(NULL);

        /* Llegir el resultat */
        read(fd[0], &sum, sizeof(sum));
        printf("El fill em diu que la suma es: %d\n", sum);

        exit(0);
    }

    return 0;
}
