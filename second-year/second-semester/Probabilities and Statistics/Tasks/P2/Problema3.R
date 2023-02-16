# boxplot variables
boxplot(InsectSprays)

# boxplot per cada marca
boxplot(count~spray, data=InsectSprays)

# histograma variable count
hist(InsectSprays$count)