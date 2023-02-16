#!/bin/bash

# Comprovem que el número de paràmetres indicats sigui 1 (un usuari del sistema)
if [ $# -ne 1 ]
then
    echo "Nombre de paràmetres incorrecte: $0 <directori>"
    exit 1
fi

# Variables per guardar els valors de VSZ i RSS
total_VSZ=0
total_RSS=0

# Execució de les comandes per tal d'arribar al nostre objectiu; amb el grep ens qudem només
# amb els procesos de l'usuari indicat per paràmetre i amb l'awk sumem les columnes corresponents
# al VSZ i al RSS
ps aux | grep "\b$1" | awk '{total_VSZ+=$5} {total_RSS+=$6} END {print "VSZ: " total_VSZ " bytes\n" "RSS: " total_RSS " bytes"}'

exit 0
