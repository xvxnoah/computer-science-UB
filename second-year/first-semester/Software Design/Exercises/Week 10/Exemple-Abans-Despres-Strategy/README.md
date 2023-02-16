# Problema de patrons
Problema plantejat per Miquel Albertí - curs 2020-21

#  Enunciat

El nostre client és un resident de Mallorca que pertany a una família nombrosa, i cada cop que va comprar un vol té el següent problema:
No sap el preu que ha de pagar perquè depenent del vol se li apliquen descomptes diferents. El preu a pagar és el preu del vol
aplicant un dels següents descomptes:

- Si és un vol amb origen i/o destí les Illes Balears, se li aplica el descompte "Resident illes" del 75%.
- Si és un vol nacional, però no és del cas anterior, se li aplica el descompte "Família Nombrosa" del 5%.
- Si és un vol internacional, no té cap descompte.

Per tant el nostre client vol una calculadora per saber sempre el preu que ha de pagar, que serà la nostra classe CalculadoraPreuVol. A la carpeta "abans" es troba el codi a refactoritzar. 

# Carpeta "abans"
Clarament aquesta aproximació vulnera l'OCP, ja que si volguéssim afegir el càlcul d'un altre tipus de vol amb un descompte diferent, caldria modificar la classe CalculadoraPreuVol.

# Primera aproximació: carpeta "després1"
Amb aquesta aproximació ja no vulnerem l'OCP, ja que per implementar una nova calculadora amb un descompte diferent simplement
hem de crear una nova classe que estengui la classe CalculadoraPreuVol, sense tocar res del codi ja escrit.

Però el problema ara és un altre: cada cop que volem canviar de calculadora cal fer un new de la filla de CalculadoraPreuVol corresponent,
i per tant cada cop hem de tornar a inicialitzar la variable moneda, malgrat que aquesta no canviï. En aquest cas només és una String,
i per tant no hi ha gaire problema, però en un futur els atributs de la superclasse compartits per totes les filles podrien créixer, i els hauria
d'inicialitzar tots cada cop que vulgui un comportament diferent. 

# Aproximació definitiva (Patró Strategy): carpeta "després2"

Aplicant el patró strategy hem solucionat el problema de la segona aproximació. Ara, la classe Calculadora és el context, on 
guardem les variables comunes a totes les estratègies, com és la moneda en aquest cas. Si necessitem aplicar un descompte diferent, només
caldrà injectar l'estratègia desitjada dinàmicament, utilitzant el mètode setStrategy(), sense necessitat d'haver d'inicialitzar de nou
la moneda si sempre volem treballar amb la mateixa divisa.

I a més seguim respectant l'OCP, ja que si volem una calculadora amb un nou descompte, només cal implementar una nova CalculadoraStrategy,
sense tocar cap classe ja escrita.
