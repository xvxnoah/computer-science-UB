#include<stdio.h>
#include <stdlib.h>
#include <math.h>

float prod_esc(int n, float *x, float *y);
int main(void){
    int n, i, k;
    float *x, *y, prod;
    float tol = 0.0;
    FILE *entrada, *sortida;
    char fitxer_entrada[80];
    char fitxer_sortida[80];

    printf("# Doneu el nom del fitxer d'entrada: \n");
    k = scanf("%s", fitxer_entrada);
    entrada = fopen(fitxer_entrada, "r");

    if(entrada == NULL){
        printf("Error en obrir el fitxer %s\n", fitxer_entrada);
        exit(1);
    }
    fscanf(entrada, "%d", &n); /*Dimensió dels vectors*/

    x = (float *) malloc(n * sizeof(float));
    y = (float *) malloc(n * sizeof(float));

    if ( x == NULL || y == NULL){
        printf("No hi ha prou memòria");
        return 1;
    }

    printf("# Doneu el nom del fitxer de sortida: \n");
    k = scanf("%s", fitxer_sortida);



    for (i = 0; i<n; i++){
        fscanf(entrada, "%f", &x[i]);
    }

    for (i = 0; i<n; i++){
        fscanf(entrada, "%f", &y[i]);
    }

    fscanf(entrada, "%f", &tol); /*Llegim la tolerància del fitxer*/

    fclose(entrada);

    prod = prod_esc(n, x, y); /*Cridem a la funció externa*/

    sortida = fopen(fitxer_sortida, "w");

    if(sortida == NULL){
        printf("Error en obrir el fitxer %s\n", fitxer_sortida);
        exit(1);
    }

    if(fabs(prod) < tol){
        fprintf(sortida, "Els vectors són ortogonals \n");
    } else{
        fprintf(sortida, "Els vectors NO són ortogonals \n");
    }

    free(x);
    free(y);
    fclose(sortida);
    return 0;
}
