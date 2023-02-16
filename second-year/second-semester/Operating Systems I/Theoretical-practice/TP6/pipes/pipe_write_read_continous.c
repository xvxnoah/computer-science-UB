#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

int main(void)
{
  int i, fd[2];
  char c;

  pipe(fd);

  if (fork() == 0) { // child
    printf("child writing to file descriptor #%d\n", fd[1]);

    i = 0;
    c = 'a';
    while (1) {  // infinite loop !!!
      write(fd[1], &c, 1);
      i++;
      c++;
      if (c == 'z') c = 'a';
      printf("%04d Bytes written\n", i);
    }

    exit(0);
  } else { // parent
    
    i = 1;
    while (1) {  // infinite loop !!!
      read(fd[0], &c, 1);
      printf("Parent read byte %d: %c\n", i, c);
      i++;
    }

    wait(NULL);
  }

  return 0;
}
