/**
 *
 * @author Noah Márquez
 */

import java.util.*;
public class JocDelPenjat {
    public static void main(String [] args){
        Scanner sc = new Scanner(System.in);
        final int NUM_PARAULES = 10;
        int llargada, intents = 0;
        String [] llistaParaules = new String[NUM_PARAULES];
        String paraulaEndevinar;
        initLlistaDeParaules(llistaParaules);
        paraulaEndevinar = novaPartida(llistaParaules);
        llargada = paraulaEndevinar.length();
        boolean [] lletresEncertades = new boolean[llargada];
        initLletrasEncertades(lletresEncertades, paraulaEndevinar);
        boolean encertat = false;
        
        //Inici del joc.
        System.out.println("Benvingut al Joc del Penjat!");
        System.out.println("Tindràs com a màxim 6 intents per encertar la paraula.");
        System.out.println("La paraula a endevinar té la següent forma:");
        
        //Imprimir l'estat de la paraula inicial.
        System.out.println(mostraParaula(paraulaEndevinar, lletresEncertades));
        
        //Mentre el comptador no superi el nombre màxim d'errors, continuem al loop.
        while (intents < 6){
            System.out.println("Introdueix una lletra majúscula");
            char c = sc.next().charAt(0);
            
            //Comprovem si la lletra introduida es troba a la paraula a endevinar.
            //loop per a cada posicio:
            /*
            Identificació de la sequencia: [0, llargada)
            Primer: i = 0
            Seguent: i++
            FiSeq(): i >= llargada
            Identificacio de l'esquema: cerca, trobar si la lletra es troba a la
            paraula.
            */
            for(int i = 0; i < llargada; i++){
                if(lletraEncertada(paraulaEndevinar, i, c, lletresEncertades)){
                    encertat = true;
                }
            }
            //Si la lletra introduida no es troba a la paraula, sumem 1 al comptador d'intents.
            if (encertat == false){
                System.out.println("La lletra no es troba a la paraula");
                encertat = false;
                intents++;
            }
            //Imprimir l'estat de la paraula.
            System.out.println("Estat actual de la paraula:");
            System.out.println(mostraParaula(paraulaEndevinar, lletresEncertades));
            
            if(jocAcabat(lletresEncertades) == true){
                System.out.println("HAS GUANYAT!!");
                System.exit(0);
            }
            System.out.println("Et queden " + (6-intents) + " intents.");
            encertat = false;
            
        }
        System.out.println("T'HAS PENJAT!!");
    }
    
    //Aquest mètode inicialitza el vector de paraules del joc. La mida del vector
    //llistaParaules és una constant (NUM_PARAULES=10) i les paraules són decisió vostra.
    static void initLlistaDeParaules(String [] llistaParaules){
        llistaParaules[0] = "POMA";
        llistaParaules[1] = "ORDINADOR";
        llistaParaules[2] = "MAPA";
        llistaParaules[3] = "LLIBRE";
        llistaParaules[4] = "FINESTRA";
        llistaParaules[5] = "ESTRELLA";
        llistaParaules[6] = "PISSARRA";
        llistaParaules[7] = "BARRI";
        llistaParaules[8] = "COCHE";
        llistaParaules[9] = "MUNTANYA";
    }
    
    //Aquest mètode selecciona des de llistaParaules la paraula a esbrinar en una
    //partida. La selección es fa de forma aleatòria. El mètode retorna la paraula a esbrinar.
    static String novaPartida(String [] llistaParaules){
        Random word = new Random();
        return llistaParaules[word.nextInt(llistaParaules.length)];
    }
    
    //Aquest mètode inicialitza el vector lletresEncertades posant el valor de
    //cada posició a false. El tamany del vector depèn de la paraula a esbrinar,
    //que és un altre paràmetre del mètode, paraulaEsbrinar.
    static void initLletrasEncertades(boolean [] lletresEncertades, String paraulaEsbrinar){
        /*
        Identificació de la sequencia: [0, paraulaEsbrinar.length)
        Primer: i = 0
        Seguent: i++
        FiSeq(): i >= paraulaEsbrinar.length
        Identificacio de l'esquema: recorregut.
        */
        for (int i = 0; i < paraulaEsbrinar.length(); i++){
            lletresEncertades[i] = false;
        }
        
    }
    
    //Aquest mètode retorna true si la lletra c a la posició pos es correspon a
    //la lletra de la mateixa posició a la paraula a esbrinar, paraulaEsbrinar.
    //Aquest mètode també actualitza el vector lletresEncertades, assignant el
    //valor de true a la posició que toqui, si ho ha encertat el jugador.
    static boolean lletraEncertada (String paraulaEsbrinar, int pos, char c, boolean [] lletresEncertades){
        if (c == paraulaEsbrinar.charAt(pos)){
            lletresEncertades[pos] = true;
            return true;
        }
        return false;
    }
    
    //Aquest mètode construeix la paraula durant el joc per a donar-li feedback a
    //l’usuari. Aquesta paraula tindrà les lletres esbrinades i el símbol “?” per 
    //les posicions que no s’han esbrinat encara. Ho podeu fer amb un StringBuffer.
    static public String mostraParaula(String  paraulaEsbrinar, boolean  [] lletresEncertades){
        StringBuffer paraula = new StringBuffer();
        
        /*
        Identificació de la sequencia: [0, lletresEncertades.length)
        Primer: i = 0
        Seguent: i++
        FiSeq(): i >= lletresEncertades.length
        Identificacio de l'esquema: recorregut
        */
        for(int i = 0; i < lletresEncertades.length; i++){
            if(lletresEncertades[i] == true){
                paraula.append(paraulaEsbrinar.charAt(i));
            }
            else{
                paraula.append("?");
            }
        }
        return paraula.toString();
    }
    
    //Aquest mètode retorna cert si el joc s’ha acabat.
    static public boolean jocAcabat(boolean [] lletresEncertades){
        /*
        Identificació de la sequencia: [0, lletresEncertades.length)
        Primer: i = 0
        Seguent: i++
        FiSeq(): i >= lletresEncertades.length || lletresEncertades[i] == false
        Identificacio de l'esquema: cerca, trobar si hi ha encara alguna lletra
        per esbrinar.
        */
        for (int i = 0; i < lletresEncertades.length; i++){
            if(lletresEncertades[i] == false){
                return false;
            }
        }
        return true;
    }
}
