# En una fàbrica el nombre d'accidents per setmana segueix una llei Pois(5)

# a) Probabilitat que en una setmana hi hagi algun accident
ppois(1,5)

# b) Probabilitat que en una setmana hi hagi dos accidents
ppois(2,5)

# c) Probabilitat que en una setmana hi hagi almenys tres accidents (és a dir, 3 o més)(upper tail
# of the probability function)
ppois(2,5,lower=FALSE)


# d) El nombre mitjà d'accidents per setmana i la seva variància
x <- rpois(100,5)
mean(x)

# OJO! amb el 1/n de la variància
var <- 1/100 * sum((x-mean(x))**2)
var