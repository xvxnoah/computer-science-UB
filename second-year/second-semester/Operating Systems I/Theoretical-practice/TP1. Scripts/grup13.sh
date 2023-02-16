#!/bin/bash

# Comprovem que el nombre de paràmetres sigui correcte (només volem 1)
if [ $# -ne 1 ]
then
   echo "Nombre de parametres incorrecte: $0 <fitxer>"
   exit 1
fi

# Guardem l'únic paràmetre en una variable
fitxer=$1

# Comprovem que el fitxer passat com a argument existeix i no és un directori
if [ -d $fitxer ] || [ ! -f $fitxer ]
then
    echo "El paràmetre és un directori o bé no existeix el fitxer!"
    exit 1
fi

# Guardem dues varriables per comptar si els fitxers/directoris existeixen
existeixen=0
no_existeixen=0

# Amb la comanda cat escrivim el contingut del fitxer passat per argument en una variable
content=$(cat $fitxer)

# Fem un bucle per recòrrer cada linia del fitxer
for i in $content
do
  # Comprovem si existeix com a fitxer o directori; Si existeix augmentem el comptador i el mateix per si no existeix
  if [ -d $i ] || [ -f $i ]
  then
    existeixen=$((existeixen+1))
  else
    no_existeixen=$((no_existeixen+1))
  fi
done

# Finalitzem imprimint per pantalla el nombre de fitxers que existeixen i els que no existeixen
echo "Existeixen: " $existeixen
echo "No existeixen: " $no_existeixen

exit 0

