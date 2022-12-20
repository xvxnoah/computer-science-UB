/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author noahi
 */
import java.util.*;
public class Palindrom2{
    public static void main(String[]args){
    Scanner sc = new Scanner(System.in);
    String frase;
    int i, j;
    boolean esPalindrom = true;
    frase = "";

    while (!(frase.equals("fi"))){
        System.out.println("Entra una frase [fi per acabar]:");
        frase = sc.nextLine();
        frase = frase.toLowerCase();
        frase = frase.replace(" ", "");
        if (frase.equals("fi")){
            System.out.println("Programa acabat");
            break;
        }
        i = 0;
        j = frase.length()-1;

        while ((i < j) && esPalindrom){

            if (frase.charAt(i) != frase.charAt(j)){
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
}
