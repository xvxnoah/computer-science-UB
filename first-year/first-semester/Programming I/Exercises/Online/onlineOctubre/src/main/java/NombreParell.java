/*
 Feu un programa que indiqui si el número enter entrat per l'usuari és parell.
 */
import java.util.*;
public class NombreParell {
    public static void main(String[]args){
        Scanner sc = new Scanner (System.in);
        int num = 0;
        
        System.out.println("Introdueix un número enter: ");
        num = sc.nextInt();
        
        if (num%2 == 0){
            System.out.println("El nombre " + num + " és parell.");
        }
        else{
            System.out.println("El nombre " + num + " NO és parell.");
        }
    }
}
