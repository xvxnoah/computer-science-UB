## PROBLEMA 1 ##
# Fixem un N, per exemple N = 200 i un B, per exemple B = 400. Realitzeu les següents operacions:
# (a) Genereu N mostres de mida B, d'una distribució de Bernoulli amb paràmetre p = 0.5, en forma d'una matriu A, de dimensió N x B.
# Calculeu la llista a de les N sumes de les N files de A, tal i com es va explicar al guió de la Pràctica 3
p <- 0.5
N <- 200
B <- 400
A <- matrix(rbinom(N*B, 1, p), N)
a <- apply(A, 1, sum)

# (b) Calculeu l'esperança teòrica mu i la variància sigma^2 (en aquest cas de la llei Bernoulli(p))
E <- p
Var <- p*(1-p)

# (c) De cada fila de la matriu calculeu la mitjana, obtenin així un vector de mitjanes
M <- apply(A, 1, mean)

# (d) Centreu i normalizeu el vector de mitjanes (recordeu que cal restar la mitjana teòrica mu i dividir per la desviació teòrica sigma/sqrt(n))
centered_normalized <- (M - E)/sqrt(N)

# (e) Dibuixeu l'histograma del vector de mitjanes normalitzat amb la corba de la densitat de la normal, què observem? Cal augmentar el valor de N per obtenir una aproximació millor? Sembla que si.
hist(centered_normalized)


## PROBLEMA 2 ##
# Genereu una matriu N x B corresponent a N mostres de mida B d'una variable aleatòria amb funció de massa de probabilitat:
# P(X = -2) = 1/8, P(X = -1) = 1/8, P(X = 0) = 1/2, P(X = 1) = 1/8, P(X = 2) = 1/8
# Podeu prendre N = 100 i B = 100. Calculeu i responeu els mateixos apartats que en l'exercici 1 per aquesta variable aleatòria i per aquests valors de N i B.

# Calculeu la llista a de les N sumes de les N files de A, tal i com es va explicar al guió de la Pràctica 3
N <- 100
B <- 100
y <- sample(c(-2,-1,0,1,2), N*B, prob=c(1/8,1/8,1/2,1/8,1/8), replace=TRUE)
A <- matrix(y, N)
a <- apply(A, 1, sum)

# (b) Calculeu l'esperança teòrica mu i la variància sigma^2 (en aquest cas de la llei uniforme continua)
E <- (-2+2)/2
Var <- (-2-2)^2/12

# (c) De cada fila de la matriu calculeu la mitjana, obtenin així un vector de mitjanes
M <- apply(A, 1, mean)

# (d) Centreu i normalizeu el vector de mitjanes (recordeu que cal restar la mitjana teòrica mu i dividir per la desviació teòrica sigma/sqrt(n))
centered_normalized <- (M - E)/sqrt(N)

# (e) Dibuixeu l'histograma del vector de mitjanes normalitzat amb la corba de la densitat de la normal, què observem? Cal augmentar el valor de N per obtenir una aproximació millor? Sembla que si.
hist(centered_normalized)

## PROBLEMA 3 ##
# Genereu una matriu N x B corresponent a N mostres de mida B d'una variable aleatòria amb funció de massa de probabilitat.
# P(X = 5) = 1/3, P(X = 7) = 1/2, P(X = 9) = 1/6
# Podeu prendre N = 200 i B = 400. Calculeu i responeu els mateixos apartats que l'exercici 1 per aquesta variable aleatòria.
N <- 200
B <- 400
y <- sample(c(5,7,9), N*B, prob=c(1/3,1/2,1/6), replace=TRUE)
A <- matrix(y, N)
a <- apply(A, 1, sum)

# (b) Calculeu l'esperança teòrica mu i la variància sigma^2 (en aquest cas de la llei uniforme continua)
E <- (5+7)/2
Var <- (7-5)^2/12

# (c) De cada fila de la matriu calculeu la mitjana, obtenin així un vector de mitjanes
M <- apply(A, 1, mean)

# (d) Centreu i normalizeu el vector de mitjanes (recordeu que cal restar la mitjana teòrica mu i dividir per la desviació teòrica sigma/sqrt(n))
centered_normalized <- (M - E)/sqrt(N)

# (e) Dibuixeu l'histograma del vector de mitjanes normalitzat amb la corba de la densitat de la normal, què observem? Cal augmentar el valor de N per obtenir una aproximació millor? Sembla que si.
hist(centered_normalized)


## PROBLEMA 4 ##
# Genereu una matru N x B corresponent a N mostres de mida B d'una variable aleatòria contínua amb funció de densitat: f(x) = 3x^2 1(0,1) (x).
# Podeu prendre N = 200 i B = 400. Calculeu i responeu els mateixos apartats que l'exercici 1 per aquesta variable aleatòria.
# Funció de distribució: x^3 si 0 ≤ x < 1

N <- 200
B <- 400

# Obtenim els nombres
u <- runif(B*N)

# Apliquem la inversa
y <- (u)^{1/3}

# Generem la matriu
dim(y) <- c(N, B)

a <- apply(y, 1, sum)

# (b) Calculeu l'esperança teòrica mu i la variància sigma^2 (en aquest cas de la llei uniforme continua)
E <- (0+1)/2
Var <- (1-0)^2/12

# (c) De cada fila de la matriu calculeu la mitjana, obtenin així un vector de mitjanes
M <- apply(y, 1, mean)

# (d) Centreu i normalizeu el vector de mitjanes (recordeu que cal restar la mitjana teòrica mu i dividir per la desviació teòrica sigma/sqrt(n))
centered_normalized <- (M - E)/sqrt(N)

# (e) Dibuixeu l'histograma del vector de mitjanes normalitzat amb la corba de la densitat de la normal, què observem? Cal augmentar el valor de N per obtenir una aproximació millor? Sembla que si.
hist(centered_normalized)


## PROBLEMA 5 ##
# Fixem un N, per exemple N = 200 i un B, per exemple B = 400, i un t una mica més petit que N, per exemple t = 186.
# Realitxeu les següents operacions:
# (a) Genereu N mostres de mida B, d'una distribució de Bernoulli amb paràmetre p = 0.5, en forma d'una matriu A, de dimensió N x B. Calculeu la llista a de les N sumes de les N files de A.
p <- 0.5
N <- 200
B <- 400
t <- 186
A <- matrix(rbinom(N*B, 1, p), N)
a <- apply(A, 1, sum)

# (b) Quins són els paràmetres mu i sigma de la llei normal que aproxima bé la distribució de a?
# mu és l'esperança i la variància és sigma^2
mu <- p # esperança
sigma <- sqrt(p*(1-p)) # variància

# (c) Calculeu utilitzant l'aproximació de la Normal de l'apartat anterior el nombre d'elements de la llista a que haurien de ser menors que t. Comproveu que heu obtingut una bona aproximació.
M <- apply(A, 1, mean)
result <- (M - mu)/(sigma/sqrt(N))
pnorm(t, mu, sigma)