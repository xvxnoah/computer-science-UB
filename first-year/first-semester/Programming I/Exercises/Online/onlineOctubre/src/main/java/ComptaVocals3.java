/*Feu un programa que llegeixi un String i compti el nombre de vocals que hi ha en total.
Per exemple, "Avui fa molta calor" dona el missatge "La frase té 8 vocals".
Utilitza el mètode CharAt() per a resoldre'l.
*/
import java.util.*;
public class ComptaVocals3 {
    public static void main(String []args){
        Scanner teclat = new Scanner(System.in);
        String paraula;
        char car;
        int contador = 0, i = 0;
        
        System.out.println("Dona'm la frase: ");
        paraula = teclat.nextLine();
        
        while (i < paraula.length()){
            car = paraula.charAt(i);
            
            if ((car=='a')||(car=='e')||(car=='i')||(car=='o')||(car=='u')||(car=='A')
                    ||(car=='E')||(car=='I')||(car=='O')||(car=='U')){
            contador++;
        }
        i++;    
       }
        System.out.println("Hi ha " + contador + " vocals.");
    }
}
