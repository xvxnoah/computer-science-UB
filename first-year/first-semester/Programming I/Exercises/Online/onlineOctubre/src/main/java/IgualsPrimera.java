/*
Donada una frase acabada amb la paraula “fi”, escriu “si” si hi ha alguna
paraula igual a la primera.

1. Identificació de la seqüència: Seqüèencia de paraules entrada per teclat:
    -->Primer(): primera = sc.next(); paraula = sc.next();,
    -->Seg(): paraula = sc.next();,
    -->FinalSeq(clau): paraula.equals("fi")

2. Identificació de l’esquema: Quan s’entra una paraula diferent s’atura el
while: esquema de cerca: condició de cerca:
    -->(sonIguals), on (sonIguals = paraula.equals(primera))
 */
import java.util.*;
public class IgualsPrimera {
    public static void main ( String [] args ) {
        Scanner scan = new Scanner(System.in);
        String primera = "";
        String paraula = "";
        boolean sonIguals = false;

        System.out.println("Introdueix la frase:");
        paraula = scan.next();

        if (! paraula . equals("fi")) {
            primera = paraula;
            paraula = scan.next();
        }
        
        while (!paraula.equals ("fi") && !sonIguals) {
            if (paraula.equals(primera)) {
                sonIguals = true;
            }
            else {
                // seguent element
                paraula = scan.next();
            }
        }
        if (sonIguals) {
            System.out.println ("si");
        }
        else {
            System.out.println("no");
        }
    }
}

