# Nombre mitjà d'automòbils: 210/hora
# Es poden atendre màxim 10 automòbils/minut
# Probabilitat que en un minut arribin a l'estació més automòbils dels que es poden atendre?
# El nombre d'automòbils que arriben a l'estació en un minut segueix una distribució de Poisson

# Nombre mitjà d'automòbils: 210/60 = 3,5 autmòbils/minut, per tant lambda = 3,5

x <- ppois(10, 3.5, lower.tail=FALSE)
x <- x*100

print(paste0("Probabilitat de que arribin mes cotxes dels que es poden atendre: ", x))