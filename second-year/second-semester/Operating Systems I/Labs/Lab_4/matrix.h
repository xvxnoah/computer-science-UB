#ifndef PRACTICA4_MATRIX_H
#define PRACTICA4_MATRIX_H

typedef float (*FILL_MATRIX_FUNC)(int, int);

struct Matrix createEmptyMatrix(int numberOfRows, int numberOfColumns, char* filepathPersistence);
float VandermondeCoefficients(int row, int column);
void fillMatrix(struct Matrix *matrix, FILL_MATRIX_FUNC func);
void printMatrix(struct Matrix *matrix, char *name);
struct Matrix loadSavedMatrix(int numberOfRows, int numberOfColumns, char* filepath);
struct Matrix naiveMultiplyMatrices(struct Matrix *A, struct Matrix *B, char* filePathPersistence);
struct Matrix naiveMultiplyMatricesParallel(struct Matrix *A, struct Matrix *B, char* filePathPersistence, int numberOfProcesses);
void multiplyMatricesProcessDelegation(int initialRow, int finalRow, struct Matrix *A, struct Matrix *B, struct Matrix *resultMatrix);
#endif

