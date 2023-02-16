## PROBLEMA 1 ##
# Feu N = 1000 simulacions de n = 20 valors d'una varibale aleatòria X amb llei N(m,1), amb m = 3. Amb cadascuna de les simulacions calculeu un interval de confiança del 90% per a la mitjana de X. Calculeu la proporció dels N intervals obtinguts que contenen el valor m.

# Repetiu amb diferents valors de n (com més gran és n, més estret és l'interval) i amb diferents valors de N (com més gran és N, més s'acosta la proporció al seu valor teòric 0.90) (N ~ (mu, sigma))
N <- 1000
n <- 20
m <- 3

# Organitzem la llista de 20000 (1000 * 20) nombres aleatoris en 1000 (simulacions) files i 20 (valors de la variable aleatòria) columnes, de forma que obtenim una matriu on cada fila és una mostra de mida 20
X <- rnorm(N*n, 3, 1)
dim(X) <- c(N, n)

# Calculem el vector M de les 1000 mitjanes empíriques i, a partir d'ell, els vectors A i B que contenen les vorees inferior i superor, respectivament, de l'interval de confiança per a cadascuna de les N = 1000 mostres
M <- apply(X, 1, mean)
d <- qnorm(0.95)*1/sqrt(n)
A <- M-d
B <- M+d

# Verifiquem, per a cada interval, si el valor teòric m = 3 hi pertany i comptem quantes vegades passa aquest esdevenimeent
u <- (A<m) & (m<B)
sum(u)


## PROBLEMA 2 ##
# Es fan 5 determinacions de la quantitat d'argent d'un mineral i s'obté: (5.2, 4.8, 5.3, 5.7 i 5.0)mg d'argent.
# Determineu l'interval de confiança amb coeficient de confiança 0.95 per la mitjana suposant variància desconeguda. Suposeu normalitat.
# Coeficient de confiança -> 0.95
# n -> 5
# Donat el nivell de confiança, calculem a, per a Tn un t-Student de paràmetre n (mida de la mostra)
# Distribució t(n-1)
x <- c(5.2, 4.8, 5.3, 5.7, 5.0)
a <- qt(0.975, 4)
d <- qt(0.975, 4)*sd(x)/sqrt(4) # En teoria la variància és desconeguda
mitjana_x <- mean(x)
A <- mitjana_x - d
B <- mitjana_x + d

# També es pot fer el càlcul directament amb la següent comanda
t.test(x, conf.level=0.95)$conf.int # Per defecte conf.level = 0.95


## PROBLEMA 3 ##
# Després d'un tractament contra l'obesitat, els pesos en Kg de vuit dones eren: 58,50,60,65,64,62,56,57
# Si suposem normalitat, calculeu un interval de confiança amb coeficient de confiança 0.95 per la mitjana teòrica si la variància és desconeguda. Què passa si el calculeu amb un coeficient de confiança del 0.9?
x <- c(58,50,60,65,64,62,56,57)
t.test(x)$conf.int
t.test(x, conf.level = 0.9)$conf.int # S'acota més l'interval

### PROBLEMES 4 - 8 amb són dades aparellades o dues mostres independents?? PREGUNTAR GANGO --> SOLO LAS QUE TIENEN RELACIÓN ###
## PROBLEMA 4 ##
# S'ha mesurat el pH del cordó umbilical de 22 nadons de dones no fumadores i de dones fumadores, obtenint:
# NO-fumadores: 7.28, 7.31, 7.34, 7.34, 7.32, 7.23, 7.31, 7.32, 7.29, 7.35, 7.32, 7.34, 7.35, 7.26, 7.18, 7.34, 7.27, 7.34, 7.32, 7.29, 7.26, 7.26
# Fumadores: 7.26, 7.27, 7.27, 7.35, 7.29, 7.28, 7.31, 7.34, 7.29, 7.39, 7.21, 7.28, 7.30, 7.24, 7.20, 7.28, 7.30, 7.35, 7.32, 7.31, 7.37, 7.26

# (a) Calculeu un interval de confiança del 90% per la mitjana de cada una de les mostres.
# NO-fumadores:
no_fumadores <- c(7.28, 7.31, 7.34, 7.34, 7.32, 7.23, 7.31, 7.32, 7.29, 7.35, 7.32, 7.34, 7.35, 7.26, 7.18, 7.34, 7.27, 7.34, 7.32, 7.29, 7.26, 7.26)
t.test(no_fumadores, conf.level=0.9)$conf.int
fumadores <- c(7.26, 7.27, 7.27, 7.35, 7.29, 7.28, 7.31, 7.34, 7.29, 7.39, 7.21, 7.28, 7.30, 7.24, 7.20, 7.28, 7.30, 7.35, 7.32, 7.31, 7.37, 7.26)
t.test(fumadores, conf.level=0.9)$conf.int

