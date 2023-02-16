# Dibuix de la funció de massa de probabilitat d'una llei binomial Bn(n,p) en els casos següents:
N <- 100
x <- rbinom(N, 3, 0.4) # n = 3, p = 0.4
probx <- dbinom(x, 3, 0.4)

y <- rbinom(N, 10, 0.001) # n = 10, p = 0.001
proby <- dbinom(y, 10, 0.001)

z <- rbinom(N, 20, 0.8) # n = 20, p = 0.8
probz <- dbinom(z, 20, 0.8)

plot(x,probx,type="h", xlim=c(0,3), ylim=c(0,1))

plot(y,proby,type="h", xlim=c(0,10), ylim=c(0,1))

plot(z,probz,type="h", xlim=c(0,20), ylim=c(0,1))

# Dibuix de la funció de distribució de probabilitat de la mateixa llei binomial
acum <- cumsum(probx)
s <- stepfun(x, c(0,acum))
plot(s,verticals=FALSE)

acum <- cumsum(proby)
s <- stepfun(x, c(0,acum))
plot(s,verticals=FALSE)

acum <- cumsum(probz)
s <- stepfun(x, c(0,acum))
plot(s,verticals=FALSE)