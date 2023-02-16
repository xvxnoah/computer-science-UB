install.packages("openxlsx") # Package necessari per fer comandes amb Excel
library(openxlsx)
install.packages("modeest") # Package per calcular la moda
library(modeest)
install.packages("descr")
library(descr)
install.packages("ggplot2")
library(ggplot2)
install.packages(lattice)
library(lattice)
library("HistogramTools")
install.packages("Hmisc")
library(Hmisc)
install.packages("agricolae")
library(agricolae)

# Passos per carregar el fitxer
# Ens deixarà escollir el fitxer per afegir al nostre data frame (my_data)
my_data <- read.xlsx(file.choose(),startRow = 1,detectDates=TRUE)
my_data

#### Estudi descriptiu univariant d'aquestes variables####
## Taules de freqüències de les variables ##
# (SEX) #
sex_f_absoluta <- table(my_data$SEX) # f absoluta del sex
sex_f_relativa <- table(my_data$SEX) / length(my_data$SEX) # f relativa
write.table(sex_f_absoluta, file = "sex_f_absoluta.txt", sep = ",", quote = FALSE, row.names = F)
write.table(sex_f_relativa, file = "sex_f_relativa.txt", sep = ",", quote = FALSE, row.names = F)

# (EDAT) #
edat_f_absoluta <- table(my_data$EDAT) # f absoluta de l'edat
edat_f_abs_acumulada <- cumsum(edat_f_absoluta) # f abs acumulada d'edat
edat_f_relativa <- table(my_data$EDAT)/length(my_data$EDAT) # f relativa
edat_f_rel_acumulada <- cumsum(edat_f_relativa) # f rel acumulada d'edat
write.table(edat_f_absoluta, file = "edat_f_absoluta.txt", sep = ",", quote = FALSE, row.names = F)
write.table(edat_f_abs_acumulada, file = "edat_f_abs_acumulada.txt", sep = ",", quote = FALSE, row.names = F)
write.table(edat_f_relativa, file = "edat_f_relativa.txt", sep = ",", quote = FALSE, row.names = F)
write.table(edat_f_rel_acumulada, file = "edat_f_rel_acumulada.txt", sep = ",", quote = FALSE, row.names = F)

# (ESTUDIS) #
estudis_f_absoluta <- table(my_data$ESTUDIS) # f absoluta de estudis
estudis_f_abs_acumulada <- cumsum(estudis_f_absoluta) # f abs acumulada estudis
estudis_f_relativa <- table(my_data$ESTUDIS)/length(my_data$ESTUDIS) # f relativa estudis
estudis_f_rel_acumulada <- cumsum(estudis_f_relativa) # f rel acumulada estudis
write.table(estudis_f_absoluta, file = "estudis_f_absoluta.txt", sep = ",", quote = FALSE, row.names = F)
write.table(estudis_f_abs_acumulada, file = "estudis_f_abs_acumulada.txt", sep = ",", quote = FALSE, row.names = F)
write.table(estudis_f_relativa, file = "estudis_f_relativa.txt", sep = ",", quote = FALSE, row.names = F)
write.table(estudis_f_rel_acumulada, file = "estudis_f_rel_acumulada.txt", sep = ",", quote = FALSE, row.names = F)

# (TABAC) #
tabac_f_absoluta <- table(my_data$TABAC) # f absoluta de tabac
tabac_f_abs_acumulada <- cumsum(tabac_f_absoluta) # f abs acumulada tabac
tabac_f_relativa <- table(my_data$TABAC)/length(my_data$TABAC) # f relativa tabac
tabac_f_rel_acumulada <- cumsum(tabac_f_relativa) # f rel acumulada tabac
write.table(tabac_f_absoluta, file = "tabac_f_absoluta.txt", sep = ",", quote = FALSE, row.names = F)
write.table(tabac_f_abs_acumulada, file = "tabac_f_abs_acumulada.txt", sep = ",", quote = FALSE, row.names = F)
write.table(tabac_f_relativa, file = "tabac_f_relativa.txt", sep = ",", quote = FALSE, row.names = F)
write.table(tabac_f_rel_acumulada, file = "tabac_f_rel_acumulada.txt", sep = ",", quote = FALSE, row.names = F)

## Diagrama de barres per les variables (ESTUDIS) i (TABAC) ##
estudis <- c("Sense estudis", "Basic", "Mitja", "Superior") 
barplot(estudis_f_absoluta, main = "Diagrama de barres $ESTUDIS", xlab = "NIVELL ESTUDIS", names.arg = estudis, col = "blue")

tabac <- c("Diari", "Ocasional", "Exfumador", "Mai fumador") 
barplot(tabac_f_absoluta, main = "Diagrama de barres $TABAC", xlab = "HABIT", names.arg = tabac, col = "blue")

