/*Un nombre primer (número primo en castellà) només es divisible per ell mateix i per la unitat. 
Anomenarem «primers emparellats» a aquelles parelles de nombres primers que difereixen en 2. 
És a dir, amb el nombres primers p i q (amb p < q) són «primers emparellats» si q = p + 2. 
Escriu un programa que mostri tots els «primers emparellats» menors a un nombre enter positiu, n. 
També s’ha de mostrar el nombre total de parelles i el  nombre primer major de totes les parelles.
*/
//Taula de test
//  entrada      sortida
//  5       no surt res a pantalla
//  20     (3,5)(5,7)(11,13)(17,19) Hi ha 4 parelles. El nombre primer major és 19.
//  50     (3,5) (5,7) (11,13) (17,19) (29,31) (41,43). Hi ha 6 parelles. El nombre primer major és 43.
//  ...

import java.util.*;
public class PrimersBessons {
    public static void main(String[] args) {
    boolean esPrimo = false;
    int ultimPrimer = 1;
    int n = 5;
    Scanner teclado = new Scanner(System.in);
    int numParelles = 0;
    int max = 0;
    
    System.out.println("Introdueix n: ");
    n = teclado.nextInt();
    
    for (int i = 2; i < n; i++) {
        esPrimo = true;
        for (int j = 2; (j <= i/2) && esPrimo; j++){   // n/2 perquè no fa falta anar fins al final i && esPrimo per parar si ja l'hem trobat.
            if (i % j == 0){
                 esPrimo = false;
            }
        } 
       
        if (esPrimo){
            if  (i - ultimPrimer == 2){
                System.out.println("(" + ultimPrimer + "," + i + ")");
                numParelles++;
                max = i;
            }   
            ultimPrimer = i;
        }
        
    }
  
    if(numParelles >= 1){
      System.out.println(" Hi ha "+ numParelles + " parelles.");
      System.out.println(" El nombre primer major es: "+ max);
    }
    
  }

}
