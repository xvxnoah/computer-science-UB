import java.util.*;

/*
  author:  Noah Marquez
  date:    .................
  version: .................
*/

/*
Feu un programa que llegeix dos nombres enters i escriu el resultat de realitzar 
la divisió entera del primer entre el segon. 
Per exemple, si llegeix 41 i 2, escriu “41 = 20 * 2 + 1”.
RECORDA QUE EL MISSATGE PER PANTALLA HA DE TENIR EL MATEIX FORMAT QUE S'INDICA A
L'EXEMPLE
*/


public class Division{

/* Tabla de test

entrada           | sortida
-----------------------------------
38 7              | 38 = 5 * 7 + 3  
41 2              | 41 = 20 * 2 + 1
999 5             | 999 = 199 * 5 + 4 //Defineix més casos de test
77777 9           | 77777 = 8641 * 9 + 8

*/

  public static void main(String [] args){
    Scanner teclado = new Scanner(System.in);
    int x, y, divisio, op;
    
    System.out.println("Dona'm dos enters:");
    x = teclado.nextInt();
    y = teclado.nextInt();
    divisio = x / y;
    op = x % y;
    
    System.out.println(x + " = " + divisio + " * "+ y + " + " + op);
    //TODO
    
  }
}
