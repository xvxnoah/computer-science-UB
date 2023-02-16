#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/resource.h>

int main(int argc, char **arguments)
{
  int ret, maxproc;
  char *argv[2] = {"./fork-bomb", NULL};
  
  struct rlimit rl;

  maxproc = atoi(arguments[1]);

  rl.rlim_cur = maxproc;
  rl.rlim_max = maxproc;

  printf("Es limita el nombre total de processos a %d\n", maxproc);
  
  ret = fork();
  
  if (ret == 0) {  // fill
     printf("Soc el fill i el meu id es %d\n", getpid());
     setrlimit(RLIMIT_NPROC, &rl); // Limitem nombre maxim de processos 
     printf("Excuto el fork_bomb!!!\n");
     execv(argv[0], argv);
  } else { // pare
     printf("Soc el pare del proces %d\n", ret);
     return 0;
  }
}