## Diagrama circular per lees variables (ESTUDIS) i (TABAC) ##
piepercent_estudis <- round(100*estudis_f_absoluta/sum(estudis_f_absoluta),1)
pie(estudis_f_absoluta, labels = piepercent_estudis, main = "Diagrama de sectors $ESTUDIS", col = rainbow(length(estudis_f_absoluta)))
legend("topright", estudis, fill = rainbow(length(estudis_f_absoluta)))

piepercent_tabac <- round(100*tabac_f_absoluta/sum(tabac_f_absoluta),1)
pie(tabac_f_absoluta, labels = piepercent_tabac, main = "Diagrama de sectors $TABAC", col = rainbow(length(tabac_f_absoluta)))
legend("topright", tabac, fill = rainbow(length(tabac_f_absoluta)))

## Histogrames de les variables (EDAT), (PES), (TALLA) ##
hist(my_data$EDAT, main = "Histograma $EDAT", xlab = "EDAT", ylab = "Frequencia absoluta", col = "green")

my_hist_f_abs_acum <- hist(my_data$EDAT)
my_hist_f_abs_acum$counts <- cumsum(my_hist_f_abs_acum$counts)
plot(my_hist_f_abs_acum, xaxp=c(20, 100, 10), col="blue", xlab="EDAT", ylab="Frequencia absoluta acumulada", main = "Histograma $EDAT")

histogram(my_data$EDAT, aspect= "fill", main = "Histograma $EDAT", xlab="EDAT", ylab = "Frequencia relativa (%)")

hist(my_data$PES, main = "Histograma $PES", xlab = "PES (Kg)", ylab = "Frequencia absoluta", col = "green")

hist(my_data$TALLA, main = "Histograma $TALLA", xlab = "TALLA (cm)", ylab = "Frequencia absoluta", col = "green")

## Boxplot de les variables (TABAC) i (E_SALUT) segons la variable (SEX) ##
df_tabac <- data.frame(my_data$TABAC, my_data$SEX) # Data frame per guardar el tabac i el sexe
tabac_homes <- df_tabac$my_data.TABAC[df_tabac$my_data.SEX==1]
tabac_dones <- df_tabac$my_data.TABAC[df_tabac$my_data.SEX==2]
boxplot(tabac_homes)
boxplot(tabac_dones)

df_talla <- data.frame(my_data$TALLA, my_data$SEX) # Data frame per guardar la talla i el sexe
talla_homes <- df_talla$my_data.TALLA[df_talla$my_data.SEX==1]
talla_dones <- df_talla$my_data.TALLA[df_talla$my_data.SEX==2]

## Estudi descriptiu de la variable $PES -pes en kg- distingint segons la variable $SEX -home i dona-. Recollim els estadístics numèrics ##

# Mitjana #
mean(my_data$PES) # Tots
df1 <- data.frame(my_data$SEX, my_data$PES) # Creem data frame
aggregate(my_data$PES~my_data$SEX, data = df1, FUN = mean) # Homes & dones

# Mediana #
median(my_data$PES) # Tots
aggregate(my_data$PES~my_data$SEX, data = df1, FUN = median) # Homes & dones

# Moda #
mfv(my_data$PES) # Tots
aggregate(my_data$PES~my_data$SEX, data = df1, FUN = mfv) # Homes & dones

# Desviació #
sd(my_data$PES) # Tots
aggregate(my_data$PES~my_data$SEX, data = df1, FUN = sd) # Homes & dones

# Variància #
var(my_data$PES) # Tots
aggregate(my_data$PES~my_data$SEX, data = df1, FUN = var) # Homes & dones

# Coeficient de variació #
coef_var <- sd(my_data$PES)/mean(my_data$PES) * 100 # Tots
coef_var_homes <- 12.87477/79.16195 * 100
coef_var_dones <- 12.32932/65.37478 * 100
coef_var
coef_var_homes
coef_var_dones

# Q1 & Q3#
quantile(my_data$PES) # Tots
aggregate(my_data$PES~my_data$SEX, data = df1, FUN = quantile) # Homes & dones

# Mínim #
# Quartil 0 és el mínim

# Màxim #
# Quartil 4 és igual al màxim

# Rang #
# Rang = max(x1, ..., xn) - min(x1, ..., xn)
rang_tots <- quantile(my_data$PES, 1) - 26.9431 # Tots (rang)
rang_homes <- 140 - 44
rang_dones <- 140 - 26.9431
rang_tots
rang_homes
rang_dones

# Rang interquartílic #
# IQR = Q3 - Q1
Q1 <- quantile(my_data$PES, 0.25)
Q3 <- quantile(my_data$PES, 0.75)
IQR <- Q3 - Q1
IQR # Tots

