/*author:   Noah
data:     08/10/2020
version:  1.0
*/

/*
Un rectangle que té els costats paral·lels als eixos està especificat per
les coordenades dels vèrtexs de baix a l’esquerra(x1,y1)i de dalt a la
dreta(x2,y2). Feu un programa que donades aquestes coordenades i les
coordenades d’un punt(x,y), indica si aquest punt es troba a dins o a
fora del rectangle.

Per exemple, si l’usuari introdueix les coordenades del rectangle(2.5, 2.5) i
(6.0, 6.0), i el punt (5.0,4.2), sortirà el missatge 
“El punt està dintre del rectangle”, 
i si introdueix el punt (5.1, 7.0) sortirà “El punt està fora”.

*/

import java.util.*;
public class EnRectangle {
    public static void main (String[] args){
        Scanner sc = new Scanner(System.in);
        double x1, x2, y1, y2, x, y;
        
        System.out.println("Dona les coordenades del rectangle: ");
        x1 = sc.nextDouble();
        y1 = sc.nextDouble();
        x2 = sc.nextDouble();
        y2 = sc.nextDouble();
                
        System.out.println("Dona les coordenades d'un punt: ");
        x = sc.nextDouble();
        y = sc.nextDouble();
        
        if ((x1 < x && x2 > x) && (y1 < y && y2 > y)){
            System.out.println("El punt està dintre del rectangle.");
        }
        else if ((x1 > x && x2 < x) && (y1 > y && y2 < y)){
            System.out.println("El punt està dintre del rectangle.");
        }
        else {
            System.out.println("El punt està fora del rectangle.");
        }
    }
    
}
