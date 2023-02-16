#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Nombre incorrecte de paràmetres."
    exit 1
fi

directori=$1

ls -l $directori > dataFiles.txt

valors=$(awk '{print $5}' dataFiles.txt)

sumaSize=0

for i in $valors
do
    sumaSize=$((sumaSize + $i))
done

echo "La mida del directori '$directori' és de: $sumaSize Bytes."

rm dataFiles.txt

exit 0
