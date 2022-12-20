/*
Ordenar tres nombres enters en ordre ascendent (de menor a major) amb un if else.
Tant el if com el else poden tenir if else if else anidats (és a dir, poden tenir
dintre altres if else if...).
 */

import java.util.*;
public class OrdenAscendente {
    public static void main(String[] args){
        int x, y , z;
        Scanner sc = new Scanner(System.in);
    
        System.out.println("Introdueix els tres nombres enters: ");
        x = sc.nextInt();
        y = sc.nextInt();
        z = sc.nextInt();
        
        if ((x <= y) || (x > z)){   // x = 2, y = 4, z = 3.
            if ((x > z) && (z < y)){
                System.out.println("L'ordre de menor a major és: " + z + " " + y + " " + x);
            }
            else if ((x > z) && (z > y)){
                System.out.println("L'ordre de menor a major és: " + y + " " + z + " " + x);
            }
            else if (y <= z){
                System.out.println("L'ordre de menor a major és: " + x + " " + y + " " + z);
            }
            else if (y > z){
                System.out.println("L'ordre de menor a major és: " + x + " " + z + " " + y);
            }
        }
        
    }
    
}
