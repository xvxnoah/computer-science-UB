#include <stdio.h>
#include <unistd.h>
#include <string.h>

int main(void)
{
    int i, count;
    
    i = 25;
    printf("El valor es %d\n", 25);
    
    char *vector = "EL VALOR ES 25\n";
    int nbytes = strlen(vector);
    count = write(1, vector, nbytes);
    
    return 0;
}
