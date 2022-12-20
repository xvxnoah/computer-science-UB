/*
Escriviu un programa que llegeixi una frase i imprimeixi per pantalla el nombre
de lletres 'a' que tingui.
 */

import java.util.*;
public class NumA {
    public static void main(String []args){
        int i, comptador = 0;
        String frase;
        Scanner sc = new Scanner(System.in);
        
        System.out.println("Introdueix una frase:");
        frase = sc.nextLine();
        frase.toLowerCase();
        
        for (i = 0; i < frase.length(); i++){
            if (frase.charAt(i) == 'a'){
                comptador++;
            }
        }
        if (comptador > 0){
            System.out.println("A la frase hi ha " + comptador + " a(s)");
        }else{
            System.out.println("No hi ha cap 'a'");
        }
    }
}
