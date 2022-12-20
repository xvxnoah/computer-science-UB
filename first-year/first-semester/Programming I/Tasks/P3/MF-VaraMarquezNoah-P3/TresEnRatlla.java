/**
 *
 * @author Noah Márquez
 */

import java.util.*;
public class TresEnRatlla {
    public static void main(String [] args){
        Scanner sc = new Scanner(System.in);
        String[][] tauler = new String[3][3];
        int comptador = 0;
        int quiTira = 0;
        System.out.println("Benvingut al Tres en Ratlla!!");
        initTauler(tauler);
        boolean endGame = false;
        
        if(quiComenca() == 1){
            System.out.println("Comença l'ordinador.");
            mostraTauler(tauler);
            quiTira = 1;
        }
        else{
            System.out.println("Comences tu.");
            mostraTauler(tauler);
            quiTira = 0;
        }
             
        //Iteració fins que algú guanyi o empatin.
        while(jocAcabat(tauler) == false && !endGame){
            tirada(tauler, quiTira);
            
            /*
            Identificació de la sequencia: [0, tauler.length)
            Primer: i = 0
            Seguent: i++
            FiSeq(): i >= tauler.length
            Identificacio de l'esquema: cerca, en cada cel·la que hi hagi una 
            peça d'un jugador, suma 1 al comptador.
            */
            for(int i = 0; i < tauler.length; i++){
                for(int j = 0; j < tauler.length; j++){
                    if(tauler[i][j] == "X" || tauler[i][j] == "O"){
                        comptador++;
                    }
                }
            }
            //Si no ha guanyat ningú i totes les posicions estàn ocupades (empat)
            if(comptador == 9){
                System.out.println("EMPAT!");
                endGame = true;
            }
            if(quiTira == 1){
                quiTira = 0;
            }
            else{
                quiTira = 1;
            }
            //Reiniciem el comptador.
            comptador = 0;
        }
    }
    
    //Mètode per a decidir qui comença a jugar.
    static int quiComenca(){
        return (int) (Math.random() * 2 + 1);
    }
    
    //Mètode per a iniciar el tauler.
    static void initTauler(String[][] tauler){
        /*
        Identificació de la sequencia: [0, tauler.length)
        Primer: i = 0
        Seguent: i++
        FiSeq(): i >= tauler.length
        Identificacio de l'esquema: recorregut
        */
        for(int i = 0; i < tauler.length; i++){
            for(int j = 0; j < tauler.length; j++){
                tauler[i][j] = "/"; //Per indicar que no hi ha cap fitxa.
            }
        }
    }
    
    //Mètode per anar mostrant el tauler a mesura que avança el joc.
    static void mostraTauler(String[][] tauler){
        /*
        Identificació de la sequencia: [0, tauler.length)
        Primer: i = 0
        Seguent: i++
        FiSeq(): i >= tauler.length
        Identificacio de l'esquema: recorregut
        */
        for(int i = 0; i < tauler.length; i++){
            System.out.println("");
            for(int j = 0; j < tauler.length; j++){
                System.out.print(tauler[i][j]);
            }
        }
        System.out.println("");
    }
    
    //Mètode que actualitza el tauler depenent la tirada de cada jugador.
    static void tirada(String[][] tauler, int quiTira){
        Scanner sc = new Scanner(System.in);
        int posX, posY;
        
        //En cas de que toqui tirar a l'ordinador.
        if(quiTira == 1){
            //Generem aleatoriament la posició on situara la fitxa.
            posX = (int) (Math.random() * 3 + 1);
            posY = (int) (Math.random() * 3 + 1);
            
            //Comprovem que l'ordinador no intenti situar una fitxa en una posició
            //que ja està ocupada. (La fitxa de l'ordinador serà: 'O')
            while(tauler[posY-1][posX-1].equals("X") || tauler[posY-1][posX-1].equals("O")){
                posX = (int) (Math.random() * 3 + 1);
                posY = (int) (Math.random() * 3 + 1);
            }
            tauler[posY-1][posX-1] = "O";
            System.out.println("El tauler es troba així:");
            mostraTauler(tauler);
        }
        //Si toca al jugador. (La fitxa del jugador serà: 'X')
        else{
            System.out.println("On vols situar la teva fitxa?");
            posY = sc.nextInt();
            posX = sc.nextInt();
            
            //Comprovem que el jugador no intenti situar una fitxa a un lloc ocupat.
            while(tauler[posY-1][posX-1].equals("X") || tauler[posY-1][posX-1].equals("O")){
                    System.out.println("Posició ocupada. Escull un altre.");
                    posY = sc.nextInt();
                    posX = sc.nextInt();
            }
            tauler[posY-1][posX-1] = "X";
            System.out.println("El tauler es troba així:");
            mostraTauler(tauler);
        }
    }
    
    //Mètode per a comprovar si el joc s'ha acabat, comprovant files, columnes i diagonals.
    static boolean jocAcabat(String[][] tauler){
        /*
        Identificació de la sequencia: [0, tauler.length)
        Primer: i = 0
        Seguent: i++
        FiSeq(): i >= tauler.length || return true
        Identificacio de l'esquema: cerca, trobar si algun dels dos jugadors ha
        guanyat (les seves peces formen una fila, columna o diagonal).
        */
        for(int i = 0; i < tauler.length ; i++){
            /*
            Identificació de la sequencia: [0, tauler.length)
            Primer: j = 0
            Seguent: j++
            FiSeq(): j >= tauler.length || return true
            Identificacio de l'esquema: cerca, trobar si algun dels dos jugadors ha
            guanyat (les seves peces formen una fila, columna o diagonal).
            */
            for(int j = 0; j < tauler.length ; j++){
                //Si estan en diagonal:
                if(i == 1 && j == 1){
                    if(tauler[i][j].equals("X") && tauler[i+1][j+1].equals("X") && tauler[i-1][j-1].equals("X")){
                        System.out.println("HAS GUANYAT!!");
                        return true;
                    }
                    if(tauler[i][j].equals("O") && tauler[i+1][j+1].equals("O") && tauler[i-1][j-1].equals("O")){
                        System.out.println("Ha guanyat l'ordinador");
                        return true;
                    }
                }
                //Si estan en fila.
                if(j == 1){
                    if(tauler[i][j].equals("X") && tauler[i][j+1].equals("X") && tauler[i][j-1].equals("X")){
                        System.out.println("HAS GUANYAT!!");
                        return true;
                    }
                    if(tauler[i][j].equals("O") && tauler[i][j+1].equals("O") && tauler[i][j-1].equals("O")){
                        System.out.println("Ha guanyat l'ordinador");
                        return true;
                    }
                }
                //Si estan en columna:
                if(i == 1){
                    if(tauler[i][j].equals("X") && tauler[i+1][j].equals("X") && tauler[i-1][j].equals("X")){
                        System.out.println("HAS GUANYAT!!");
                        return true;
                    }
                    if(tauler[i][j].equals("O") && tauler[i+1][j].equals("O") && tauler[i-1][j].equals("O")){
                        System.out.println("Ha guanyat l'ordinador");
                        return true;
                    }
                }
            }   
        }   
        return false;  
    }
}