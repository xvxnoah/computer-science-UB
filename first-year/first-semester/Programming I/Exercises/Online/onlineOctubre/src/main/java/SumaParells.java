/*
1.Donat un nombre va sumant tots els parells fins que arriba a aquest nombre.

2.Seqüències: assignacions, seqüència iterativa (while), seqüència alternativa (if).

3. ENTRADA // SORTIDA
    2         Sum of first 2 natural numbers is 2
    10        Sum of first 10 natural numbers is 30
    4         Sum of first 4 natural numbers is 6
    1         Sum of first 1 natural numbers is 0
    -1        Sum of first -1 natural numbers is 0
 */
import java.util.*;
public class SumaParells {
    public static void main(String[]args){
        Scanner teclat = new Scanner(System.in);
        int num = 0, count = 1, total = 0;
        
        System.out.println("Quants números vols sumar ");
        num = teclat.nextInt();
        
        while (count <= num){
            if (count%2 == 0){
                total = total + count;
            }
            count++;
        }
        System.out.println("Sum of first " + num + " natural numbers is: " + total);
    }
        
}
