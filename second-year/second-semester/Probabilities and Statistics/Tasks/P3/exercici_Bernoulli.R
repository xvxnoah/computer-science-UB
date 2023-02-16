# Generem 400 nombres aleatoris amb distribució Bernoulli (Bn(1,p)) en forma de matriu amb 
# 40 files i 10 columnes.
N <- 400
x <- matrix(rbinom(N,1,0.3), nrow=40)

# apply permet fer càlculs paral·lels
apply(x,1,mean) # Fa mitjanes per files
apply(x,2,mean) # Fa mitjanes per columnes

apply(x,1,sd) # Fa desviació estàndard corregida per files
apply(x,2,sd) # Fa desviació estàndard corregida per columnes

apply(x,1,median) # Fa medianes per files
apply(x,2,median) # Fa medianes per columnes