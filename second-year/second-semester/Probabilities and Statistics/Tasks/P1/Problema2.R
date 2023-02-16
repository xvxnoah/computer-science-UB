# Definició de dues matrius i la seva multiplicació
# byrow = fill matrix by rows
x <- matrix(c(0,1,-1,1,-1,1,0,-1), nrow=2, ncol=4, byrow=TRUE)
y <- matrix(c(1,2,3,4,5,6,7,8,9,10,11,12), nrow=4, ncol=3, byrow=TRUE)
x
y

z <- x %*% y
z

# Accés al segon element de la segona columna de la matriu resultant
z[2,2]