# (b) Calculeu l'interval de confiança del 95% per a la diferència de les mitjanes del pH de les dones fumadores i de les no fumadores.
mitjana_no_fumadores <- mean(no_fumadores)
mitjana_fumadores <- mean(fumadores)
var_no_fumadores <- var(no_fumadores)
var_fumadores <- var(fumadores)

a <- qnorm(0.95)
d <- a*sqrt((var_no_fumadores/length(no_fumadores)) + (var_fumadores/length(fumadores)))
d1 <- mitjana_no_fumadores - mitjana_fumadores - d
d2 <- mitjana_no_fumadores - mitjana_fumadores + d

## PROBLEMA 5 ##
# Les notes d'11 alumnes d'una classe en dos exàmens consecutius van ser:
# Examen1: 7.9, 8.3, 6.2, 8.2, 8, 7.8, 4.9, 6.2, 8.9, 7.8, 9.4
# Examen2: 8.2, 7.1, 4.8, 8.4, 7.9, 7.4, 5.2, 5.6, 9.2, 6.5, 8.5

# (a) Calculeu l'interval de confiança del 95% per a la diferència de mitjanes de les notes del primer i del segon examen
examen_1 <- c(7.9, 8.3, 6.2, 8.2, 8, 7.8, 4.9, 6.2, 8.9, 7.8, 9.4)
examen_2 <- c(8.2, 7.1, 4.8, 8.4, 7.9, 7.4, 5.2, 5.6, 9.2, 6.5, 8.5)
t.test(examen_1, examen_2, paired=TRUE)$conf.int

# (b) Calculeu l'interval de confiança del 80% per a la diferència de mitjanes de les notes del primer i del segon examen. Compara els resultats amb l'apartat anterior.

t.test(examen_1, examen_2, conf.level=0.8, paired=TRUE)$conf.int # S'acota l'interval de confiança


## PROBLEMA 6 ##
# S'ha dut a terme un estudi per veure l'efecte de l'exercici físic sobre el nivell de colesterol en sang. Es va analitzar la sang de 11 individus abans i després de fer exercici obtenint els següents resultats:
# Abans: 182, 232, 191, 200, 148, 249, 276, 213, 241, 480, 262
# Després: 198, 210, 194, 220, 138, 220, 219, 161, 210, 313, 226

# (a) Quin és el nivell mig de colesterol en sang abans i després de la prova? Construir un interval de confiança al 95% per cada un d'ells
abans <- c(182, 232, 191, 200, 148, 249, 276, 213, 241, 480, 262)
despres <- c(198, 210, 194, 220, 138, 220, 219, 161, 210, 313, 226)
nivell_abans <- mean(abans)
nivell_despres <- mean(despres)

t.test(abans)$conf.int
t.test(despres)$conf.int

# (b) Construir un interval de confiança de confiança al 95% per a la diferència mitjana entre abans. després del tractament
t.test(abans, despres, paired=TRUE)$conf.int


## PROBLEMA 7 ##
# En l'estud d'un tipus d'insectes s'han mesurat les longituds (en mm) de les ales de 15 individus nascuts en el laboratori (L) i 15 individus nascuts salvatges (S). Els resultats són els següents:
# L: 6.7, 1.9, 6.4, 4.8, 2.6, 4.9, 6.7, 3.6, 1.5, 1.2, 2.4, 2.4, 4.6, 4.9, 4.8
# S: 6.2, 3.7, 4.5, 6.2, 6.0, 5.3, 3.5, 3.6, 3.1, 0.3, 5.3, 4.5, 4.5, 3.6, 4.5

# Calculeu un interval de confiança del 95% per a la diferència de les mitjanes de les dues poblacions:
L <- c(6.7, 1.9, 6.4, 4.8, 2.6, 4.9, 6.7, 3.6, 1.5, 1.2, 2.4, 2.4, 4.6, 4.9, 4.8)
S <- c(6.2, 3.7, 4.5, 6.2, 6.0, 5.3, 3.5, 3.6, 3.1, 0.3, 5.3, 4.5, 4.5, 3.6, 4.5)

t.test(L, S, paired=TRUE)$conf.int


## PROBLEMA 8 ##
# Les dades següents es varen obtenir d'un experiment dissenyat per estimar la reducció en la pressió arterial després de seguir una dieta sense sal durant dues setmanes
# Abans: 93, 106, 87, 92, 102, 95, 88, 110
# Després: 92, 102, 89, 92, 101, 96, 88, 105

# Calculeu un interval de confiança del 97% per la reducció mitjana:
abans <- c(93, 106, 87, 92, 102, 95, 88, 110)
despres <- c(92, 102, 89, 92, 101, 96, 88, 105)

t.test(abans, despres, conf.level=0.97, paired=TRUE)$conf.int