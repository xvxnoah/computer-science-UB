/**
 *
 * @author Noah Márquez
 */

/*
Exemple de com s'han d'entrar les dades: (els 1's o els 0's es poden introduir
tant tots seguits en un sol input d'una fila, o d'un en un, sempre tenint en
compte que la primera posició és la (0,0) i que el recorregut es fa per files)
    D'un en un (els poso així per no ocupar més espai):
    2
    2 3
    6
    0 1 1 0 0 0
    0 0 0 0 0 0
    0 0 0 1 0 0
    0 0 0 1 0 0
    0 0 0 1 0 0
    0 0 0 0 0 0

    Mètode més còmode:
    2
    2 3
    5
    0 1 1 1 0 0 0 0 0 1 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0

    0

*/
import java.util.*;
public class FlotaCorrecteBatallaNaval {
    private static Scanner sc;
    
    public static void main(String [] args){
        sc = new Scanner(System.in);
        int vaixells, midaTauler;
        int[] midaVaixells;
        int[][] tauler;
        boolean bonInput = true;
        
        initJoc();
        vaixells = comprovarVaixells();
        //El joc continua fins que l’usuari indica una entrada amb 0 vaixells.
        while(vaixells != 0){
            midaVaixells = sizeVaixells(vaixells);
            midaTauler = midaTauler();
            //+2 per a l'hora de comprovar si és correcte el tauler no haver
            //de tenir en compte si estem als extrems.
            tauler = new int[midaTauler + 2][midaTauler + 2];
            ompleTauler(tauler, midaTauler, sc);
            
            /*
            Identificació de la sequencia: [0, midaTauler]
            Primer: i = 0
            Seguent: i++
            FiSeq(): i > midaTauler || bonInput = false
            Identificacio de l'esquema: cerca, comprova que les dades introduides
            siguin correctes.
            */
            for(int i = 1; i <= midaTauler && bonInput; i++){
                for(int j = 1; j <= midaTauler && bonInput; j++){
                    bonInput = inputCorrecte(0, 1, tauler[i][j]);
                }
            }
            if(!bonInput){
                System.out.println("Les dades introduides no son correctes.");
                return;
            }
                    
            if(comprovarVaixells(tauler, midaVaixells, midaTauler, vaixells) == true){
                System.out.println("\nEl tauler SI és correcte.");
            }
            else{
                System.out.println("\nEl tauler NO és correcte.");
            }
            mostraPosicions(tauler, midaTauler);
            vaixells = comprovarVaixells();
        }
        System.out.println("S'ha acabat el joc.");
    }
    //Aquest mètode presenta el joc i dona indicacions per a jugar.
    static void initJoc(){
        System.out.println("Benvingut a Batalla Naval! \n" + 
                "Indicacions per a jugar:\n" + "1. Com a màxim es podran posar"
                + " 10 vaixells en un tauler.\n" + "2. La mida màxima del tauler"
                + " serà de 20 i sempre serà quadrat.\n" + "3. En el tauler, una"
                + " cel·la amb un valor de 0 indica aigua, una cel·la amb un" + 
                " valor 1 indicarà part d’un vaixell.");
    }
    //Aquest mètode demana a l'usuari amb quants vaixells vol jugar i es comprova
    //que el nombre introduit sigui correcte.
    static int comprovarVaixells(){
        System.out.println("\nQuants vaixells vols situar al tauler? (1-10)");
        int n = sc.nextInt();
        
        while (n <= 0 || n > 10){
            if(n == 0){
                return n;
            }
            System.out.println("El nombre de vaixells ha d'estar entre 1 i 10 (inclosos).");
            n = sc.nextInt();
        }
        return n;
    }
    //Aquest mètode demana la mida dels vaixells i emmagatzema en un array la mida
    //de cadascun dels vaixells. La mida de l'array dependrà de quants vaixells s'hagin
    //introduit.
    static int[] sizeVaixells(int n){
        int[] mida = new int[n];
        
        /*
        Identificació de la sequencia: [0, n)
        Primer: i = 0
        Seguent: i++
        FiSeq(): i >= n
        Identificacio de l'esquema: recorregut
        */
        for(int i = 0; i < n; i++){
            System.out.println("\nIndica la mida del vaixell " + (i+1));
            int m = sc.nextInt();
            mida[i] = m;
        }
        return mida;
    }
    
    //Aquest mètode demana la mida del tauler i comprova que sigui correcte.
    static int midaTauler(){
        System.out.println("\nIndica la mida del tauler (1-20)");
        int n = sc.nextInt();
        
        while (n < 1 || n > 20){
            System.out.println("La mida del tauler ha de ser entre 1 i 20 (inclosos).");
            n = sc.nextInt();
        }
        return n;
    }
    
