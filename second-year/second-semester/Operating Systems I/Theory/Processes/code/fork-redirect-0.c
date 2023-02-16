#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(void)
{
  int ret;
  char *argv[2] = {"./scanf",  NULL};

  ret = fork();

  if (ret == 0) {  // fill
    // obrim fitxer
    int fd = open("linies.txt", O_RDONLY);
    dup2(fd, 0); // associem fd al descriptor 0
    close(fd);   // tanquem fd
    execv(argv[0], argv); // executem programa
  } else { // pare
    printf("Soc el pare del proces %d\n", ret);
    wait(NULL);
    printf("Torno a ser el pare un cop el fill ha acabat\n");
    return 0;
  }
}


