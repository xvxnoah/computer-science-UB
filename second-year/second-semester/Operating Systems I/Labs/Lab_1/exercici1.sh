#!/bin/bash

# Comprovem que el nombre de paràmetres sigui correcte (només volem 1)
if [ $# -ne 1 ]
then
   echo "Nombre de paràmetres incorrecte: $0 <directori>"
   exit 1
fi

# Guardem l'únic paràmetre en una variable
directori=$1

# Comprovem que l'argument sigui un directori
if [ ! -d $directori ]
then
   echo "El paràmetre no és un directori"
   exit 1
fi

# Guardem dues varriables per comptar els fitxers/directoris del directori indicat
fitxers=0
directoris=0

# Amb la comanda ls accedim al contingut del directori passat per argument en una variable
content=$(ls $directori)

# Cambiem el directori de treball al directori especificat
cd $directori

# Fem un bucle per recòrrer tot el contingut del directori
for i in $content
do
  # Si estem davant un fitxer, incrementem el seu comptador
  if [ -f $i ]
  then
    ((fitxers++))
  # Altrament, si és un directori, augmentem el seu comptador
  elif [ -d $i ]
  then
    ((directoris++))
  fi
done

# Finalitzem imprimint per pantalla el nombre de fitxers/directoris que existeixen
echo "Fitxers: " $fitxers
echo "Directoris: " $directoris

exit 0
