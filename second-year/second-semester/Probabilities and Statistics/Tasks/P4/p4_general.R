### Simulacions de variables aleatòries absolutament contínues conegudes ###
## Simular una mostra de mida 1000 d'una Normal de mitjana 40 i desviació típica 3 ##
x <- rnorm(1000,40,3)
x
median(x)
sd(x)

### Distribucions de probabilitat ###
## Com dibuixem una densitat? ##
# Si la distribució és coneguda només cal utilitzar el predix d. Suposem per exemple que volem dibuixar la densitat d'una Normal de mitjana 40 i desviació típica 3 #
x <- seq(20,60,by=0.05)
y <- dnorm(x,40,3)
plot(x,y,type='l')

# Si no és una llei coneguda hem de conèxier la seva densitat. Recordeu que la densitat és la
# derivada de la funció de distribució #
x <- seq(20,60,by=0.005)
y <- (3/7)*(x+1)^2
plot(x,y,type="l")

## Com dibuixem una Funció de distribució? ##
# Si la distribució és coneguda només cal utilitzar el prefix p. Per exemple, si volem dibuixar
# la distribució d'una Normal de mitjana 40 i desviació típica 3, les instruccions que hem de seguir
# són: # (4.1)
x <- seq(20,60,by=0.05)
y <- pnorm(x,40,3)
plot(x,y,type="l")

# Si no és una llei coneguda hem de conèixer la seva funció de distribució. Recordeu que una funció de
# distribució és la integral de la funció de densitat. # Suposem que volem dbuixar la funció de distribució 
# de la llei que té per densitat (4.1) # (4.2)
x <- seq(0,1,by=0.05)
y <- (1/7)*(x+1)^3-1/7
plot(x,y,type="l")

## Com calculem probabilitats? ##
# Si la distribució és coneguda només cal utilitzar el prefix p. Si X és una Normal de mitjana 40 i desviació
# típica 3: #
# P(X<= 45) es calcula mitjançant
pnorm(45,40,4)

# P(X=40), aquesta probabiliitat sempre és zero ja que X és contínua

# P(X>=35) = 1 - P(X<35) es calcula mitjançant
1-pnorm(35,40,3)

# Si volem trobar y tal que P(X<=y) = 0.8, fem:
qnorm(0.8,40,3)

pnorm(42.52486,40,3) # Comprovació

# Si la distribució no és coneguda, utilitzem la funció de distribució: F(x) = P(X<=x). Per exemple, si la
# funció de distribució és (4.2) #
# P(X<=0.3) es calcula mitjançant
(1/7)*(0.3+1)^3-1/7

# P(X=0.5), aquesta probabilitat és zero

# P(X>=0.8) = 1 - P(X<0.8) es calcula mitjançant
1-(1/7)*(0.8+1)^3-1/7


### PROBLEMES ###
## Exercici 1: ##
# Amb a = 0 i b = 1
# Densitat:
a <- 0
b <- 1
x <- seq(-2,2,by=0.05) # -2 & 2 to see beter the effect
y <- dunif(x,min=a,max=b)
plot(x,y,type='l')

# Distribució:
x <- seq(-2,2,by=0.05)
y <- punif(x,min=a,max=b)
plot(x,y,type='l')

# Amb a = -2 i b = 2
# Densitat:
a <- -2
b <- 2
x <- seq(-4,4,by=0.005)
y <- dunif(x,min=a,max=b)
plot(x,y,type="l")

# Distribució:
x <- seq(-4,4,by=0.05)
y <- punif(x,min=a,max=b)
plot(x,y,type='l')

# Per una variable aleatòria X ~ U(0,1) calcular les següents probabilitats:
# P(X=0.5) -> 0 (contínua)

# P(X<=0.7)
punif(0.7,0,1)

# P(X<0.7)
punif(0.7,0,1)

# P(X>=0.2) = 1 - P(X<0.2)
1 - punif(0.2,0,1)

# P(X<=0)
punif(0,0,1)

# P(X<=1)
punif(1,0,1)

## Exercici 2: ##
# Dibuixeu aquesta funció, per alpha=0.5 i alpha=1.5
# Per obtenir la funció de densitat, derivem la funció de distribució
alpha <- 0.5
x <- seq(0,1,by=0.005)
y <- alpha*x^(alpha-1)
plot(x,y,type="l")

alpha <- 1.5
x <- seq(0,1,by=0.005)
y <- alpha*x^(alpha-1)
plot(x,y,type="l")

