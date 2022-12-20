/*author:   Noah
data:     11/10/2020
version:  1.0
*/

/*
Feu un programa que concateni dues cadenes entrades per teclat. S’ha de fer ús
del mètode append() de la classe StringBuffer. Perquè creus que no
utilitzem la classe String?

*/

import java.util.*;
public class Concat {
    public static void main (String [] args){
        Scanner sc = new Scanner(System.in);
        StringBuffer s1 = new StringBuffer() , s2 = new StringBuffer();
        
        System.out.println("Cadena 1:");
        s1.append(sc.nextLine());
        System.out.println("Cadena 2:");
        s2.append(sc.nextLine());
       
        System.out.println("La cadena concatenada es: " + s1.append(s2));
        
    }
}
