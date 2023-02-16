#!/bin/bash

# Comprovem que el número de paràmetres indicats siguin 2 (un directori i un valor numèric)
if [ $# -ne 2 ]
then
    echo "Nombre de paràmetres incorrecte: $0 <directori> <valor numèric>"
    exit 1
fi

# Comprovem que el primer paràmetre sigui un directori
if [ ! -d $1 ]
then
    echo "El primer paràmetre no és un directori"
    exit 1
fi

# Guardem els dos paràmetres en variables
directori=$1
valor=$2

# Guardem en un fitxer de text la informació dels fitxers presents en el directori
ls -l $directori > dataFiles.txt

# Volquem el contingut de la 5ª columna (mida dels fitxers) en una variable
text=$(awk '{print $5}' dataFiles.txt)

# Iniciem un comptador a 2, ja que és la fila a la que comença la informació al dataFiles
# Aquest comptador ens servirà per fer un seguiment de quina mida correspon a cada fitxer
comptador=2

# Fem un bucle iterant per cada mida que hem extret
for i in $text
do
    # Si és més gran o igual al valor entrat per paràmetre, imprimim per pantalla
    if [ $i -ge $valor ]
    then
        # Seleccionem el nom del fitxer (9ª columna) segons a la fila (NR) que ens trobem
        file=$(awk "NR==$comptador"'{print $9}' dataFiles.txt)
        echo $file": " $i " Bytes"

        # Augmentem el valor del comptador
        ((comptador++))
    # Si la mida actual no és més gran o igual que el valor entrat per paràmetre, continuem buscant i augmentem el comptador
    else
        ((comptador++))
    fi
done

# Eliminem el fitxer temporal
rm dataFiles.txt

exit 0


# Alternativa
#Fem un vector
#size=($(awk '{print $}' dataFiles.txt))
#noms=($(awk '{print $9}' dataFiles.txt))


#len=${#size[*]}

#i = 0

#while [ $i -lt $len ]
#do

 #   nom_fitxer=$1/${nom[$i]}

  #  if fitxer

   # mida_fitxer=${size[$i]}

    #if mida > $2
     #   ech "${nom[$i]}: ${size[$i]} Bytes"

    # (( i++ ))
