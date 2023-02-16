# Funció en R
second_function <- function(x,y){
	suma <- 0
	for (k in 1:length(x)){
		t <- x[k]
		z <- y[k]
		numerador <- (t - (2**t))*z
		suma <- suma + numerador/factorial(k)
	}
	suma
}

x <- c(1,2)
y <- c(2,3)

