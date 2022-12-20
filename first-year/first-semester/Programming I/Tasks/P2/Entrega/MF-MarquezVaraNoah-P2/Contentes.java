/*
Feu un programa per a veure si cada caràcter ‘a’ d’una paraula llegida per teclat
està contenta. Una ‘a’ està contenta si té a la seva esquerra o a la seva dreta
una altre ‘a’. El programa ens diu si totes les ‘a’ estan contentes. Per exemple:
si introduïm “zdaaoa” el programa mostra el missatge “No totes les a estan
contentes”, amb la cadena “zdaa” el programa mostra “Totes les a estan contentes”
(Contentes.java). 
 */

/**
 *
 * @author Noah Márquez
 */
import java.util.Scanner;

public class Contentes{
  public static void main(String []arg){
      Scanner sc = new Scanner(System.in);
      boolean a_contenta;
      String paraula;
      
      System.out.println("Introdueix una paraula per veure si les seves 'a'"
                + " són contentes:");
      paraula = sc.nextLine();
      paraula = paraula.toLowerCase();
      
      a_contenta = totesContentes(paraula);
      
      if (a_contenta){
          System.out.println("Totes les 'a' estan contentes.");
      }
      else{
          System.out.println("No totes les 'a' estan contentes.");
      }
    
  }
 
  //Aquest mètode rep una cadena i retorna true si totes les a estan contentes i false si no totes les a
  //están contentes
  static boolean totesContentes (String cadena){
      int j = cadena.length();
      boolean contenta = true;
      
      /*Identificació de la seqüència:
        -->Primer: i = 0
        -->Següent(i): i++
        -->FinSeq(): i > j || !contenta
        -->Esquema: cerca, condició cerca: (i > 0 && cadena.charAt(i - 1) == 'a' ||
                    (i < j-1 && cadena.charAt(i+1) == 'a')
      */
      
      for (int i = 0; i < j && contenta; i++){
            for (i = 0; i < j && contenta; i++){
            if(cadena.charAt(i) == 'a'){
                if(i > 0 && cadena.charAt(i-1) == 'a'){
                    contenta = true;
                }
                else if (i < j-1 && cadena.charAt(i+1) == 'a'){
                    contenta = true;
                }
                else{
                    contenta = false;
                }
            }
        }
     }
      return contenta; 
  }
} 

        
