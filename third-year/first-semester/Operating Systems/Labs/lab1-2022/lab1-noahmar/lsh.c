/*
 * Main source code file for lsh shell program
 *
 * You are free to add functions to this file.
 * If you want to add functions in a separate file
 * you will need to modify Makefile to compile
 * your additional functions.
 *
 * Add appropriate comments in your code to make it
 * easier for us while grading your assignment.
 *
 * Submit the entire lab1 folder as a tar archive (.tgz).
 * Command to create submission archive:
      $> tar cvf lab1.tgz lab1/
 *
 * All the best
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <ctype.h>
#include <signal.h>
#include <sys/wait.h>
#include <readline/readline.h>
#include <readline/history.h>
#include <sys/file.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "parse.h"
#include <errno.h>

/* Global variables */
#define TRUE 1
#define FALSE 0

#define PIPE_READ 0
#define PIPE_WRITE 1
#define STDIN_FILENO 0
#define STDOUT_FILENO 1

/* Functions declaration */
void RunCommand(Command *);
void PrintPgm(Pgm *);
void stripwhite(char *);
void HandleSignals(int);
int DoExec(struct c *pgm);
int SetFileSTDIN(char *filename);
int SetFileSTDOUT(char *filename);
void RecursivePipe(Pgm *pgm, int *fd, char *input, int background);

pid_t parent_pid;
pid_t background_pid;

int main(void){
    Command cmd;
    int parse_result;

    parent_pid = getpid();

    /* Setup the signal handlers */
    signal(SIGINT, HandleSignals);
    signal(SIGCHLD, HandleSignals);

    while (TRUE){
        char *line;
        line = readline("> ");

        /* If EOF encountered, exit shell */
        if (!line){
            break;
        } else{
            /* Remove leading and trailing whitespace from the line */
            stripwhite(line);

            /* If stripped line not blank, add it to the history list and execute it */
            if (*line){
                add_history(line);

                /* Execute it */
                parse_result = parse(line, &cmd);

                /* If there's an error parsing the line */
                if(parse_result == -1){
                    fprintf(stderr, "Parsing failed\n");
                }
                /* Built-in command exit */
                else if(strcmp(cmd.pgm->pgmlist[0], "exit") == 0){
                    /* If user inputs exit, exit shell */
                    exit(0);
                }
                /* Built-in command cd */
                else if(strcmp(cmd.pgm->pgmlist[0], "cd") == 0){
                    if(cmd.pgm->next){ /* Not compatible with pipes (cd takes no input and produces no output), so we skip to the next command of the pipe */
                        cmd.pgm = cmd.pgm->next;
                        RunCommand(&cmd);
                        
                       if(!cmd.background){
                            /* Wait for all children to finish */
                            while(waitpid(0, NULL, 0)){
                                if(errno == ECHILD){
                                    break;
                                }
                            }
                       }
                    }
                    /* If cd is given with no arguments or with '~'*/
                    else if(cmd.pgm->pgmlist[1] == NULL || !strcmp(cmd.pgm->pgmlist[1], "~")){
                        chdir(getenv("HOME"));
                    }
                    /* Otherwise, we try to access the given directory */
                    else if(chdir(cmd.pgm->pgmlist[1]) != 0){
                        fprintf(stderr, "No such file or directory.\n");
                    }
                }
                /* Any other command, we execute it */
                else{
                    RunCommand(&cmd);

                    if(!cmd.background){
                        /* Wait for all children to finish */
                        while(waitpid(0, NULL, 0)){
                            if(errno == ECHILD){
                                break;
                            }
                        }
                    }
                }
            }
        }
        /* Clear memory */
        if(line){
            free(line);
        }
    }
    return 0;
}

/* Will be called when the process recieves specific signals */
void HandleSignals(int sig){
    /* If shell gets a SIGINT, ignore (so it does not kill the main thread) and reprint prompt */
    if(sig == SIGINT){
        printf("\n> ");
    } else if(sig == SIGCHLD){ /* Means child is terminated, so we avoid zombies */
        waitpid(-1, 0, WNOHANG);
    }
}

/* Function to run any processs given by the user */
void RunCommand(Command *cmd){
    struct c *pgm = cmd->pgm;

    /* If there are several commands we do the necessary piping */
    if(pgm->next){
        int fd[2];
        pipe(fd);

        /* We call to the recursive function to handle the pipe */
        RecursivePipe(pgm->next, fd, cmd->rstdin, cmd->background);

        pid_t pid = fork();

        if(pid < 0){
            fprintf(stderr, "Fork failed executing simple command.\n");
        } else if(pid > 0) { /* Parent */
            if(cmd->background) { /* We change the process group ID if it's a background process */
                background_pid = pid;
                setpgid(pid, background_pid);
            }
            close(fd[PIPE_READ]);
            close(fd[PIPE_WRITE]);
        } else if(pid == 0) { /* Child */
            if(cmd->background){ /* We change the process group ID if it's a background process */
                setpgid(0,0);
            }
            dup2(fd[PIPE_READ], 0);
            close(fd[PIPE_WRITE]);

            /* If the command has to redirect standard output */
            if(cmd->rstdout){
                if(SetFileSTDOUT(cmd->rstdout) != 1){ /* Error setting output */
                    exit(1);
                }
            }
            /* Execute the command */
            DoExec(pgm);
        }
    } else{ /* If there are no pipes */
        pid_t pid = fork();

        if(pid < 0){
            fprintf(stderr, "Fork failed executing simple command.\n");
        } else if(pid > 0 && cmd->background) { /* Parent (only does something if the command is set as background */
            background_pid = pid;
            setpgid(pid, background_pid);
        } else if(pid == 0) { /* Child*/
            if(cmd->background){
                setpgid(0,0);
            }

            /* If the command has to redirect standard output */
            if(cmd->rstdin){
                if(SetFileSTDIN(cmd->rstdin) != 1) { /* Error setting input */
                    exit(1);
                }
            }

            /* If the command has to redirect standard input */
            if(cmd->rstdout){
                if(SetFileSTDOUT(cmd->rstdout) != 1) { /* Error setting output */
                    exit(1);
                }
            }
            /* Execute the command */
            DoExec(pgm);
        }
    }
}

