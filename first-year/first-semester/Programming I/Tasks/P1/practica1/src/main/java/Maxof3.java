/*author:   Noah
data:     08/10/2020
version:  1.0
*/

/*
Feu un programa que calcula el màxim de tres nombres reals, usant com a molt
dues instruccions if.

*/
import java.util.*;
public class Maxof3 {
    public static void main (String[]  args){
        Scanner sc = new Scanner(System.in);
        int x, y, z, max1, maxt;
        
        System.out.println("Introdueix tres nombres: ");
        x = sc.nextInt();
        y = sc.nextInt();
        z = sc.nextInt();
        max1 = Math.max(x, y);
        maxt = Math.max(max1, z);
        
        System.out.println("El màxim dels tres nombres introduïts és: "+ maxt);
    }
            
}
