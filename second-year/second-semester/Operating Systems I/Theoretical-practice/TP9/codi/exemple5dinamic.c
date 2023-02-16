#include <stdio.h>
#include <stdlib.h>

int main(void)
{
  int i;
  char **a; // matriu de 10x10 de char

  a = (char **) malloc(sizeof(char *) * 10);     // Pas 1
  for(i = 0; i < 10; i++)                        // Pas 2
    a[i] = (char *) malloc(sizeof(char) * 10); // Pas 2

  a[0][0] = 0;
  a[0][0] = a[0][0] + 1;

  for(i = 0; i < 10; i++)                        // Pas 3
    free(a[i]);                                // Pas 3
  free(a);                                       // Pas 4

  return 0;
}
