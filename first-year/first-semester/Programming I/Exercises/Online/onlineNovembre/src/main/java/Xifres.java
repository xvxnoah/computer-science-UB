/*
Feu un programa que donats dos nombres enters positius digui si tenen dues xifres
iguals en la mateixa posició. La sortida ha de ser les posicions en les quals es
repeteixen les xifres.

Per exemple, per 7423 i 7125 la sortida serà:
    -> A la posició 2 es repeteix la xifra 2.
    -> A la posició 0 es repeteix la xifra 7.
 */

import java.util.*;
public class Xifres {
    public static void main (String [] args){
        int a, b, i, j, posicio;
        String aSt, bSt;
        char xifra;
        boolean existeix = false;
        Scanner sc = new Scanner(System.in);
        
        System.out.println("Introdueix un enter positiu:");
        a = sc.nextInt();
        while (a < 0){
            System.out.println("Introdueix un enter positiu:");
            a = sc.nextInt();
        }
        
        System.out.println("Introdueix un altre enter positiu:");
        b = sc.nextInt();
        while (b < 0){
            System.out.println("Introdueix un altre enter positiu:");
            b = sc.nextInt();
        }
        
        aSt = Integer.toString(a);
        bSt = Integer.toString(b);
      
        for (i = 0; i < bSt.length(); i++){
            if(aSt.charAt(i) == bSt.charAt(i)){
                posicio = i;
                xifra = aSt.charAt(i);
                System.out.println("A la posició " + posicio + " es repeteix la xifra " + xifra);
                existeix = true;
            }
            else{
                existeix = false;
            }
        }
    }
}
