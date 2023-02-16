#include <stdio.h>
#include <string.h>

int main(void)
{
    int i;
    char str[200];
    
    i = 1;
    while (scanf("%s", str) > 0) {
        printf("Longitud linia %d: %d\n", i, (int) strlen(str));
        i++;
    }
    
    return 0;
}
