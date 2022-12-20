/*Feu un programa que llegeixi un String i compti el nombre de vocals que hi ha en total.
Per exemple, "Avui fa molta calor" dona el missatge "La frase té 8 vocals".
Utilitza el mètode CharAt() per a resoldre'l.
*/
import java.util.*;
public class ComptaVocals1 {
    public static void main(String []args){
        Scanner teclat = new Scanner(System.in);
        String paraula;
        char car;
        int contador = 0;
        
        System.out.println("Dona'm la frase: ");
        paraula = teclat.nextLine();
        
        paraula = paraula.toLowerCase();
        
        for (int i = 0; i < paraula.length(); i++){
            car = paraula.charAt(i);
            switch(car){
            case 'a': contador++; break;
            case 'e': contador++; break;
            case 'i': contador++; break;
            case 'o': contador++; break;
            case 'u': contador++; break;   
        }
       }
        System.out.println("Hi ha " + contador + " vocals.");
    }
}
