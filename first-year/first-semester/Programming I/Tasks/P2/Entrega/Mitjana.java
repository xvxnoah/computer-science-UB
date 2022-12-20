/*
Feu un programa que demani un enter n, seguidament llegeixi n enters i finalment
retorni la mitjana dels nombres parells. (Mitjana.java)
 */

/**
 *
 * @author Noah Márquez
 */
import java.util.*;
public class Mitjana {
    public static void main(String [] args){
        Scanner sc = new Scanner(System.in);
        int enter;
        float mitjana;
        
        System.out.println("Introdueix un enter n:");
        enter = sc.nextInt();
        
        mitjana = calculMitjana(enter);
        System.out.println("La mitjana és " + mitjana);
    }

    static float calculMitjana(int a){
        Scanner sc = new Scanner(System.in);
        int comptador = 0;
        int suma = 0;
        int seguentEnter;
        float mitjana;
        
        System.out.println("Introdueix " + a + " enters:");
        
        for(int i = 0; i < a; i++){
            seguentEnter = sc.nextInt();
            
            if(seguentEnter == 0){
                comptador -= 1;
            }
            if(seguentEnter % 2 == 0){
                comptador++;
                suma += seguentEnter;
            }  
        }
        if(comptador == 0){
            mitjana = 0;
            return mitjana;
        }else{
           mitjana = suma/comptador;
           return mitjana; 
        }
        
    }

}
