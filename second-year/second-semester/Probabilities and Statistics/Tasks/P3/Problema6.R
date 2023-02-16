# Dibuix de les funcions de massa de probabilitat i les funcions de distribució de probabilitat
# de les lleis Pois(λ) amb λ = 1 i λ = 20
N <- 100
x <- rpois(N, 1)
probx <- dpois(x,1)
plot(x,probx,type="h")

acum <- cumsum(probx)
s <- stepfun(x, c(0,acum))
plot(s,verticals=FALSE)


y <- rpois(N, 20)
proby <- dpois(y, 1)
plot(y,proby,type="h")

acum <- cumsum(proby)
s <- stepfun(y, c(0,acum))
plot(s,verticals=FALSE)