# Per dibuixar la funció de distribució
alpha <- 0.5
x <- seq(0,1,by=0.05)
y <- x^alpha
plot(x,y,type="l")

alpha <- 1.5
x <- seq(0,1,by=0.05)
y <- x^alpha
plot(x,y,type="l")

# Cálcul de les probabilitats: Si la distribució no és coneguda, utilitzem la funció de distribució: F(x) = P(X<=x).
alpha <- 0.5
alpha <- 1.5
# P(X=0.5) -> 0 (contínua)

# P(X<=0.7)
0.7^alpha

# P(X<0.7)
0.7^alpha

# P(X>=0.2) = 1 - P(X<0.2)
1 - 0.2^alpha

# P(X<=0)
0^alpha

# P(X<=1)
1^alpha

## Exercici 3: ##
# Dibuixeu la funció de densitat de probabilitat i la funció de distribució de probabilitat d'una llei
# exp(lambda) amb diferents valors del paràmetre, per exemple: 1, 4, 6, 10, 20
# Densitat
lambda <- 1
lambda <- 4
lambda <- 6
lambda <- 10
lambda <- 20

curve(dexp(x,lambda), from=0, to=10, col='blue')

# Distribució
curve(pexp(x,lambda), from=0, to=10, col='blue')

# Cálcul de les probabilitats:
# P(X=5) -> 0 (contínua)

# P(X≤3)
pexp(3,lambda)

# P(x<3)
pexp(3,lambda)

# P(X≥6) = 1 - P(X<6)
1 - pexp(6,lambda)

## Exercici 4: ##
# Variable aleatòria amb llei N(mu, sigma^2) on mu=3, sigma^2=1.5
# Cálcul de les probabilitats:
# P(X=5) -> 0 (contínua)

# P(X≤3)
pnorm(3,3,sqrt(1.5))

# P(X≤2)
pnorm(2,3,sqrt(1.5))

# P(X≥4) = 1 - P(X<4)
1-pnorm(4,3,sqrt(1.5))

# P(2.5<X<3.5)


# P(X≥6) = 1 - P(X<6)
1-pnorm(6,3,sqrt(1.5))

## Exercici 5: ##
# Distribució aproximadament normal de mitjana 110 i desviació típica 25
# a) Percentatge de persones entre 20 i 34 anys té coeficient més gran que 100?
# P(X≥100) = 1 - P(X<100)
100*(1-pnorm(100,110,25))

# b) Percentatge de persones entre 20 i 34 anys té coeficient més petit que 150?
# P(X<150)
100*(pnorm(150,110,25))

# c) Coeficient mínim del adults entre 20 i 34 anys situats en el 25% que han obtingut millors resultats?
qnorm(0.25,110,25)

## Exercici 6: ##
# Distribució exponencial de mitjana 2000 hores -> lambda = 1/2000.
# Probabilitat de que després de 3000 hores segueixi funcionant?
# P(X≥3000) = 1 - P(X<3000)
1-pexp(3000,1/2000)

# Probabilitat de que s'espatlli abans de 2000 hores?
# P (X<2000)
pexp(2000,1/2000)

## Exercici 7: ##
# Mitjana 10 anys, desviació típica 2 anys; Temps de vida del motor es distribueix segons una llei normal
# Només pensa canviar el 3% dels motors que fallin. Quin tipus de garantia haurà d'estipular?
pnorm(6.24,10,2)*100 # 6.24 anys

## Exercici 8: ##
# Lliurar el paquet a les 10am; temps a recòrrer el trajecte [35,45] minuts; temps del recorregut segueix
# una llei uniforme.
# A quina hora ha d'iniciar el recorregut al matí per a que arribi puntual (a les 10h o abans) amb probabilitat
# 0.8
qunif(0.8,35,45) # 43 minuts abans ha de sortir

## Exercici 9: ##
# Temps de reparació d'una màquina segueix una distribució gamma(5,2); cost de la reparació 500€ l'hora + el
# desplaçament 300€.
# Probabilitat de que el cost de la reparació no superi els 2000 euros?
# P(X≤2000) 
pgamma(2000,5,2)

## Exercici 9: ##
# Distribució normal de mitjana 298 i desviació típica 3
# Probabilitat que una ampolla contigui menys de 295ml?
# P(X<295) = P(X<=294)?¿
pnorm(295,298,3) # 15,9%

# Probabilitat que la mitjana dels continguts d'un paquet de 6 ampolles sigui menor que 295?
x <- rnorm(6,298,3)
mitjana <- mean(x)
pnorm(295,mitjana,3)*100 # 7.7%
