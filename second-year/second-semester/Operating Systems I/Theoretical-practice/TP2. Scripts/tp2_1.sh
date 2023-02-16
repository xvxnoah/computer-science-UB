#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Nombre incorrecte de paràmetres."
    exit 1
fi

fitxer=$1

col1=($(awk '{print $1}' $fitxer))
col2=($(awk '{print $2}' $fitxer))
len=${#col1[*]}

i=0
comptador=0

while [ $i -lt $len ]
do
    if [ ${col1[$i]} -gt ${col2[$i]} ]
    then
        ((comptador++))
    fi
    ((i++))
done

echo "Hi ha $comptador números de la primera columna superiors als de la segona"
exit 0

