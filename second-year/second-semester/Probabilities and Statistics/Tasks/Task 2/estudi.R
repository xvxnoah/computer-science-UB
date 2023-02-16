# Apartat a)
# Creació dels vectors de valors xi
x <- c(-5:5)
prob <- c(1/36, 2/36, 3/36, 4/36, 5/36, 6/46, 5/36, 4/36, 3/36, 2/36, 1/36)

# Representació de la funció de massa de probabilitat
plot(x,prob,type="h", xlim=c(-5,5), ylim=c(0,1), xlab="Xi", ylab="probabilitat")

# Representació de la funció de distribució de probabilitat
acum <- cumsum(prob)
s <- stepfun(x, c(0,acum))
plot(s,verticals=FALSE, xlab="Xi", ylab="probabilitat")

# Càlcul esperança
esp <- sum(x*prob)

# Apartat b)
# Simulem les mostres per n = 50, n = 100 i n = 1000
n = 50
n = 100
n = 1000

x <- c(-5:5)
probs <- c(1/36, 2/36, 3/36, 4/36, 5/36, 6/46, 5/36, 4/36, 3/36, 2/36, 1/36)

Y <- sample(x,n,prob = probs, replace=TRUE)
mean(Y)
var(Y)

# Apartat c)
# Taula de freqüències relatives (32 casos possibles)
x <- c(1:6)
probs = c(1/6, 1/6, 1/6, 1/6, 1/6, 1/6)

t <- sample(x, n, prob=probs, replace=TRUE)
v <- sample(x, n, prob=probs, replace=TRUE)

z <- t - v
table(z)/n