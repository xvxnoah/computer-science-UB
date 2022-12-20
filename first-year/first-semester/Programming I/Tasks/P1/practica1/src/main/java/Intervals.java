/*author:   Noah
data:     08/10/2020
version:  1.0
*/

/*
Feu  un  programa  que  donats  dos  intervals  [x1,  x2]  i  [y1,  y2]  
descrits  pels  quatre nombres reals x1, x2, i y1, y2, indica si aquests 
intervals s’intersequen o no.

Per exemple, si l’usuari introdueixels intervals [2.0, 4.4][5.0, 6.3]
ha de sortir el missatge “Els intervals no intersequen”.
Si l’usuari introdueix els intervals [2.0, 4.4]  [3.0, 6.3] ha de sortir el
missatge “Els intervals intersequen”.

ENTRADA // SORTIDA
-------------------------
[2.0, 4.4][5.0, 6.3]->Els intervals no intersequen
[2.0, 4.4] [3.0, 6.3]->Els intervals intersequen
*/

import java.util.*;
public class Intervals {
    public static void main (String []args){
        Scanner sc = new Scanner(System.in);
        double x1, x2, y1, y2;
        
        System.out.println("Introudeix el primer inverval: ");
        x1 = sc.nextDouble();
        x2 = sc.nextDouble();
        System.out.println("Introdueix el segon interval: ");
        y1 = sc.nextDouble();
        y2 = sc.nextDouble();
        
        if ((x1 <= y1 && y1 <= x2 ) || (y1 <= x1 && x1 <= y2)){
            System.out.println("Els intervals intersequen.");
           
        }
        else{
            System.out.println("Els intervals no intersequen.");
        }
    }
}
