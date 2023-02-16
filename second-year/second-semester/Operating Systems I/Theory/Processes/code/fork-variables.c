#include <stdio.h>
#include <unistd.h>

int main(void)
{
  int ret, a;

  a = 1;
  
  ret = fork();
  
  if (ret == 0) {  // fill
     printf("Soc el fill i el meu id es %d\n", getpid());
     printf("Fill a = %d\n", a); // s'imprimeix a = 1!
     return 0;
  } else { // pare
     a = 2;
     printf("Soc el pare del proces %d\n", ret);
     printf("Pare a = %d\n", a); // s'imprimeix a = 2!
     return 0;
  }
}
