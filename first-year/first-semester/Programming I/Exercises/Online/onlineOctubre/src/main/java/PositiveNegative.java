/*
 1.Entrat un enter per l'usuari, indica si aquest és positiu, negatiu, o cap
de les anteriors.

2.Fem ús de condicionals (if, else if, else)per indicar el criteri de selecció
que ha de seguir el programa a l'hora de decidir si és un enter positiu, negatiu
o cap dels dos.

3. ENTRADA // SORTIDA
    2         2 is a positive number
    0         0 is neither positive nor negative
    -2        -2 is a negative number
 */
import java.util.*;
public class PositiveNegative {
    public static void main(String []args){
        Scanner sc =  new Scanner(System.in);
        
        System.out.println("Introdueix un enter: ");
        int number = sc.nextInt();
        
        if (number >0){
            System.out.println(number + " is a positive number");
    }
        else if (number < 0){
            System.out.println(number + " is a negative number");
        }
        else{
            System.out.println(number + " is neither positive nor negative");
        }
    }
}
