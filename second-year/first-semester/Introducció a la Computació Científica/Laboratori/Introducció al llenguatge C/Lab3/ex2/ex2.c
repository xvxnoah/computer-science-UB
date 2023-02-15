/*  Calcul del producte d'una matriu per un vector usant memoria dinamica */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

void prodMatVec(double **a, double *u, double *v, int n, int m);
int main (void)
{
	int n, m, i, j, k;
	double **a, **b, *u, *v, *y;
    float mod_u = 0.0f;
    float mod_y = 0.0f;
    float quocient;
    float temp;

    FILE *entrada;
    char fitxer_entrada[80];

    printf("# Doneu el nom del fitxer d'entrada: \n");
    k = scanf("%s", fitxer_entrada);
    entrada = fopen(fitxer_entrada, "r");

    if(entrada == NULL){
        printf("Error en obrir el fitxer %s\n", fitxer_entrada);
        exit(1);
    }

	fscanf (entrada, "%d %d", &n, &m); /*Dimensions de la matriu */

	a = (double **) malloc (m * sizeof (double *)); /* m files */

	if (a == NULL) {
		printf ("No hi ha prou memoria\n");
		exit (1);
	}

	for (i = 0; i < m; i++) {
		a[i] = (double *) malloc (n * sizeof (double)); /* n columnes */
		if (a[i] == NULL) {
			printf ("No hi ha prou memoria\n");
			exit (2);
		}
	}

	b = (double **) malloc (n * sizeof (double));

    if (b == NULL) {
        printf ("No hi ha prou memoria\n");
		exit (1);
	}

	for (i = 0; i < n; i++) {
		b[i] = (double *) malloc (m * sizeof (double));
		if (b[i] == NULL) {
			printf ("No hi ha prou memoria\n");
			exit (2);
		}
	}

	u = (double *) malloc (m * sizeof (double));
	v = (double *) malloc (n * sizeof (double));
    y = (double *) malloc (m * sizeof (double));

	if (u == NULL || v == NULL || y == NULL ) {
		printf ("No hi ha prou memoria\n");
		exit (3);
	}

	/* Valors de la matriu A */
	for (i = 0; i < m; i++) {
		for (j = 0; j < n; j++) {
			fscanf (entrada, "%le", &a[i][j]);
		}
	}

	/* Valors de la matriu B */
    for (i = 0; i < n; i++) {
        for (j = 0; j < m; j++) {
            fscanf (entrada, "%le", &b[i][j]);
        }
    }

	/* Valors dels elements del vector */
	for (i = 0; i < m; i++)
        fscanf (entrada, "%le", &u[i]);

    prodMatVec(b, u, v, n, m);
    prodMatVec(a, v, y, m, n);

	fclose(entrada);

	printf ("El producte de la matriu A =\n");
	for (i = 0; i < m; i++) {
		for (j = 0; j < n; j++) {
			printf (" %16.7e", a[i][j]);
		}
		printf ("\n");
	}

	printf("per la matriu B = \n");
	for (i = 0; i < n; i++) {
        for (j = 0; j < m; j++) {
            printf(" %16.7e", b[i][j]);
        }
        printf("\n");
    }

	printf (" pel vector u = \n");

	for (i = 0; i < m; i++)
		printf (" %16.7e\n", u[i]);

    printf (" ens dona v = \n");

    for (i = 0; i < m; i++)
		printf (" %16.7e\n", y[i]);

    printf (" El mòdul del vector u és = \n");

    for (i = 0; i < m; i++) {
        mod_u += pow(u[i], 2);
    }

    printf(" %16.7e", sqrt(mod_u));

    printf("\n");

    printf (" El mòdul del vector y és u = \n");

    for (i = 0; i < m; i++) {
        mod_y += pow(y[i], 2);
    }

    printf(" %16.7e", sqrt(mod_y));

    printf("\n");

    quocient = mod_y / mod_u;

    temp = mod_u * quocient;


    if(quocient == temp){
        printf("y és múltiple de x");
    } else{
        printf("y NO és múltiple de x");
    }

    printf("\n");

    for (i = 0; i < m; i++)
		free (a[i]);

    for(i= 0; i < n; i++)
        free (b[i]);

    free (a);
	free (u);
	free (v);
    free (y);
	return 0;
}
