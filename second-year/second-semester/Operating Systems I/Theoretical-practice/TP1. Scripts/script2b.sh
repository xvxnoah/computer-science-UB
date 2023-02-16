#!/bin/bash

if [ $# -ne 1 ]
then
   echo "Nombre de parametres incorrecte: $0 <directori>"
   exit 1
fi

directori=$1

if [ ! -d $directori ]
then
    echo "El paràmetre NO és un directori!"
    exit 1
fi

comptador=0
fitxers=$(ls $directori)

for i in $fitxers
do
  comptador=$((comptador+1))
done

echo $comptador

exit 0

