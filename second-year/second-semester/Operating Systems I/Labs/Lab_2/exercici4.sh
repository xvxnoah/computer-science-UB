#!/bin/bash

# Comprovem que el número de paràmetres indicats siguin 2 (un directori i una extensió)
if [ $# -ne 1 ]
then
    echo "Nombre de paràmetres incorrecte: $0 <directori>"
    exit 1
fi

# Comprovem que el primer paràmetre sigui un directori (extra ja que l'enunciat no ho demana)
if [ ! -d $1 ]
then
    echo "El primer paràmetre no és un directori"
    exit 1
fi

# Guardem el paràmetre en una variable
directori=$1

# Guardem en una variable el nombre de fitxers del directori
num_files=$(find $directori -type f | wc -l)
echo $num_files " files"
sum=0

# Fent ús del find i la seva potència, juntament amb la potència del awk, aconseguim el
# que demana l'enunciat que es sumar la columna que a l'hora de fer el 'ls -l' ens dona
# la mida en bytes dels fitxers
find $directori -type f -exec ls -l {} \; | awk '{sum+=$5} END {print sum " bytes"}'

exit 0
