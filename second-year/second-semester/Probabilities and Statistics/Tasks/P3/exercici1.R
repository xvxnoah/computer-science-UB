# Simulacions amb distribució Poisson
N <- 50
x <- rpois(N,2)
x

# Calculem la mitjana de la simulació
mean(x)

# Calculem la variància corregida de les simulacions
var(x)

# Augmentem N fins obtenir una bona aproximació (mean i var gairebé iguals)
N <- 5000
x <- rpois(N,2)
mean(x)
var(x)

# LES DIFERENTS DISTRIBUCIONS TENEN UNA FORMA TEÒRICA DE CALCULAR LA MITJANA