/*
 * Recursive function to execute pipes.
 * Commands take their inputs from last-to-first into the pipe.
 *
 * Parameters:
 * pgm -> Program to execute
 * fd -> Pipe to the program listening to this one
 * input -> If set the last program will use it as its own input
 * background -> If true the main thread will not wait for the program to finish and will set it to another process group.
 *
 *
 */
void RecursivePipe(Pgm *pgm, int *fd, char *input, int background){
    /* We check first if there are more commands */
    if(pgm->next){
        int fd2[2];
        pipe(fd2);

        /* If it's not the last command, continue calling recursively */
        RecursivePipe(pgm->next, fd2, input, background);

        pid_t pid = fork();

        if(pid < 0){
            fprintf(stderr, "Fork failed executing piped command.\n");
        } else if(pid > 0) { /* Parent */
            if(background){
                setpgid(pid, background_pid);
            }
            close(fd2[PIPE_READ]);
            close(fd2[PIPE_WRITE]);
        } else if(pid == 0) { /* Child */
            if(background){
                setpgid(0, background_pid);
            }

            /* We make this thread take input from below and send the output upwards, basically we communicate the corresponding commands */
            dup2(fd2[PIPE_READ], 0);
            dup2(fd[PIPE_WRITE], 1);
            close(fd2[PIPE_WRITE]);
            close(fd[PIPE_READ]);
            DoExec(pgm);
        }
    } else{ /* We are in the last command */
        pid_t pid = fork();

        if(pid < 0){
            fprintf(stderr, "Fork failed executing piped command.\n");
        } else if(pid > 0 && background) { /* Parent */
            setpgid(pid, background_pid);
        } else if(pid == 0) { /* Child */
            if(background) {
                setpgid(0, background_pid);
            }

            dup2(fd[PIPE_WRITE], 1);
            close(fd[PIPE_READ]);

            /* If there is a speecified input, we should us it as stdin */
            if(input){
                if(SetFileSTDIN(input) != 1){ /* We do not continue executing regarding an error occured when setting input */
                    exit(1);
                }
            }
            DoExec(pgm);
        }
    }
}

/* Executes a command with all its parameters.
 * Exits with code 1 if failed to execute the command.
 */
int DoExec(struct c *pgm){
    /* If cd arrived here it means it came from a pipe, so we shouldn't do anything with it */
    if(strcmp(pgm->pgmlist[0], "cd") == 0){
        exit(1);
    } else{
        /* Execute the requested command, execvp handles the path */
        int ret = execvp(pgm->pgmlist[0], pgm->pgmlist);

        if (ret < 0){
            fprintf(stderr, "Invalid command: %s\n", pgm->pgmlist[0]);
            exit(1);
        }
    }
}

/* Method for setting a file as standard input */
int SetFileSTDIN(char *filename){
    int fd = open(filename, O_RDONLY);

    if(fd == -1){
        char *errmsg = strerror(errno);
        fprintf(stderr, "%s %s\n", errmsg, filename);
        return -1;
    }
    close(0); /* Close standard input */
    dup2(fd, STDIN_FILENO); /* Adjust the file descriptor of the file so it corresponds with the standard input */
    close(fd); /* Close file descriptor of the file */
    return 1;
}

/* Method for setting a file as standard output */
int SetFileSTDOUT(char *filename){
    FILE *f = fopen(filename, "w");

    /* If fopen failed*/
    if(f == NULL) {
        char *errmsg = strerror(errno);
        fprintf(stderr, "%s %s\n", errmsg, filename);
        return -1;
    }

    close(1); /* Close standard output */
    dup2(fileno(f), STDOUT_FILENO); /* Adjust the file descriptor of the file so it corresponds with the standard output */
    fclose(f); /* Close file descriptor of the file */
    return 1;
}

/* Print a (linked) list of Pgm:s.
 *
 * Helper function, no need to change. Might be useful to study as inpsiration.
 */
void PrintPgm(Pgm *p)
{
    if (p == NULL)
    {
        return;
    }
    else
    {
        char **pl = p->pgmlist;

        /* The list is in reversed order so print
         * it reversed to get right
         */
        PrintPgm(p->next);
        printf("            * [ ");
        while (*pl)
        {
            printf("%s ", *pl++);
        }
        printf("]\n");
    }
}

/* Strip whitespace from the start and end of a string.
 *
 * Helper function, no need to change.
 */
void stripwhite(char *string)
{
    register int i = 0;

    while (isspace(string[i]))
    {
        i++;
    }

    if (i)
    {
        memmove(string, string + i, strlen(string + i) + 1);
    }

    i = strlen(string) - 1;
    while (i > 0 && isspace(string[i]))
    {
        i--;
    }

    string[++i] = '\0';
}
