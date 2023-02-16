#include <stdio.h>
#include <unistd.h>
#include <sys/resource.h>

int main(void)
{
  int ret;
  char *argv[2] = {"./while-infinit", NULL};
  
  struct rlimit rl;
  
  rl.rlim_cur = 1;
  rl.rlim_max = 1;
  
  ret = fork();
  
  if (ret == 0) {  // fill
     printf("Soc el fill i el meu id es %d\n", getpid());
     setrlimit(RLIMIT_CPU, &rl); // Limitem a 1 segon de CPU
     execv(argv[0], argv);
  } else { // pare
     printf("Soc el pare del proces %d\n", ret);
     return 0;
  }
}
