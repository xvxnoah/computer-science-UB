#include <stdio.h>
#include <sys/mman.h>
#include <unistd.h>
#include <time.h>
#include "matrix.h"

struct Matrix {
    int numberOfRows;
    int numberOfColumns;
    float *grid;
    int fd;
};

void exercici1();
void exercici2();
void exercici3();


int main() {
    exercici1();
    exercici2();
    exercici3();
}

void exercici1() {
    struct Matrix A, B;

    printf("::::::EXERCICI 1::::::\n");

    /* Crear les matrius */
    A = createEmptyMatrix(3, 3, "./matrixA.bin");
    B = createEmptyMatrix(3, 2, "./matrixB.bin");

    /* Omplir-les segons la funcio VandermondeCoefficients */
    fillMatrix(&A, VandermondeCoefficients);
    fillMatrix(&B, VandermondeCoefficients);

    /* Les imprimim per pantalla */
    printMatrix(&A, "Vandermonde matrix A with rows = 3 and columns = 3:");
    printMatrix(&B, "Vandermonde matrix B with rows = 3 and columns = 2:");

    /* Desfem el mapat a memoria de les matrius */
    if(munmap(A.grid, A.numberOfRows * A.numberOfColumns) != 0){
        printf("munmap error with matrix A\n");
    }

    if(munmap(B.grid, B.numberOfRows * B.numberOfColumns) != 0){
        printf("munmap error with matrix B\n");
    }

    /* Carreguem les matrius de memoria */
    struct Matrix savedA = loadSavedMatrix(3, 3, "./matrixA.bin");
    struct Matrix savedB = loadSavedMatrix(3, 2, "./matrixB.bin");

    /* Les imprimim per pantalla per comprovar que siguin les mateixes */
    printMatrix(&savedA, "Saved Matrix A:");
    printMatrix(&savedB, "Saved Matrix B");

    /* Desfem el mapat a memoria de les matrius */
    if(munmap(savedA.grid, savedA.numberOfRows * savedA.numberOfColumns) != 0){
        printf("munmap error with matrix A\n");
    }

    if(munmap(savedB.grid, savedB.numberOfRows * savedB.numberOfColumns) != 0){
        printf("munmap error with matrix B\n");
    }

    /* Eliminem els fitxers associats a la matriu */
    unlink("./matrixA.bin");
    unlink("./matrixB.bin");
}

void exercici2() {
    /* Creem les matrius */
    struct Matrix A = createEmptyMatrix(3, 3, "./matrixA.bin");
    struct Matrix B = createEmptyMatrix(3, 2, "./matrixB.bin");
    struct Matrix multWithoutParallelism;
    struct Matrix parallelism;

    printf("::::::EXERCICI 2::::::\n");

    /* Omplim les matrius */
    fillMatrix(&A, VandermondeCoefficients);
    fillMatrix(&B, VandermondeCoefficients);

    /* Les imprimim per pantalla */
    printMatrix(&A, "Vandermonde matrix A with rows = 3 and columns = 3:");
    printMatrix(&B, "Vandermonde matrix B with rows = 3 and columns = 2:");

    /* Multiplicacio sense paralelisme */
    multWithoutParallelism = naiveMultiplyMatrices(&A, &B, "./matrixNoParallelism.bin");
    printMatrix(&multWithoutParallelism, "A*B (NO parallelism):");

    /* Multiplicacio amb paralelisme */
    parallelism = naiveMultiplyMatricesParallel(&A, &B, "./matrixParalellism.bin", 4);
    printMatrix(&parallelism, "A*B (Parallelism):");

    /* Desfem el mapat a memoria de les matrius */
    if(munmap(A.grid, A.numberOfRows * A.numberOfColumns) != 0){
        printf("munmap error with matrix A\n");
    }

    if(munmap(B.grid, B.numberOfRows * B.numberOfColumns) != 0){
        printf("munmap error with matrix B\n");
    }

    if(munmap(multWithoutParallelism.grid, multWithoutParallelism.numberOfRows * multWithoutParallelism.numberOfColumns) != 0){
        printf("munmap error with matrix multWithoutParalellism\n");
    }

    if(munmap(parallelism.grid, parallelism.numberOfRows * parallelism.numberOfColumns) != 0){
        printf("munmap error with matrix multWithoutParalellism\n");
    }

    /* Eliminem els fitxers associats a les matrius */
    unlink("./matrixA.bin");
    unlink("./matrixB.bin");
    unlink("./matrixNoParallelism.bin");
    unlink("./matrixParalellism.bin");
}

