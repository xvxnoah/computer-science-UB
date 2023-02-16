#include <stdio.h>
#include <unistd.h>

int main(void)
{
  int ret;
  
  ret = fork();
  
  if (ret == 0) {  // fill
     printf("Soc el fill i el meu id es %d\n", getpid());
     return 0;
  } else { // pare
     printf("Soc el pare del proces %d\n", ret);
     return 0;
  }
}
