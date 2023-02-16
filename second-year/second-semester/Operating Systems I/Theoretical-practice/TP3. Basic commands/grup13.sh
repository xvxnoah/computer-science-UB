#!/bin/bash

# Comprovem que el número de paràmetres indicats sigui 1 (un directori)
if [ $# -ne 1 ]
then
    echo "Nombre de paràmetres incorrecte: $0 <directori>"
    exit 1
fi

# Comprovem que el primer paràmetre sigui un directori
if [ ! -d $1 ]
then
    echo "El paràmetre no és un directori"
    exit 2
fi

# Guardem el paràmetre en una variable
directori=$1

# Variable que comptarà el nombre de fitxers dins de cada subdirectori del directori indicat
nfiles=0

# Amb la comanda ls accedim al contingut del directori passat per argument en una variable
content=$(ls $directori)

# Fem un bucle per recòrrer tot el contingut del directori
for i in $content
do
    # Reconstruir el path
    fitxerActual=$directori/$i

    # Si és un fitxer, augmentem el comptador
    if [ -f $fitxerActual ]
    then
        ((nfiles++))

    # Altrament si és un directori farem una crida recursiva
    elif [ -d $fitxerActual ]
    then
        ./$0 $fitxerActual
    fi

done

# Imprimim els resultats
echo "directori: $directori nfiles: $nfiles"

exit 0
