#!/bin/bash

# Comprovem que el número de paràmetres indicats siguin 3 (un directori, una extensió i una cadena)
if [ $# -ne 3 ]
then
    echo "Nombre de paràmetres incorrecte: $0 <directori> <extensió>"
    exit 1
fi

# Comprovem que el primer paràmetre sigui un directori (extra ja que l'enunciat no ho demana)
if [ ! -d $1 ]
then
    echo "El primer paràmetre no és un directori"
    exit 1
fi

# Comprovem que el segon/tercer paràmetre sigui una extensió (string) i no sigui NULL
# (extra ja que l'enunciat no ho demana)
if [ ! -n $2 ] || [ ! -n $3 ]
then
    echo "El segon/tercer paràmetre no existeix o és NULL"
    exit 1
fi

# Guardem els paràmetres en variables
directori=$1
extensio=$2
cadena=$3
num_aparicions=0

# Guardem tots els fitxers que tinguin l'extensió passada per paràmetre
files=$(find $directori -type f -name "*.$extensio")

# Iterem pels fitxers i imprimim els cops que apareix la cadena en cadascun
for i in $files
do
    num_aparicions=$(grep -o "$cadena[a-z]*\b" $i | wc -l)
    echo $i
    echo "La cadena $cadena apareix " $num_aparicions " vegades"
done

exit 0
