# Funció en R
first_function <- function(x){
	suma <- 0
	for (n in 0:abs(x)){
		suma <- suma + (2**n*factorial(n))/(n+14)
	}
	
	suma
}

first_function(-2)