# Dades de LakeHuron
# Diagrama de tija i fulles
stem(LakeHuron)

# boxplot
boxplot(LakeHuron)

# Per defecte
hist(LakeHuron)

# Amb 5 classes (no ho fa)
hist(LakeHuron, nclass=5)

# Histograma amb intervals desiguals (dona error)
hist(LakeHuron, breaks=c(576,577,578,579,580,582))

# Primer quartil
quantile(LakeHuron, 0.25)

# Percentils 20, 45, 89
quantile(LakeHuron, probs=c(0.2, 0.45, 0.89))

