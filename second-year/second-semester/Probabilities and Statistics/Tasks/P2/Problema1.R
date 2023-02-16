x <- rep(c(0,1,2,3,4,5), c(40,52,83,24,12,4))
y <- table(x)
taula <- as.data.frame(y)
taula
taula <- transform(taula, Freq.Acum = cumsum(Freq), Freq.Rela = prop.table(Freq), Freq.Rela.Acum = cumsum(prop.table(Freq)))
taula

#mitjana
mean(x)

#mediana
median(x)

#variància
v_corregida <- sd(x)*((length(x)-1)/length(x))**1/2
v_corregida

#variància corregida
var(x)

#desviació estàndar (o típica)
sqrt(v_corregida)
#desviació estàndar (o típica) corregida
sd(x)