Q1_homes <- 70
Q3_homes <- 86
Q1_dones <- 57
Q3_dones <- 72

IQR_homes <- Q3_homes - Q1_homes
IQR_dones <- Q3_dones - Q1_dones
IQR_homes
IQR_dones

# Skewness #
skewness(my_data$PES) # Tots
aggregate(my_data$PES~my_data$SEX, data = df1, FUN = skewness) # Homes & dones

# Curtosis #
kurtosis(my_data$PES) # Tots
aggregate(my_data$PES~my_data$SEX, data = df1, FUN = kurtosis) # Homes & dones
hist(my_data$PES, freq=FALSE)
lines(density(my_data$PES), col="red", lwd=3)
abline(v=c(mean(my_data$PES), median(my_data$PES)), col=c("green", "blue"), lty=c(2,2), lwd=c(3,3))

# Gràfics #
df_pes <- data.frame(my_data$PES, my_data$SEX) # Data frame per guardar el pes i el sexe
pes_homes <- df_pes$my_data.PES[df_pes$my_data.SEX==1]
pes_dones <- df_pes$my_data.PES[df_pes$my_data.SEX==2]

hist(pes_homes, main = "Histograma homes $PES", xlab = "PES (Kg)", ylab = "Frequencia absoluta", col = "green")

hist(pes_dones, main = "Histograma dones $PES", xlab = "PES (Kg)", ylab = "Frequencia absoluta", col = "green")

mynames <- c("homes", "dones")
boxplot(pes_homes, pes_dones, main="Boxplot homes/dones $PES", xlab="SEX", ylab="PES", col="yellow", border="brown", names=mynames)


#### Estudi bivariant, utilitzant el model lineal, per les observacions de dues variables del fitxer ####
## Taula de contingència de les variables $SEX i $ESTUDIS ##
df_estudis <- data.frame(my_data$ESTUDIS, my_data$SEX)
estudis_homes <- df_estudis$my_data.ESTUDIS[df_estudis$my_data.SEX==1]
estudis_dones <- df_estudis$my_data.ESTUDIS[df_estudis$my_data.SEX==2]

table(unlist(estudis_homes))
table(unlist(estudis_dones))

cole = c("yellow", "darkblue", "red", "green")
x_text = c("Sense estudis", "Basic", "Mitja", "Superior")
matrix1 <- matrix(c(139,1704,1412,670,189,1636,1280,823), nrow=4, dimnames= list(rownames, colnames))
rownames = c("Sense estudis", "Basic", "Mitja", "Superior")
colnames = c("homes", "dones")
legend("top", x_text, fill = cole)
barplot(matrix1, ylab="Frequencia", col = cole, beside=FALSE)

## Núvol de punts entre la variable $PES i $TALLA (alçada); primer homes, després dones ##
df_pes <- data.frame(my_data$PES, my_data$SEX) # Data frame per guardar el pes i el sexe
pes_homes <- df_pes$my_data.PES[df_pes$my_data.SEX==1]
pes_dones <- df_pes$my_data.PES[df_pes$my_data.SEX==2]

df_talla <- data.frame(my_data$TALLA, my_data$SEX) # Data frame per guardar la talla i el sexe
talla_homes <- df_talla$my_data.TALLA[df_talla$my_data.SEX==1]
talla_dones <- df_talla$my_data.TALLA[df_talla$my_data.SEX==2]

plot(talla_homes, pes_homes, main = "Diagrama de punts (homes)", xlab="Talla (cm)", ylab="Pes (Kg)", pch=19, col = "red")

plot(talla_dones, pes_dones, main = "Diagrama de punts (dones)", xlab="Talla (cm)", ylab="Pes (Kg)", pch=19, col = "red")
par(bg = "grey") # Change background

## Núvol de punts entre la variable $ESTUDIS i $TABAC; de homes i dones ##
df_estudis <- data.frame(my_data$ESTUDIS, my_data$SEX)
df_tabac <- data.frame(my_data$TABAC, my_data$SEX)

estudis_homes <- df_estudis$my_data.ESTUDIS[df_estudis$my_data.SEX==1]
estudis_dones <- df_estudis$my_data.ESTUDIS[df_estudis$my_data.SEX==2]

tabac_homes <- df_tabac$my_data.TABAC[df_tabac$my_data.SEX==1]
tabac_dones <- df_tabac$my_data.TABAC[df_tabac$my_data.SEX==2]
table(unlist(tabac_homes))
table(unlist(tabac_dones))

plot(estudis_homes, tabac_homes, main = "Diagrama de punts (homes)", xlab="Estudis", ylab="Tabac", pch=19, col = "red")
par(bg = "grey") # Change background
plot(estudis_dones, tabac_dones, main = "Diagrama de punts (dones)", xlab="Estudis", ylab="Tabac", pch=19, col = "red")