    //Aquest mètode demana a l'usuari que ompli el tauler segons la mida 
    //d'aquest, amb 0's (aigua) o 1's (part d'un vaixell)
    static void ompleTauler(int[][] tauler, int mida, Scanner sc){
        System.out.println("\nOmple les caselles amb les posicions d'aigua (0) i de vaixells (1)");
        /*
        Identificació de la sequencia: [0, mida]
        Primer: i = 1
        Seguent: i++
        FiSeq(): i > mida
        Identificacio de l'esquema: recorregut
        */
        for(int i = 1; i <= mida; i++){
            for(int j = 1; j <= mida; j++){
                tauler[i][j] = sc.nextInt();
            }
        }
    }
    //Aquest mètode comprova que el tauler sigui correcte.
    static boolean comprovarVaixells(int [][] tauler, int[] midaVaixells, int midaTauler, int vaixells){
        boolean benFet = true;
        boolean[][] casellaVisitada = new boolean[midaTauler + 2][midaTauler + 2];
        int[] comprovacioMides = new int[vaixells];
        int comptador = 0;
        
        /*
        Identificació de la sequencia: [0, midaTauler]
        Primer: i = 1
        Seguent: i++
        FiSeq(): i > midaTauler
        Identificacio de l'esquema: cerca, comprovar si el tauler és correcte.
        */        
        for(int i = 1; i <= midaTauler; i++){
            /*
            Identificació de la sequencia: [0, midaTauler]
            Primer: j = 1
            Seguent: j++
            FiSeq(): j > midaTauler
            Identificacio de l'esquema: cerca, comprovar si el tauler és correcte.
            */  
            for(int j = 1; j <= midaTauler; j++){
                if(tauler[i][j] == 1 && !casellaVisitada[i][j]){
                    benFet = comprovarCelda(tauler, casellaVisitada, comprovacioMides, i, j, comptador++);
                }
            }
        }
        if(benFet){
            /*
            Identificació de la sequencia: [0, vaixells)
            Primer: i = 0
            Seguent: i++
            FiSeq(): i >= vaixells || benFet = false
            Identificacio de l'esquema: cerca, comprova si les mides de cadascun
            dels vaixells és correcte.
            */  
            for(int i = 0; i < vaixells && benFet; i++){
                if(midaVaixells[i] != comprovacioMides[i]){
                    benFet = false;
                }
            }
        }
        return benFet;
    }
    //Aquest mètode ens comprovarà si les cel·les són correctes i anirà comptant
    //les mides dels vaixells introduits per posteriorment comprovar si les mides
    //són correctes.
    static boolean comprovarCelda(int[][] tauler, boolean[][] casellaVisitada, int[] comprovacioMides, int posY, int posX, int compt){
        boolean correcte = true;
        comprovacioMides[compt] = 0;
        casellaVisitada[posY][posX] = true;
        
        if(tauler[posY + 1][posX] == 1 && tauler[posY][posX + 1] == 1){
            return false;
        }
        if(tauler[posY + 1][posX] == 1){
            while(tauler[posY][posX] == 1 && correcte){
                if(tauler[posY + 1][posX - 1] == 1 || tauler[posY + 1][posX + 1] == 1)
                    correcte = false;
                else{
                    comprovacioMides[compt]++;
                    posY++;
                    casellaVisitada[posY][posX] = true;
                }
            }
        }
        else if(tauler[posY][posX + 1] == 1){
            while(tauler[posY][posX] == 1 && correcte){
                if(tauler[posY - 1][posX + 1] == 1 || tauler[posY + 1][posX + 1] == 1)
                    correcte = false;
                else{
                    comprovacioMides[compt]++;
                    posX++;
                    casellaVisitada[posY][posX] = true;
                }
            }
        }
        return correcte;
    }
    //Aquest mètode guarda les posicions on hi ha part d'un vaixell (1)
    static void posicions(int [][] tauler, boolean[][] casellaVisitada, int midaTauler, int posY, int posX){
       System.out.printf("(%d,%d)", posY - 1, posX - 1);
        while(tauler[posY + 1][posX] == 1){
            System.out.printf("(%d,%d)", posY++, posX - 1);
            casellaVisitada[posY][posX] = true;
        }
        while(tauler[posY][posX + 1] == 1){
            System.out.printf("(%d,%d)", posY - 1, posX++);
            casellaVisitada[posY][posX] = true;
        }
    }
    //Aquest metode mostra les posicions on hi ha part d'un vaixell (1).
    static void mostraPosicions(int[][] tauler, int midaTauler){
        boolean[][] casellaVisitada = new boolean[midaTauler + 2][midaTauler + 2];
        /*
        Identificació de la sequencia: [0, midaTauler]
        Primer: i = 1
        Seguent: i++
        FiSeq(): i > midaTauler
        Identificacio de l'esquema: cerca, localitzar les posicions on hi hagi
        part d'un vaixell.
        */  
        for(int i = 1; i <= midaTauler; i++){
            /*
            Identificació de la sequencia: [0, midaTauler]
            Primer: j = 1
            Seguent: j++
            FiSeq(): j > midaTauler
            Identificacio de l'esquema: cerca, localitzar les posicions on hi hagi
            part d'un vaixell.
            */  
            for(int j = 1; j <= midaTauler; j++){
                if(tauler[i][j] == 1 && !casellaVisitada[i][j])
                    posicions(tauler, casellaVisitada, midaTauler, i, j);
            }
        }
        System.out.print("\n");
    }
    //Aquest mètode comprova que les dades que l'usuari ha introduit a l'hora
    //d'omplir el tauler siguin correctes.
    static boolean inputCorrecte(int min, int max, int celda){
        boolean benFet = true;
        if(celda < min || celda > max){
            benFet = false;
        }
        return benFet;
    }
    
}
        
        
        
        

    