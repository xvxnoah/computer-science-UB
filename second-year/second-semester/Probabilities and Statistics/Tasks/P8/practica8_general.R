### PROBLEMA 1 ###
# Pesos en Kg de vuit dones:
pesos <- c(58, 50, 60, 65, 64, 62, 56, 57)

# (a) Podem afirmar que la mitjana teòrica és 61, sabent que sigma = 3?
# Volem fer el contrast bilateral H0 : mu = 61 / H1 : mu != 61; amb nivell de significació alpha = 0.1

# Per al vector pesos calculem la mitjana empírica:
pesosm <- mean(pesos)

# I la mitjana empírica estandaritzada:
z <- (pesosm-61)/3*sqrt(8)

# Obtenim z = -1.885618, és un valor raonable? Per poder contestar aquesta pregunta calculem el p-valor Prob[|Z| > z]:
p <- 2 * (1-pnorm(abs(z)))

# Aquest valor(p = 0.05934644) representa la probabilitat que en una mostra de mida n = 8 d'una N(mu = 61, sigma = 3) obtinguem un valor de la mitjana mostral \overline{x} igual o superior al valor obtingut a partir de la mostra x. Per tant, si aquesta probabilitat és gran suposem que H0 és certa.

# Com que p < alpha (nivell de significació) ens decidim per H1 -> No podem afirmar que la mitjana teòrica mu sigui 61.

# (b) Podem afirmar que la mitjana teòrica és 61, si sigma és desconeguda?
# Volem fer el contrast bilateral H0 : mu = 61 / H1 : mu != 61; amb nivell de significació alpha = 0.1
t.test(pesos, mu=61, alternative="two.sided", conf.level=1-0.1)
# p-value = 0.2835, no podem refutar l'hipòtesis nul.la, per tant podem afirmar que la mitjana teòrica mu és 61 amb sigma desconeguda

# (c) Podem afirmar que la variància teòrica sigma^2 és superior a 10?
# Constrast sobre variància sigma^2, test unilateral a la dreta
q <- (length(pesos) - 1) * var(pesos) / 10
p <- 1-pchisq(q, length(pesos)-1) # p = 0.02016574, que és < alpha, cal rebutjar H0 ( podem afirmar que la variància teòrica al quadrat sigui superior a 10)
check <- 0.1/2


### PROBLEMA 3 ###
# A partir de les dades de l'arxiu tterreny.txt, contrastem les següents hipòtesis amb un nivell de significació alpha = 0.05

# Carreguem el fitxer
dades <- read.table(file.choose(), header=TRUE)

# (a) Consum mitjà a 120 Km/h és de 12 litres.
# sigma desconeguda, constrast bipartit
t.test(dades$Consum120, mu=12, alternative="two.sided", conf.level = 1-0.05) # p = 0.1575, p > alpha, considerem H0 certa (el consum mitjà a 120 Km/h és de 12 litres)

# (b) La mitjana de la velocitat màxima és de 155 Km/h.
# sigma desconeguda, contrast bipartit
t.test(dades$Velocitat, mu=155, alternative="two.sided", conf.level = 1-0.05) # p = 0.1664, p > alpha, considerem H0 certa (la mitjana de la velocitat màxima és de 155 Km/h)

# (c) La mitjana del consum urbà és inferior de 12.2 litres.
# sigma desconeguda, contrast unilateral
t.test(dades$Consum.Urba, mu = 12.2, alternative="less", conf.level = 1-0.05) # p = 0.9695, p > alpha, considerem H0 certa (la mitjana del consum urbà NO és inferior a 12.2 litres)

# (d) A partir de les dades de les variables Consum90 i Consum120, podem acceptar com a vàlida l'afirmació que mu120 = mu90?
# Contrast d'una mostra de dades aparellades, test bilateral
t.test(dades$Consum120, dades$Consum90, alternative="two.sided", paired=TRUE) # p < alpha, rebutjem H0 (mu120 i mu90 no són iguals)

# (e) A partir de les dades de les variables Consum120 i ConsumUrba, podem acceptar com a vàlida l'afirmació que mu120 = mU?
# Contrast d'una mostra de dades aparellades, test bilateral
t.test(dades$Consum120, dades$Consum.Urba, alternative="two.sided", paired=TRUE) # p > alpha, acceptem H0 (mu120 i muU són iguals)

# (f) A partir de les dades de les variables Consum120 i Consum90, podem acceptar com a vàlida l'afirmació que mu120 = mu90 + 2?
t.test(dades$Consum120, dades$Consum90+2, alternative="two.sided", paired=TRUE) # p < alpha, rebutjem H0 (mu120 i mu90+2 no són iguals)


### PROBLEMA 7 ###
# Carreguem les dades
homes_actual <- c(57000, 40200, 45000, 32100, 36000)
homes_inicial <- c(27000, 18750, 21000, 13500, 18750)

dones_actual <- c(21450, 21900, 21900, 27900, 24000)
dones_inicial <- c(12000, 13200, 9750, 12750, 13500)

# (a) Podem afirmar que la mitjana teòrica del sou actual dels homes és de 42000 euros? (Nivell de significació = 0.05)
# sigma desconeguda, constrast bipartit
t.test(homes_actual, mu=42000, alternative="two.sided", conf.level = 1-0.05) # p = 0.9896, p > alpha, considerem H0 certa (la mitjana teòrica del sou actual dels homes és de 42000 euros)

# (b) Les dones, han tingut un augment de sou significatiu? (Nivell de significació = 0.05)
# Farem un contrast d'una mostra de dades aparellades i un test unilateral a la dreta, per veure si la mitjana teòrica ha augmentat respecte el sou inicial i el sou actual
t.test(dones_actual, dones_inicial, alternative="greater", paired=TRUE) # p = 0.0003091, p < alpha, rebutjem H0 (les dones han tingut un augment de sou significatiu)

# (c) Podem afirmar que el sou mitjà inicial dels homes és més alt que el de les dones?
# Contrast d'una mostra de dades aparellades i un test unilateral a la dreta
var.test(homes_inicial, dones_inicial, alternative="two.sided")
t.test(homes_inicial, dones_inicial, alternative="greater", var.equal = TRUE)





