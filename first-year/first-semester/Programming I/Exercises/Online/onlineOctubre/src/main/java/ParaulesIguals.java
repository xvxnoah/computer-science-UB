/*
Donada una frase acabada amb la paraula “fi”, escriu “fi” si totes les paraules
son iguals, sino escriu la primera paraula diferent.

1. Identificació de la seqüència: Seqüència de paraules entrada per teclat:
    -->Primer(): anterior = ""; paraula = sc.next();,
    -->Seg(): anterior = paraula; paraula = sc.next();,
    -->FinalSeq(clau): paraula.equals("fi")

2. Identificació de l’esquema: Quan s’entra una paraula diferent s’atura el
while: esquema de cerca: condicio de cerca :  ́
    -->(sonDiferents == true), on
    -->(sonDiferents =!paraula.equals(anterior))

 */
import java.util.*;
public class ParaulesIguals {
    public static void main (String [] args) {
        Scanner scan;
        String anterior = "", paraula = "";
        boolean sonDiferents = false;
        scan = new Scanner (System.in);
        
        System.out.println ("Introdueix la frase:");
        // Primera parella
        paraula = scan.next();
        if (paraula.equals("fi")) {
            System.out.println("Frase buida");
        }
        else{
            anterior = paraula;
            paraula = scan.next();
            while (!paraula.equals("fi") && !sonDiferents ) {
                if (paraula.equals(anterior)) {
                    // seguent element
                    anterior = paraula;
                    paraula = scan.next();
                }
                else {
                    sonDiferents = true;
                }
            }
            if (sonDiferents) {
                System.out.println(paraula);
            }
            else {
                System.out.println("fi");
            }
        }
    }
}

