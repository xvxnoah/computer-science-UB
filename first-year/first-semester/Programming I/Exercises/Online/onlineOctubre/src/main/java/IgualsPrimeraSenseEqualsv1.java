/*
Donada una frase acabada amb la primera paraula que comença amb “f”, escriu “si”,
si hi ha alguna paraula igual a la primera, sense usar el metode equals de la
classe String.

1. Identificació de la seqüència: Seqüència de paraules entrades per teclat
    -->Primer(): paraula = sc.next();,
    -->Seg(): paraula = sc.next();,
    -->FinalSeq(clau): paraula.charAt(0)==’f’

2. Identificació de l’esquema: Quan es troba la primera paraula igual a la
primera s’atura el while: Esquema de Cerca: condició de cerca: (sonIguals)

3. Falta la caracterització de la seqüència interna (Feu-la vosaltres).
 */
import java.util.*;
public class IgualsPrimeraSenseEqualsv1 {
    public static void main ( String [] args ) {
        Scanner scan = new Scanner(System.in);
        String primera = "";
        String paraula = "";
        boolean sonIguals = false;
        int i;

        System.out.println("Introdueix la frase:");
        paraula = scan.next();
        if (paraula.charAt(0) == 'f'){
            System.out.println("Frase buida");
        }
        else{
            primera = paraula;
            paraula = scan.next();
            while (paraula.charAt(0) !='f' && !sonIguals) {
            // Comprovacio que es igual a la primera
                if (primera.length() == paraula.length()) {
                    boolean sonDiferents = false;
                    i = 0;
                    while (i < primera.length() && !sonDiferents) {
                        if (primera.charAt(i) == paraula.charAt(i)){
                            i ++;
                        }
                        else {
                            sonDiferents = true;
                        }
                    }
                    sonIguals = !sonDiferents;
                }
                else {
                    sonIguals = false;
                }
                // pas al seguent element en cas que sigui necessari
                if (!sonIguals) {
                    // seguent element
                    paraula = scan.next();
                }
            } // while
                if (sonIguals) {
                    System.out.println("Si hi ha una paraula igual a la primera");
                }
                else {
                    System.out.println("No hi ha una paraula igual a la primera");
            }
        }// primer else
    }
}