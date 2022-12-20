/*Feu un programa que llegeixi un String i compti el nombre de vocals que hi ha en total.
Per exemple, "Avui fa molta calor" dona el missatge "La frase té 8 vocals".
Utilitza el mètode CharAt() per a resoldre'l.
*/
import java.util.*;
public class ComptaVocals2 {
    public static void main(String []args){
        Scanner teclat = new Scanner(System.in);
        String text;
        int contador = 0;
        
        System.out.println("Introdueix una cadena de text: ");
        text = teclat.nextLine();
        text = text.toLowerCase();
        
        for (int i = 0; i < text.length(); i++){
            if ((text.charAt(i)=='a')||(text.charAt(i)=='e')||(text.charAt(i)=='i')||
                    (text.charAt(i)=='o')|| (text.charAt(i)=='u')){
            contador++;
        }
       }
        System.out.println("Hi ha " + contador + " vocals.");
    }
}
