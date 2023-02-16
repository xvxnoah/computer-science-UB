#include <stdio.h>

int main(void)
{
  int a = 0;

  while (1) {
    if (a % 10000 == 0)
      printf("a = %d\n", a);
    a++;
  }
}
