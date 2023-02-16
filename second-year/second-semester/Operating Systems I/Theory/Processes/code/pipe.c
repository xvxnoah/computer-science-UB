#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(void)
{
  int fd[2];
  char buf[30];

  if (pipe(fd) == -1) {
    fprintf(stderr, "pipe not created");
    exit(1);
  }

  printf("writing to file descriptor #%d\n", fd[1]);
  write(fd[1], "test", 4);
  printf("reading from file descriptor #%d\n", fd[0]);
  read(fd[0], buf, 4);
  buf[4] = 0;
  printf("read \"%s\"\n", buf);

  return 0;
}
