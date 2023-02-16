#include <stdio.h>
#include <unistd.h>

int main(void)
{
  int ret;
  char *argv[3] = {"/usr/bin/ls", "-l", NULL};

  ret = fork();

  if (ret == 0) {  // fill
    printf("Soc el fill i el meu id es %d\n", getpid());
    execv(argv[0], argv);
  } else { // pare
    printf("Soc el pare del proces %d\n", ret);
    return 0;
  }
}
