#!/bin/bash

# Comprovem que el nombre de paràmetres sigui correcte (només volem 1)
if [ $# -ne 1 ]
then
    echo "Nombre de paràmetres incorrecte: $0 <string>"
    exit 1
fi

# Guardem l'únic paràmetre en una variable
string=$1

# Si la variable existeix i no és NULL
if [ -n $string ]
then
    # Guardem la llargada del string per recòrre'l
    lenString=${#string}

    # Creem una variable on guardarem el nostre string invertit
    inversedWord=""

    # Fem un bucle comenzant des del final del nostre string i anem invertint-lo
    for ((i = lenString - 1; i >= 0; i--))
    do
        # Fem slicing de l'string, creant així un substring
        inversedWord+=${string:$i:1}
    done

    # Si la nostra paraula inicial és igual a l'invertida, serà un palíndrom
    if [ $string == $inversedWord ]
    then
        echo "Són un palíndrom"
        exit 0
    else
        echo "No són un palíndrom"
        exit 2
    fi
# Si la variable no existeix o bé és NULL
else
    exit 3
fi

# Altre opció
#mida=${#paraula}

#((mida--))

#for((i=mida;i>=0;i--))
#    paraula_invertida=$paraula_invertida${paraula:$i:1}
#done
