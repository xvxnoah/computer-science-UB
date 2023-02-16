#include<stdio.h>
#include <stdlib.h>

float prod_esc(int n, float *x, float *y){
    int i;
    float prod = 0.f;

    for (i = 0; i<n; i++){
        prod += x[i]*y[i];
    }

    return prod;
}
