/*author:   Noah
data:     11/10/2020
version:  1.0
*/

/*
Feu un programa per obtenir el caràcter a l’índex indicat per teclat dins de
la cadena. Comprova que l'index que s'introdueix és correcte
(està dintre dels límits del String [0,length-1]).  Per  exemple, 
si  s’indica  1  i  la  cadena  es  “Hola”,  el  programa  ha d’imprimir
“A la posició 1 està el caràcter o”. Si s'indica 4, el programa imprime
"Index no correcte".

ENTRADA // SORTIDA
-------------------------
Hola, 1 ->A la posició 1 està el caràcter o.
Flor, 2 ->A la posició 2 està el caràcter o.
Tres, 5 ->Index no correcte
*/

import java.util.*;
public class Caracter {
    public static void main (String [] args){
        Scanner sc = new Scanner(System.in);
        String paraules;
        System.out.println("Introdueix un String: ");
        paraules = sc.next();
        System.out.println("Introdueix l'índex: ");
        int index = sc.nextInt();
        if (index < paraules.length() - 1){
            char a = paraules.charAt(index);
            System.out.println("A la posició "+ index + " està el caràcter "
                    + a +".");  
        }
        else{
            System.out.println("Index no correcte");
        }
               
    }
}
