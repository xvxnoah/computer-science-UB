/*author:   Noah
data:     07/10/2020
version:  1.0
*/

/*
Feu un programa que donats dos punts del pla amb les seves coordenades
calcula la distància  euclidiana  entre  ells.  Per  més  informació,  podeu
consultar  a: https://ca.wikipedia.org/wiki/Distància_euclidiana

    ENTRADA // SORTIDA
-------------------------
(2, 5), (7,9) -> La distancia euclidiana entre el punt: (2, 5) y el punt: (7, 9) es: 6.4031242374328485
(0, 0), (10, 5) -> La distancia euclidiana entre el punt: (0, 0) y el punt: (10, 5) es: 11.180339887498949
*/
import java.util.*;
public class Distancia {
    public static void main (String[]args){
        Scanner teclat = new Scanner(System.in);
        int x, y, x2, y2 = 0;
        
        System.out.println("Dona'm les"
                + " dues coordenades del primer punt del pla:");
        x = teclat.nextInt();
        y = teclat.nextInt();
        
        System.out.println("Ara dona'm les altres dues coordenades del "
                + "segon punt del pla:");
        x2 = teclat.nextInt();
        y2 = teclat.nextInt();
        
        double dist = Math.sqrt(Math.pow((x2-x), 2) + Math.pow((y2-y), 2));
        
        System.out.println("La distancia euclidiana "
                + "entre el punt: ("+ x + ", "+ y + ") y el punt: ("+ x2 + ", "
                + y2 + ") es: " + dist );
    }
}
