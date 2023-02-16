# Creació dels vectors de valors xi
x <- c(2,3,6,7,8,10)
prob <- c(0.2,0.1,0.2,0.1,0.2,0.2)

# Representació de la funció de massa de probabilitat
plot(x,prob,type="h", xlim=c(2,10), ylim=c(0,1), xlab="Xi", ylab="probabilitat")

# Representació de la funció de distribució de probabilitat
acum <- cumsum(prob)
s <- stepfun(x, c(0,acum))
plot(s,verticals=FALSE, xlab="Xi", ylab="probabilitat")

# Esperança
esp <- sum(x*prob)
esp

# Variància
var <- 1/6 * sum((x-mean(x))**2)
var

# Desviació típica de X
sd <- sqrt(var)
sd