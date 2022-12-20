/*

  author:   Noah Marquez
  date:     ...................
  version:  ...................

 */

 /*
Feu un programa que donada l’edat d’una persona el 31 de desembre de 2020. 
calcula el seu any de naixement i en quin any tindrà el doble de l’edat que 
té el 31 desembre de 2020. L'edat s'ha de donar com un enter major o igual a 1.
 */

 /* Taula de test
--------------------------------
entrada   | sortida
15        | Vas neixer l'any 2005, a l'any 2035 tindras 30 anys.  
48        | Vas neixer l'any 1972, a l'any 2068 tindras 96 anys.    //Defineix més casos de test
 */
import java.util.*;

public class Edat {

    public static void main(String[] args) {
        Scanner teclado = new Scanner(System.in);
        int edat;

        System.out.println("Dona'm la teva edat:");
        edat = teclado.nextInt();

        System.out.println("Vas neixer l'any " + (2020 - edat) + ", a l'any "
                + (2020 + edat) + " tindras " + (edat * 2) + " anys");

    }
}
