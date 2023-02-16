#!/bin/bash

# Comprovem que el número de paràmetres indicats siguin 3 (niub, problemes/pràctiques, nou grup)
if [ $# -ne 3 ]
then
    echo "Nombre incorrecte de paràmetres"
    exit 1
fi

niub=$1
tipus=$2
nou_grup=$3

# Índex de la linía on es troba el niub indicat per paràmetre
row=$(grep -n $niub alumnes.csv | awk -F ":" '{print $1}')

# Si l'índex de línia es troba buit
if [ -z "$row" ]
then
    echo "El NIUB no es troba al fitxer!"
    exit 1
fi

# Comprovem segons el segon parametre si volem modificar el grup de practiques o de problemes
if [[ "practiques" == "$tipus" ]]
then
    # Obtenim el grup de pràctiques actual
	grup=$(grep $niub alumnes.csv | awk -F ";" '{print $2}')

elif [[ "problemes" == "$tipus" ]]
then
    # Obtenim el grup de problemes actual
	grup=$(grep $niub alumnes.csv | awk -F ";" '{print $3}')

else
    echo "No has introduït el tipus de grup correctament!"
    exit 1
fi

# Substituïm en el fitxer l'antic grup pel nou
sed -i "$row s/$grup/$nou_grup/" alumnes.csv
echo "Grup de $tipus modificat"

exit 0
