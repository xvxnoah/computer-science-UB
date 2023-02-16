#include <stdio.h>
#include <math.h>
#include <sys/fcntl.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stdlib.h>
#include <signal.h>

typedef float (*FILL_MATRIX_FUNC)(int, int);

struct Matrix {
    int numberOfRows;
    int numberOfColumns;
    float *grid;
    int fd;
};

/* Funció per crear una matriu buida donat un filepath i mapar-la a memòria */
struct Matrix createEmptyMatrix(int numberOfRows, int numberOfColumns, char* filepathPersistence){
    struct Matrix matrix;
    int fd;

    fd = open(filepathPersistence, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR);
    matrix.fd = fd;

    matrix.numberOfRows = numberOfRows;
    matrix.numberOfColumns = numberOfColumns;

    /* Creem la matriu buida segons la seva mida */
    ftruncate(matrix.fd, matrix.numberOfRows * matrix.numberOfColumns * sizeof(float*));
    
    /* Mapem a memòria la matriu */
    matrix.grid = (float *)mmap(NULL, (sizeof(float*) * matrix.numberOfRows * matrix.numberOfColumns), PROT_READ | PROT_WRITE, MAP_SHARED, matrix.fd, 0);
    close(fd);

    /* Comprovem si hi ha hagut errors en el mapat */
    if(matrix.grid == MAP_FAILED){
        printf("Error mmapping grid\n");
    }

    return matrix;
}

/* Funció que ens donarà els coeficients per omplir la matriu */
float VandermondeCoefficients(int row, int column){
    if(column == 0){
        return (float) 1.0;
    }
    return (float) pow(row, column);
}

/* Funció que ens omplirà la matriu ajundat-se dels punters */
void fillMatrix(struct Matrix *matrix, FILL_MATRIX_FUNC func){
    float *ptr = matrix->grid;
    for(int i = 0; i < matrix->numberOfRows; i++){
        for(int j = 0; j < matrix->numberOfColumns; j++){
            *(ptr) = func(i, j);
            *(ptr)++;
        }
    }
}

/* Funció que imprimirà la matriu donada */
void printMatrix(struct Matrix *matrix, char *name){
    float *ptr = matrix->grid;

    printf("%s\n", name);

    for (int i = 0; i < matrix->numberOfRows; ++i) {
        for(int j = 0; j < matrix->numberOfColumns; j++){
            printf("%f   ", *(ptr));
            *(ptr)++;
        }
        printf("\n");
    }
    printf("\n");
}

/* Funció per desmapar una matriu guardada a memòria en un filepath donat */
struct Matrix loadSavedMatrix(int numberOfRows, int numberOfColumns, char* filepath){
    struct Matrix loaded;
    int fd = open(filepath, O_RDONLY);

    loaded.fd = fd;
    loaded.numberOfRows = numberOfRows;
    loaded.numberOfColumns = numberOfColumns;
    loaded.grid = (float *) mmap(NULL, loaded.numberOfRows * loaded.numberOfColumns, PROT_READ, MAP_SHARED, loaded.fd, 0);

    return loaded;
}

/* Funció per multiplicar matrius de manera convencional */
struct Matrix naiveMultiplyMatrices(struct Matrix *A, struct Matrix *B, char* filePathPersistence){
    struct Matrix C = createEmptyMatrix(A->numberOfRows, B->numberOfColumns, filePathPersistence);

    float *ptrA = A->grid;
    float *ptrB = B->grid;
    float *ptrC = C.grid;
    float sum = 0;

    for (int i = 0; i < A->numberOfRows; i++) {
        for (int j = 0; j < B->numberOfColumns; j++) {
            int sum = 0;
            for (int k = 0; k < A->numberOfColumns; k++)
                sum = sum + (*(ptrA+i * A->numberOfColumns + k)) * (*(ptrB+k *B->numberOfColumns+j));

            *(ptrC+i * B->numberOfColumns + j) = sum;
        }
    }

    return C;
}

void multiplyMatricesProcessDelegation(int i, int i1, struct Matrix *pMatrix, struct Matrix *pMatrix1,
                                       struct Matrix *pMatrix2);

/* Funció per multiplicar matrius amb paral·lelisme donat un cert nombre de processos */
struct Matrix naiveMultiplyMatricesParallel(struct Matrix *A, struct Matrix *B, char* filePathPersistence, int numberOfProcesses){
    /* Calculem el nombre de files per a cada proces */
    int c = A->numberOfRows / numberOfProcesses; /* Divisio entera */
    int rowsAssigned;
    int ret;
    
    /* Creem la matriu resultat */
    struct Matrix resultMatrix = createEmptyMatrix(A->numberOfRows, B->numberOfColumns, filePathPersistence);

    /* Bucle segons el nombre de processos */
    for(int i = 0; i < numberOfProcesses; i++){
        rowsAssigned = c;

        if(i == numberOfProcesses-1){
            rowsAssigned += A->numberOfRows % numberOfProcesses; /* Residu, les r files no assignades seran les de l'ultim proces */
        }
        
        /* Creem un procés nou */
        ret = fork();

        if(ret == 0){
            multiplyMatricesProcessDelegation(c*i, rowsAssigned, A, B, &resultMatrix);
            exit(0);
        }
    }

    /* Control fork */
    for(int i = 0; i < numberOfProcesses; i++){
        wait(NULL);
    }

    return resultMatrix;
}

/* Funció que fa la multiplicació de la mateixa manera que la convencional però només entre unes files inicial i final */
void multiplyMatricesProcessDelegation(int initialRow, int finalRow, struct Matrix *A, struct Matrix *B, struct Matrix *resultMatrix) {
    float *ptrA = A->grid;
    float *ptrB = B->grid;
    float *ptrResult = resultMatrix->grid;

    for(int i = initialRow; i < finalRow; i++){
        for(int j = 0; j < B->numberOfColumns; j++){
            int sum = 0;

            for(int k = 0; k < A->numberOfColumns; k++){
                sum += (*(ptrA+i * A->numberOfColumns + k)) * (*(ptrB+k * B->numberOfColumns + j));
            }
            *(ptrResult+i * B->numberOfColumns + j) = sum;
        }
    }
}



