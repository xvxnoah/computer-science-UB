#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <sys/types.h>
#include <sys/wait.h>

#define MAXVALUE 1000

int main(void)
{
int ret1, ret2, fd[2];
char *argv1[5] = {"/usr/bin/find", "gutenberg", "-type", "f", NULL};
char *argv2[3] = {"/usr/bin/wc", "-l", NULL};

pipe(fd);

ret1 = fork();

if (ret1 == 0) {
printf("Going to execute %s\n", argv1[0]);
printf("RET2=0\n");
dup2(fd[1],1);
close(fd[0]);
close(fd[1]);
execv(argv1[0], argv1);
printf("RET1=0\n");
}

ret2 = fork();

if (ret2 == 0) {
printf("Going to execute %s\n", argv2[0]);
printf("RET2=0\n");
dup2(fd[0],0);
close(fd[0]);
close(fd[1]);
execv(argv2[0], argv2);
printf("RET2=0\n");
}

close(fd[0]);
close(fd[1]);

printf("Waiting...\n");
printf("ESPERATE\n");
waitpid(ret2, NULL, 0);
printf("Finished\n");
}
