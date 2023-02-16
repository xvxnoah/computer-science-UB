# Distribució geomètrica: si volem fer 100 simulacions del nombre de llançaments necessaris
# d'un dau fins que surti un 6
N <- 100
x <- rgeom(N, 1/6) # Cada possible número del dau té una probabilitat de 1/6 (6 números possibles)
x

# Fem la següent operació ja que la Geomètrica compta els intents necessaris fins a obtenir
# el primer èxit. En canvi en R, la Geomètrica compta el nombre d'intents fallits fins a
# obtenir el primer èxit, per tant compta un de menys respecte el que hem vist a teoria
x <- x+1
x

# Calculem la mtjana de la simulació (serà n*p)
mean(x)

# Calculem la variància corregida de les simulacions
var(x)