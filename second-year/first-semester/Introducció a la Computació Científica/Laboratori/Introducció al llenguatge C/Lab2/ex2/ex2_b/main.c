/* Ca`lcul del producte escalar de dos vectors usant memo`ria dina`mica*/
#include<stdio.h>
#include <stdlib.h>

int main(void){
    int n, i, k;
    float *x, *y, prod;
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
    fscanf(entrada, "%d", &n);

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

    fclose(entrada);

    prod = 0.f;
    for (i = 0; i<n; i++){
        prod += x[i]*y[i];
    }

    sortida = fopen(fitxer_sortida, "w");

    if(sortida == NULL){
        printf("Error en obrir el fitxer %s\n", fitxer_sortida);
        exit(1);
    }

    fprintf(sortida, "El producte escalar val: %16.7e \n", prod);
    fclose(sortida);

    free(x);
    free(y);
    return 0;
}
