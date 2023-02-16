#!/bin/bash

# Comprovem que el número de paràmetres indicats siguin 2 (un directori i un valor numèric)
if [ $# -ne 2 ]
then
    echo "Nombre de paràmetres incorrecte: $0 <directori> <valor numèric>"
    exit 1
fi

# Comprovem que el primer paràmetre sigui un directori (extra ja que l'enunciat no ho demana)
if [ ! -d $1 ]
then
    echo "El primer paràmetre no és un directori"
    exit 1
fi

# Guardem els dos paràmetres en variables
directori=$1

# Fem ús de la comanda find per tal de trobar els fitxers segons les condicions especificades
# a l'enunciat: només dins del directori, ignorant subdirectoris (maxdepth 1), i la mida en
# bytes de tots els fitxers amb mida igual o superior (si fem un NOT <, obtenim >= que és el
# que volem)
find $directori -maxdepth 1 -type f -not -size -$2c -printf "%p : %s bytes\n"

exit 0
