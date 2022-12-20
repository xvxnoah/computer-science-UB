/*author:   Noah
data:     07/10/2020
version:  1.0
*/

/*Feu un programa que donat un nombre enter
escriu la seva última xifra.*/
/* Taula de tests
Entrada            | Sortida esperada
-------------------------------------
123                |   3
4                  |   4
78956              |   6
enter fora de rang |   error d'execucio: java mostra una excepció
2147483648*/
import java.util.*;
public class UltimDigit{
    public static void main(String [] args){
        Scanner teclado = new Scanner(System.in);
        int num, ultimd;
        
        System.out.println("Dona'm un enter:");
        num = teclado.nextInt();
        ultimd = num % 10;
        System.out.println("L'últim dígit de "+ num + " es " + ultimd);
    }
}