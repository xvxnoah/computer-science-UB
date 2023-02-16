#include <stdio.h>
#include <stdlib.h>

void prodMatVec(double **a, double *u, double *v, int n, int m){
    int i, j;

    for (i = 0; i < n; i++){
        v[i] = 0.f;
        for(j = 0; j < m; j++){
            v[i] += a[i][j] * u[j];
        }
    }
}
