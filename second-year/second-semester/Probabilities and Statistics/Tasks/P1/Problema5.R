# Funció en R
n <- 100
third_function <- function(x){
	suma <- 0
	for (k in 1:n){
		z <- 2*k
		suma <- suma + ((x**k)+(x**z))/(factorial(k))
	}
	suma
}

third_function(4)