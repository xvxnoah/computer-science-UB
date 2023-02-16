#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
  FILE *fp;
  int i;

  if (argc != 2) {
    printf("%s <file>\n", argv[0]);
    exit(1);
  }

  fp = fopen(argv[1], "r");
  if (!fp) {
    printf("Could not open file\n");
    exit(1);
  }

  while (fscanf(fp, "%d", &i)==1)
    printf("%d\n", i);

  printf("Closing the file\n");
  
  fclose(fp);

  return 0;
}
