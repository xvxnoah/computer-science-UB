#include <stdio.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <fcntl.h>

int main(void)
{
  int ret;
  char *argv[3] = {"/usr/bin/ls", "-l", NULL};

  ret = fork();

  if (ret == 0) {  // fill
    // obrim fitxer
    int fd = open("fitxer.txt", O_RDWR | O_CREAT, S_IRUSR | S_IWUSR);
    dup2(fd, 1); // associem fd al descriptor 1
    close(fd);   // tanquem fd
    execv(argv[0], argv); // executem programa
  } else { // pare
    printf("Soc el pare del proces %d\n", ret);
    wait(NULL);
    printf("Torno a ser el pare un cop el fill ha acabat\n");
    return 0;
  }
}


