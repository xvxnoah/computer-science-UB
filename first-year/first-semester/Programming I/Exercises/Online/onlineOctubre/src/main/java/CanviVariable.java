/*
Canviar el valor d'una variable x, pel d'una variable y, sense fer ús d'una
variable temporal.
 */

import java.util.*;
public class CanviVariable {
    public static void main(String[] args){
        int x = 4, y = 3;
        
        x = x + y;
        y = x - y;
        x = x - y;
        
        System.out.println("x = "  + x + ", y = " + y);
    }
         
    
}
