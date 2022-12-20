/*
Donades dues paraules, dir si són iguals o no sense utiltzar el metode equals de
la classe String.

1. Identificació de la seqüència: Seqüència de caracters de la paraula
    -->Primer(): i=0;,
    -->Seg(): i++;,
    -->FinalSeq(clau): i==primera.length()

2. Identificació de l’esquema: Quan es troba una lletra diferent s’atura el
while: Esquema de Cerca: condició de cerca:  ́
    -->(sonDiferents == true), on
    -->(sonDiferents =!(primera.charAt(i) == segona.charAt(i)))
 */
import java.util.*;
public class ParaulesIguals2 {
    public static void main ( String [] args ) {
        Scanner scan = new Scanner(System.in);
        String primera = "";
        String segona = "";
        boolean sonDiferents = false;
        int i;
        int j;
        
        System.out.println("Introdueix la primera paraula:");
        primera = scan.next();
        System.out.println("Introdueix la segona paraula:");
        segona = scan.next();

        if (primera.length() == segona.length()) {
            i = 0;
            while (i < primera.length() && !sonDiferents) {
                if (primera.charAt(i) == segona.charAt(i)) {
                    i ++;
                }
                else {
                    sonDiferents = true;
                }
            }
        }
        else {
            sonDiferents = true;
        }
        if (sonDiferents) {
            System.out.println("Son diferents");
        }
        else {
            System.out.println("Son iguals");
    }
    }
}
