/*author:   Noah
data:     08/10/2020
version:  1.0
*/

/*
Feu un programa que donats dos rectangles (amb costats paral·lels als eixos) 
definits com al problema anterior, calcula el rectangle mínim que els conté. 
Si els rectangles no intersequen, s’hauria de mostrar un missatge 
“No intersequen, no hi ha rectangle mínim”.

Per exemple,si l’usuari introdueix
el primer rectangle amb les coordenades (1.0,3.0) (3.0,5.0)i el segon amb les 
coordenades  (2.0,1.0) (4.0,4.0), la sortida del programa ha de ser
(2.0, 3.0) (3.0 , 4.0).Si l’usuari introdueix el primer rectangle amb les
coordenades (1.0,1.0) (1.0,2.0)iel segon amb les coordenades 
(4.0,4.0) (6.0,6.0), la sortida del programa ha de ser
“No intersequen, no hi ha rectangle mínim”.

*/

import java.util.*;
public class MinRectangle {
    public static void main (String[] args){
        Scanner sc = new Scanner(System.in);
        double x1, x2, y1, y2;
        double x, y, p, t;
        double r, v, j, k;
        
        System.out.println("Dona les coordenades del primer rectangle: ");
        x1 = sc.nextDouble();
        y1 = sc.nextDouble();
        x2 = sc.nextDouble();
        y2 = sc.nextDouble();
        
        System.out.println("Dona les coordenades del segon rectangle: ");
        x = sc.nextDouble();
        y = sc.nextDouble();
        p = sc.nextDouble();
        t = sc.nextDouble();
        
        r = Math.max(x1, x);
        v = Math.max(y1, y);
        
        j = Math.min(x2, p);
        k = Math.min(y2, t);
        
        if (r > j || v > k){
            System.out.println("No intersequen, no hi ha rectangle mínim.");
        
        }
        else {    
            System.out.println("(" + r + ", " + v + ") ("+ j + ", " + k + ")");
        }
       
}
}
