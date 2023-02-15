/*  Calcul del producte d'una matriu per un vector usant memoria dinamica */
#include <stdio.h>
#include <stdlib.h>
int main (void)
{
	int n, m, i, j;
	double **a, *u, *v;
	printf (" Doneu les dimensions de la matriu, (n,m) =\n");
	scanf ("%d %d", &n, &m);
	a = (double **) malloc (n * sizeof (double *));
	if (a == NULL) {
		printf ("No hi ha prou memoria\n");
		exit (1);
	}
	for (i = 0; i < n; i++) {
		a[i] = (double *) malloc (m * sizeof (double));
		if (a[i] == NULL) {
			printf ("No hi ha prou memoria\n");
			exit (2);
		}
	}
	u = (double *) malloc (m * sizeof (double));
	v = (double *) malloc (n * sizeof (double));
	if (u == NULL || v == NULL) {
		printf ("No hi ha prou memoria\n");
		exit (3);
	}
	printf (" Doneu els (%d x %d) elements de la matriu A\n", n, m);
	for (i = 0; i < n; i++) {
		for (j = 0; j < m; j++) {
			scanf ("%le", &a[i][j]);
		}
	}
	printf (" Doneu els %d elements del vector u\n", m);
	for (i = 0; i < m; i++)
		scanf ("%le", &u[i]);
	for (i = 0; i < n; i++) {
		v[i] = 0.f;
		for (j = 0; j < m; j++) {
			v[i] += a[i][j] * u[j];
		}
	}
	printf ("El producte de la matriu A =\n");
	for (i = 0; i < n; i++) {
		for (j = 0; j < m; j++) {
			printf (" %16.7e", a[i][j]);
		}
		printf ("\n");
	}
	printf (" pel vector u = \n");
	for (i = 0; i < m; i++)
		printf (" %16.7e\n", u[i]);
	printf (" ens dona v = \n");
	for (i = 0; i < n; i++)
		printf (" %16.7e\n", v[i]);
	for (i = 0; i < n; i++)
		free (a[i]);
	free (a);
	free (u);
	free (v);
	return 0;
}
