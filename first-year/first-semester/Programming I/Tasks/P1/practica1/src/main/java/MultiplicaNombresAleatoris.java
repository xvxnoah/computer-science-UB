/*author:   Noah
data:     11/10/2020
version:  1.0
*/

/*
Feu un programa que generi de forma aleatòria dos nombres d’una xifra,
pregunti a l’usuari el resultat de la multiplicació d’aquests nombres,
i doni l’enhorabona “Ben fet!” si ho fa bé i si ho fa malament li animi a
estudiar més “Has d’estudiar la taula demultiplicar”.


*/

import java.util.*;
public class MultiplicaNombresAleatoris {
    public static void main (String []args){
        Scanner sc = new Scanner(System.in);
        int x = (int) (Math.random()*10);
        int y = (int) (Math.random()*10);
        
        System.out.println("Quin és el resultat de multiplicar " + x + " * "
                + y + "?");
        int r = sc.nextInt();
        
        if (r == x * y){
            System.out.println("Ben fet!");
        }
        else{
            System.out.println("Has d'estudiar la taula de multiplicar.");
        }
    }
}
