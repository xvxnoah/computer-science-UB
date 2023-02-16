# Gràfic de punts de dues variables del fitxer peixos (amb títol i nom dels eixos)
x <- read.table("/Users/noahmv/Documents/R_PE/peixos.txt", sep=",")
x
plot(x$V1, x$V2, xlab='V1', ylab='V2',main="Grafic de punts de V1 i V2")
