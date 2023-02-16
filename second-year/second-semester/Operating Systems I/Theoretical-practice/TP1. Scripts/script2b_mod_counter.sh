#!/bin/bash

if [ $# -ne 1 ]
then
   echo "Nombre de parametres incorrecte: $0 <fitxer>"
   exit 1
fi

comptador=0
fitxer=$1
paraules=$(cat $fitxer)
for i in $paraules
do
  comptador=$((comptador+1))
done

echo $comptador

exit 0

