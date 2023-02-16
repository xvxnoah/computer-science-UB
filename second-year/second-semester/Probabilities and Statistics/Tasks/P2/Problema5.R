# boxplot del pes segons la dieta
boxplot(ChickWeight$weight~ChickWeight$Diet)

pes = ChickWeight$weight
edat = ChickWeight$Time
# diagrama de dispersió del pes i els dies d'edat
plot(pes, edat)

# recta de regressió de la variable pes respecte l'edat afegida al gràfic


abline(lm(pes~edat))
# Un pollet de 9 dies pesa: 
x <- iris$Petal.Length
y <- iris$Sepal.Length
plot(x, y)
lm(x~y)

x<-lm(iris$Petal.Length~iris$Sepal.Length)
abline(x)