/*
Fer un programa que introduïda una paraula digui si es palindroma o no.

1.Identificació de l'esquema:
RECORREGUT
2.
    -->Primer(i): 0
    -->Següent(i): i++
    -->FiSeq(i): i>= frase.length()/2.
Això pel codi següent:

for)int= 0; i<(frase.length()/2; i++){
    if(frase.charAt(i) == frase.charAt(frase.length()-1-i)){
        cont++;
}

if(cont==(frase.length()/2); i++){
    System.out.println("Són palíndroms.");
    }else{
        System.out.println("No són palíndroms.");
}
 */

import java.util.*;
public class Palindrom1{
    public static void main(String[] args) {
    Scanner sc = new Scanner(System.in);
    String paraula;
    int i, j;
    boolean esPalindrom = true;
    paraula = "";


    System.out.println("Entra una paraula:");
    paraula = sc.nextLine();
    paraula = paraula.toLowerCase();

    i = 0;
    j = paraula.length()-1;

    while ((i < j) && esPalindrom){

        if (paraula.charAt(i) != paraula.charAt(j)){
            esPalindrom = false; 
        }
        i += 1;
        j -= 1;
    }
    if (esPalindrom){
        System.out.println("Si es palindrom");
    }
    else{
        System.out.println("NO es palindrom");
    }

    }
}
