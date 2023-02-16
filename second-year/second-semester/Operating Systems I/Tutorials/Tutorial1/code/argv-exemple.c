#include <stdio.h>

int main(int argc, char *argv[])
{
    int i;
    
    printf("-----------------------\n");
    
    for(i = 1; i < argc; i++)  /* Skip argv[0] which is the program name */
        printf("Argument %i: %s\n", i, argv[i]);
    
    printf("-----------------------\n");
    
    return 0;
}
