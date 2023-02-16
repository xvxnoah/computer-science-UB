#include <stdio.h>
#include <stdlib.h>

void prodMatMat(double **a, double **b, double **result, int n, int m, int p){
    int i, j, k;

    for (i = 0; i < n; i++) {
        for (j = 0; j < m; j++) {
            for (k = 0; k < p; k++) {
                result[i][j] += a[i][k] * b[k][j];
            }
        }
    }
}
