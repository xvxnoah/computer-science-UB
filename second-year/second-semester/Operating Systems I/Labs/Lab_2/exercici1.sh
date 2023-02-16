#!/bin/bash

# Comprovem que el número de paràmetres indicats siguin 2 (un directori i una extensió)
if [ $# -ne 2 ]
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

# Comprovem que el segon paràmetre sigui una extensió (string) i no sigui NULL (extra ja que
# l'enunciat no ho demana)
if [ ! -n $2 ]
then
    echo "El segon paràmetre no existeix o és NULL"
    exit 1
fi

# Guardem els dos paràmetres en variables
directori=$1
extensio=$2

# Fem ús del find per fuscar fitxers amb l'extensió indicada, imprimim la mida en bytes i el path
# per tal d'ordenar-los numèricament i després amb la comanda 'sed' eliminem la mida per tal de
# no imprimir-la per pantalla; finalment fem ús del head per imprimir només els 10 primers
find $directori -type f -name "*.$extensio" -printf "%s %p\n" | sort -n | sed 's/^[0-9]* //' | head -10

exit 0
