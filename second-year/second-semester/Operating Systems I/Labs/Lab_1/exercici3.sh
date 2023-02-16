#!/bin/bash

# Comprovem que el número de paràmetres sigui 2 (un directori i una cadena de text)
if [ $# -ne 2 ]
then
    echo "Nombre de paràmetres incorrecte: $0 <directori> <string>"
    exit 1
fi

# Comprovem que el primer paràmetre és un directori
if [ ! -d $1 ]
then
    echo "El primer argument no és un directori"
    exit 1
fi

# Guardem els paràmetres en dues variables
directori=$1
cadena=$2

# Guardem la mida de la cadena
sizeCadena=${#cadena}

# Obtenim el contingut del directori que ens han indicat
content=$(ls $directori)

# Cambiem el directori de treball al directori especificat
cd $directori

# Fem un bucle iterant per tot els elements del directori
for file in $content
do
    # Només tindrem en compte els elements que siguin fitxers
    if [ -f $file ]
    then
        # Comprovem que el present fitxer tingui l'extensió '.txt'
        if [ ${file:(-4):4} = ".txt" ]
        then
            # Afegim un comptador per saber les coincidències que hem trobat
            comptador=0

            # Guardem en una variable tot el contingut del present fitxer
            paraules=$(cat $file)

            # Iterem per totes les paraules del present fitxer .txt per veure si tenim coincidències
            # Les condicions són que la paraula ha de començar pel mateix patró que l'indicat, respectant majúscules i minúscules
            for paraula in $paraules
            do
                # La paraula en la que ens trobem ha de complir dues condicions abans de comprovar si conté o no el patró:
                # 1. Que sigui més gran o igual a la cadena que estem buscant
                # 2. Que comenci per la mateixa lletra
                sizeWord=${#paraula}

                if [[ $sizeWord -ge $sizeCadena ]] && [[ ${paraula:0:1} = ${cadena:0:1} ]];
                then
                    # Si hem arribat fins aquí ja hem de comprovar si la subcadena conté la cadena indicada
                    # Com hem dit que hem de comprovar des del principi, farem un slicing des del principi
                    # de la paraula actual i el compararem amb la nostra cadena
                    substring=${paraula:0:$sizeCadena}

                    if [ $substring = $cadena ]
                    then
                        echo "$file: $paraula"
                        ((comptador++))
                    fi
                fi
            done

            # Ara indiquem quantes paraules hem trobat al present fitxer que tenien coincidències amb la cadena indicada
            echo "Total $file: $comptador"
        fi
    fi
done

exit 0
