/*
Feu un programa per a veure si cada caràcter 'a' d'una paraula llegida per teclat
està contenta. Una 'a' està contenta si té a la seva esquerra o a la seva dreta
una altre 'a'. El programa ens diu si totes les 'a' estan contentes.

Per exemple: si introduïm "zdaaoa" el programa mostra el missatge "No totes les 
a estan contentes, amb la cadena "zdaa" el programa mostra "Totes les a estan
contentes.
 */

import java.util.*;
public class AContenta {
    public static void main(String[]args){
        Scanner sc = new Scanner(System.in);
        boolean a_feliz = true;
        int i, j = 0;
        String paraula;
        
        System.out.println("Introdueix una paraula per veure si les seves 'a'"
                + "són contentes:");
        paraula = sc.nextLine();
        paraula = paraula.toLowerCase();
        
        j = paraula.length();
        
        for (i = 0; i < j; i++){
            if(paraula.charAt(i) == 'a'){
                if(i > 0 && paraula.charAt(i-1) == 'a'){
                    a_feliz = true;
                }
                else if (i < j-1 && paraula.charAt(i+1) == 'a'){
                    a_feliz = true;
                }
                else{
                    a_feliz = false;
                }
            }
        }
        if (a_feliz){
            System.out.println("Totes les 'a' estan contentes.");
        }
        else{
            System.out.println("No totes les 'a' estan contentes");
        }
    }
}
