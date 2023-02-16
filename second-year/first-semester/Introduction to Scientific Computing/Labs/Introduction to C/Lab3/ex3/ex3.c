/*  Calcul del producte d'una matriu per un vector usant memoria dinamica */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

void prodMatMat(double **a, double **b, double **result, int n, int m, int p);

int main (void)
{
	int n, m, i, j, k, p;
	double **a, **b, **result;

    FILE *entrada;
    char fitxer_entrada[80];

    printf("# Doneu el nom del fitxer d'entrada: \n");
    k = scanf("%s", fitxer_entrada);
    entrada = fopen(fitxer_entrada, "r");

    if(entrada == NULL){
        printf("Error en obrir el fitxer %s\n", fitxer_entrada);
        exit(1);
    }

	fscanf (entrada, "%d %d %d", &n, &p, &m); /*Dimensions de les matrius */

	a = (double **) malloc (n * sizeof (double *)); /* n files */

	if (a == NULL) {
		printf ("No hi ha prou memoria\n");
		exit (1);
	}

	for (i = 0; i < n; i++) {
		a[i] = (double *) malloc (p * sizeof (double)); /* p columnes */
		if (a[i] == NULL) {
			printf ("No hi ha prou memoria\n");
			exit (2);
		}
	}

	b = (double **) malloc (p * sizeof (double)); /* p files */

    if (b == NULL) {
        printf ("No hi ha prou memoria\n");
		exit (1);
	}

	for (i = 0; i < p; i++) {
		b[i] = (double *) malloc (m * sizeof (double)); /* m columnes */
		if (b[i] == NULL) {
			printf ("No hi ha prou memoria\n");
			exit (2);
		}
	}

	/* Inicialitzar la matriu resultat*/
    result = (double **) malloc (n * sizeof (double *));

    for (i = 0; i < n; i++) {
		result[i] = (double *) malloc (m * sizeof (double)); /* m columnes */
		if (result[i] == NULL) {
			printf ("No hi ha prou memoria\n");
			exit (2);
		}
	}

	/* Valors de la matriu A */
	for (i = 0; i < n; i++) {
		for (j = 0; j < p; j++) {
			fscanf (entrada, "%le", &a[i][j]);
		}
	}

	/* Valors de la matriu B */
    for (i = 0; i < p; i++) {
        for (j = 0; j < m; j++) {
            fscanf (entrada, "%le", &b[i][j]);
        }
    }

    prodMatMat(a, b, result, n, m, p);

	fclose(entrada);

	printf ("El producte de la matriu A =\n");
	for (i = 0; i < n; i++) {
		for (j = 0; j < p; j++) {
			printf (" %16.7e", a[i][j]);
		}
		printf ("\n");
	}

	printf("per la matriu B = \n");
	for (i = 0; i < p; i++) {
        for (j = 0; j < m; j++) {
            printf(" %16.7e", b[i][j]);
        }
        printf("\n");
    }

	printf (" ens dóna = \n");

    for (i = 0; i < n; i++) {
        for(j = 0; j < m; j++) {
            printf("%f  ", result[i][j]);
            if(j == m - 1){
                printf("\n");
            }
        }
    }

    for (i = 0; i < n; i++)
		free (a[i]);

    for(i= 0; i < p; i++)
        free (b[i]);

    for (i = 0; i < n; i++)
        free (result[i]);

    free (a);
    free (b);
    free (result);

	return 0;
}
