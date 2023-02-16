# Un examen té 8 preguntes amb 4 respostes possibles, de les quals només hi ha una correcta
# Per aprovar l'examen: contestar almenys la meitat de les preguntes bé
# Un alumne ha contestat a l'atzar totes 8 preguntes, calculeu:

# Donat que només hi ha dos resultats possibles (correcte, incorrecte) podem utilitzar una distribució
# binominal per conéixer les nostres expectatives d'èxit en un examen d'opció múltiple.

# L'examen té 8 preguntes, per aprovar necessitem 4 correctes, per tant la probabilitat d'obtenir 4 respostes correctes o més serà: P(x = 4) = (8!/4!*4!)*.25^4*.75^4
# Recordem que la probabilitat d'un rang de resultats és la suma de totes les probabilitats de tal forma que
# la probabilitat d'aprovar l'examen és igual a la suma de probabilitats de totes les respostes correctes
# P(x>=4) = P(x=4) + P(x=5) + P(x=6) + P(x=7) + P(x=8)

# Probabilitat dins de les 4 possibles opcions de resposta: 25%
prob.aprovar <- dbinom(4, 8, 0.25) + dbinom(5, 8, 0.25) + dbinom(6, 8, 0.25) + dbinom(7, 8, 0.25) + dbinom(8, 8, 0.25)

# a) Probabilitat d'aprovar l'examen
prob.aprovar

# b) Probabilitat d'encertar totes les preguntes
prob.encertat.totes <- dbinom(8,8,0.25)
prob.encertat.totes

# c) Nombre mitjà de respostes correctes i la seva variància
prob.respostes.correctes <- dbinom(1,4,0.25) * 8 # Probabilitat dins de cada pregunta * nº preguntes

print(paste0("Nombre de preguntes totals de l'examen: ", 8*4), sep='')
mitja <- mean(prob.respostes.correctes)
print(paste0("Nombre mitja de respostes correctes: ", mitja))
x <- c(1:8)

var <- 1/8 * sum((x-mitja)**2)
var