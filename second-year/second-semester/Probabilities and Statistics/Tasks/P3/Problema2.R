# Dibuix de la funció de massa de probabilitat d'una llei B(p)
N <- 10
x <- rgeom(N, 0.5) # p = 0.5
probx <- dgeom(x, 0.4)

y <- rgeom(N, 0.001) # p = 0.005
proby <- dgeom(y, 0.005)

z <- rgeom(N, 0.8) # p = 0.90
probz <- dgeom(z, 0.90)

plot(x,probx,type="h", ylim=c(0,1))

plot(y,proby,type="h", ylim=c(0,0.005))

plot(z,probz,type="h", ylim=c(0,1))

# Dibuix de la funció de distribució de probabilitat de la mateixa llei B(p)
acum <- cumsum(probx)
s <- stepfun(x, c(0,acum))
plot(s,verticals=FALSE)

acum <- cumsum(proby)
s <- stepfun(x, c(0,acum))
plot(s,verticals=FALSE)

acum <- cumsum(probz)
s <- stepfun(x, c(0,acum))
plot(s,verticals=FALSE)