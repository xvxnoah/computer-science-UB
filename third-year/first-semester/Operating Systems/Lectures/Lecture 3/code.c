#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

int main() {
    pid_t pid1, pid2, pid3;
    pid1 = getpid();

    printf("PID1: %d\n", pid1);
    pid2 = fork();
    pid3 = getpid();
    printf("PID2: %d\n", pid2);
    printf("PID3: %d\n", pid3);

    if(pid3 == pid1){
        printf("I am the child process");
    }
    return 0;
}
