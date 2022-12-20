/*author:   Noah
data:     07/10/2020
version:  1.0
*/
/*Feu un programa que donat un nombre enter escriu si és un dígit o no.
Per exemple, si  l’usuari  introdueix  234  ha  de  sortir  el  missatge  
“No  es  un  dígit”,  si  l’usuari introdueix 4, ha de sortir el missatge 
“Es un dígit”.
*/

import java.util.*;
public class Digit {
    public static void main (String [] args){
        Scanner teclat = new Scanner(System.in);
        int nombre;
        
        System.out.println("Diga'm un nombre enter:");
        nombre = teclat.nextInt();
        if (nombre > 9){
            System.out.println("No és un digit");
        }
        else {
            System.out.println("És un digit");
                    } 
    }
}
