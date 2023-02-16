# Prenem com exemple la distribució Binomial Bn(8,0.4) i el llançament d'un dau perfecte per veure
# com es fan els dibuixos de la funció de massa de probabilitat, de la funció de distribució i com
# es calculen diferents probabilitats

# Dibuix de la funció de massa de probabilitat
# Hem de tenir un vector amb els valors de la variable i un vector amb les probabilitats. En el cas
# de Bn(8,0.4)
x <- c(0:8)
prob <- dbinom(x,8,0.4)

# Pel llançament d'un dau
x <- c(1:6)
prob <- c(rep(1/6, 6))

# Per fer el dibuix de la massa de probabilitat d'una distribució discreta s'utilitza la següent
# instrucció:
plot(x,prob,type="h", xlim=c(0,8), ylim=c(0,1))

# Pel llançament d'un dau
plot(x,prob,type="h", xlim=c(0,6), ylim=c(0,1))

# Els límits de xlim cal ajustar-los als valors de la variable


# Per fer el dibuix de la funció de la distribució hem de seguir les instruccions següents
acum <- cumsum(prob)
s <- stepfun(x, c(0,acum))
plot(s,verticals=FALSE)

# Càlcul de probabilitats
# Si volem calcular probabilitats concretes, en el cas de la nostra variable X és una Bn(8,0.4):
pbinom(3,8,0.4) # P(X <= 3)
dbinom(3,8,0.4) # P(X = 3)
1-pbinom(2,8,0.4) # P(X >= 3) = 1 - P(X < 3) = 1 - P(X <= 2)

# P(X <= 3) també es pot calcular fent:
dbinom(0,8,0.4) + dbinom(1,8,0.4) + dbinom(2,8,0.4) + dbinom(3,8,0.4)

# Pre trobar el valor de la variable en que la funció de distribució assoleix una probabilitat concreta, per exemple, si volem saber el valor k en que P(X <= k) = 0.5940864, fem:
k <- qbinom(0.5940864,8,0.4)
k

# Com no totes les probabilitats p entre (0,1) s'assoleixen, el que fa R amb aquesta funció és calcular k tal que P(X <= K) >= p i P(X <= k-1) < p.

# Provarem dos valors per veure que son diferents
k <- qbinom(0.59,8,0.4)
k

k <- qbinom(0.595,8,0.4)
k

# En el cas que la nostra variable X és el resultat del llançament d'un dau no perfecte, i suposant
# que en prob tenim el vector de probabilitats:
k <- prob[1] + prob[2] + prob[3] # P(X <= 3)
k

k <- prob[3] # P(X = 3)
k

k <- 1 - prob[1] # (P >= 2) = 1 - P(X = 1)
k

# Esperança
esp <- sum(x*prob)
esp

# Forma per calcular variància i desviació típica (no corregides)
var <- 1/6 * sum((x-mean(x))**2)
var

sd <- sqrt(var)
sd