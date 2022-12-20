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

*/
import java.util.*;
public class Intervals2 {
  public static void main (String []args){
        Scanner sc = new Scanner(System.in);
        float x1, x2, y1, y2;
        boolean intersecten;
        
        System.out.println("Introudeix el primer inverval: ");
        x1 = sc.nextFloat();
        x2 = sc.nextFloat();
        
        System.out.println("Introdueix el segon interval: ");
        y1 = sc.nextFloat();
        y2 = sc.nextFloat();
        //Es calcula negant les condicions de no intersecció.
        
        intersecten = ! ((y2 < x1) || (x2 < y1));
        
        if (intersecten){
            System.out.println("[" + x1 + "," + x2 + "] i [" + y1 + "," + y2 + "] Intersecten");
           
        }
        else{
            System.out.println("[" + x1 + "," + x2 + "] i [" + y1 + "," + y2 + "] NO intersecten");
        }
    }
}