void exercici3() {
    /* Creem les matrius */
    struct Matrix A = createEmptyMatrix(900, 900, "./matrixA.bin");
    struct Matrix B = createEmptyMatrix(900, 900, "./matrixB.bin");
    float tempsTotal = .0, tempsParcial = .0;
    clock_t start_t, end_t, start_p, end_p;

    printf("::::::EXERCICI 3::::::\n");

    /* Omplim les matrius */
    fillMatrix(&A, VandermondeCoefficients);
    fillMatrix(&B, VandermondeCoefficients);

    /* Calcul producte de 10 matrius sense paralelisme (no es crea una matriu resultat en el main
     * ja que nomes volem fer el calcul del producte, no imprimir la matriu) */
    start_t = clock();
    printf("NO PARALELLISM (TEMPS PARCIALS):\n");
    for(int i = 0; i < 10; i++){
        start_p = clock();
        naiveMultiplyMatrices(&A, &B, "./matrixNoParallelism.bin");
        end_p = clock();
        tempsParcial = (float) (end_p - start_p) / CLOCKS_PER_SEC;
        printf("%f\n", tempsParcial);
    }
    end_t = clock();
    tempsTotal = (float) (end_t - start_t) / CLOCKS_PER_SEC;

    printf("MITJANA TEMPS TOTAL: %f\n", tempsTotal/10);

    /* Desfem el mapat a memoria despres del primer experiment */
    if(munmap(A.grid, A.numberOfRows * A.numberOfColumns) != 0){
        printf("munmap error with matrix A\n");
    }

    if(munmap(B.grid, B.numberOfRows * B.numberOfColumns) != 0){
        printf("munmap error with matrix B\n");
    }

    /* Eliminem els fitxers associats a les matrius */
    unlink("./matrixA.bin");
    unlink("./matrixB.bin");
    unlink("./matrixNoParallelism.bin");

    /* Creem unes noves matrius per tal de dur a terme el seguent experiment */
    struct Matrix C = createEmptyMatrix(900, 900, "./matrixC.bin");
    struct Matrix D = createEmptyMatrix(900, 900, "./matrixD.bin");

    fillMatrix(&C, VandermondeCoefficients);
    fillMatrix(&D, VandermondeCoefficients);

    /* Calcul producte de 10 matrius amb paralelisme i amb 4 procesos (no es crea una matriu resultat en el main
     * ja que nomes volem fer el calcul del producte, no imprimir la matriu) */
    start_t = clock();
    printf("\nPARALELLISM (TEMPS PARCIALS):\n");
    for(int i = 0; i < 10; i++){
        start_p = clock();
        naiveMultiplyMatricesParallel(&C, &D, "./matrixParalellism.bin", 4);
        end_p = clock();
        tempsParcial = (float) (end_p - start_p) / CLOCKS_PER_SEC;
        printf("%f\n", tempsParcial);
    }
    end_t = clock();
    tempsTotal = (float) (end_t - start_t) / CLOCKS_PER_SEC;

    printf("MITJANA TEMPS TOTAL: %f\n", tempsTotal/10);

    /* Desfem el mapat a memoria despres del primer experiment */
    if(munmap(C.grid, C.numberOfRows * C.numberOfColumns) != 0){
        printf("munmap error with matrix A\n");
    }

    if(munmap(D.grid, D.numberOfRows * D.numberOfColumns) != 0){
        printf("munmap error with matrix B\n");
    }

    /* Eliminem els fitxers associats a les matrius */
    unlink("./matrixC.bin");
    unlink("./matrixD.bin");
    unlink("./matrixParalellism.bin");
}
