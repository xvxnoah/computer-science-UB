# Problema 2.1
# Volem generar una mostra de mida 50 d'una variable aleatòria X tal que:
# P(X = 3) = 0.1 , P(X = 5) = 0.3 , P(X = 7) = 0.2 , P(X = 9) = 0.4

# Obtenim els nombres aleatoris:
u <- runif(50)

# Fer la transformació per a les probabilitats
y <- sample(c(3,5,7,9), 50, prob=c(0.1, 0.3, 0.2, 0.4), replace=TRUE)

# Càlcul freqüències relatives
table(y)/length(y)

# Càlcul esperança
valors <- c(3,5,7,9)
probs <- c(0.1, 0.3, 0.2, 0.4)
esp_teorica <- sum(valors * probs)

# Càlcul variància
var_teorica <- sum((valors - esp_teorica)^2 * probs)

# Mitjana i variància (empíriques)
mean(y)

var(y)

# El mateix per B = 10000

# Obtenim els nombres aleatoris:
t <- runif(10000)

# Fer la transformació per a les probabilitats
x <- sample(c(3,5,7,9), 10000, prob=c(0.1, 0.3, 0.2, 0.4), replace=TRUE)

# Càlcul freqüències relatives
table(x)/length(x)

# Mitjana i variància (empíriques)
mean(x)

var(x)

# Problema 2.2

# Obtenim els nombres
u <- runif(50, min=0, max=2)

# Apliquem la inversa
y <- 2 * (u^{1/5})

# Dibuixem l'histograma amb el dibuix de la funció de densitat
hist(y, freq=FALSE, main="", ylab="Densitat", xlim=range(c(0.5:3)))
z <- seq(0,2,by=0.05)
t <- 5/32 * z^4
lines(z,t, col = "red")

# Càlcul mitjana
mean(u)

# Càlcul variància
var(u)

# El mateix per B = 1000
u <- runif(1000, min=0, max=2)

# Apliquem la inversa
y <- 2 * (u^{1/5})

# Dibuixem l'histograma amb el dibuix de la funció de densitat
hist(y, freq=FALSE, main="", ylab="Densitat",xlim=range(c(0.5:2.5)))
z <- seq(0,2,by=0.05)
t <- 5/32 * z^4
lines(z,t, col = "red")

# Càlcul mitjana
mean(u)

# Càlcul variància
var(u)








