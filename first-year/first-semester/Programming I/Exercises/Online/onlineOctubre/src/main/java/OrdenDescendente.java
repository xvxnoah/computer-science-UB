/*
Ordenar tres nombres enters en ordre descendent (de major a menor) només amb tres 
ifs i utiilitzant una variable temporal per intercanviar (no hi ha if else if ... 
ni ifs anidats.
 */

import java.util.*;
public class OrdenDescendente {
    public static void main(String[]args){
        int extra, x, y, z;
        Scanner sc = new Scanner(System.in);
        
        System.out.println("Donam els tres enters: ");
        x = sc.nextInt();
        y = sc.nextInt();
        z = sc.nextInt();
        
        if ( x <= y){   // z = 3, y = 4, x = 2
            extra = x;
            x = y;
            y = extra;
        }
        if ( x <= z){
            extra = x;
            x = z;
            z = extra;
        }
        if (y <= z){
            extra = y;
            y = z;
            z = extra;
        }
        System.out.println("El orden de mayor a menor es: " + x + " " + y + " " + z);
    }
}
