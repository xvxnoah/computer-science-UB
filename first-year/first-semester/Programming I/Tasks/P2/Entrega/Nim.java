/*
 Feu un programa per a jugar el joc del Nim. Dos jugadors col·loquen a un tauler
un nombre de fitxes major o igual a 20 i menor estricte a 30 (aquest nombre es
genera de forma aleatòria). Un jugador és l’ordinador, l’altre serà un jugador
humà. Un nombre també aleatori indicarà quin jugador comença a jugar. Cada
jugador en el seu torn retira una o dues fitxes. L’ordinador genera un nombre
aleatori entre 1 i 2 per a retirar fitxes. El tauler s’ha d’anar actualitzant
en cada torn. Guanya el jugador que aconsegueix retirar l’última fitxa. (Nim.java)

A continuació teniu un exemple de com ha de ser una partida:
Juguem amb 23 fitxes.

Comenca l'ordinador
L'ordinador agafa 2 fitxes
Queden 21 fitxes
Quantes fitxes agafes (1 or 2)?
2
Queden 19 fitxes
L'ordinador agafa 1 fitxes
Queden 18 fitxes
Quantes fitxes agafes (1 or 2)?
2
Queden 16 fitxes
.
.
.
Queden 2 fitxes
L'ordinador agafa 1 fitxes
Queden 1 fitxes
Quantes fitxes agafes (1 or 2)?
1
Queden 0 fitxes
Has guanyat!
 */

/**
 *
 * @author Noah Márquez
 */
import java.util.Scanner;

public class Nim{                                                                                                                                                           
  public static void main(String []arg){
      final int MIN = 20, MAX = 30;
      Scanner teclat = new Scanner(System.in);
      int queden, nFitxes;
      boolean quiTira;
      
      //Generem un nombre aleatori >= que 20 i < 30.
      queden = (int)(Math.random() * (MAX - MIN) + MIN);
      System.out.println("Juguem amb " + queden + " fitxes.\n");
      System.out.println("L'últim que agafa, guanya!");
      
      quiTira = quiComenca();
      
      while (queden > 0){
          if (quiTira){
              if (queden > 1){ //Per a evitar que agafi 2 fitxes quan queda nomes 1.
                  nFitxes = tiradaOrdinador();
                  queden -= nFitxes;
              }
              else{
                  nFitxes = 1;
                  queden -= nFitxes;
              }
              System.out.println("Queden " + queden + " fitxes");
          }
          else{
              System.out.println("Quantes fitxes agafes (1 or 2)?");
              nFitxes = teclat.nextInt();
              queden -= nFitxes;
              System.out.println("Queden " + queden + " fitxes");
          }
          if (queden > 0){
              quiTira = !quiTira;
          }
      }
      if (quiTira){
          System.out.println("Guanya l'ordinador!");
      }
      else{
          System.out.println("Has guanyat!");
      }
  }
  
  //Aquest mètode genera un nombre aleatori (0 o 1) per assignar el torn a l'ordinador o al jugador
  //Retorna true si comença l'ordinador (ha sortit el random 0) i false si comença el jugador (ha sortit el random 1)
  static boolean quiComenca(){
      if((int)(Math.random()*2) == 0){
          System.out.println("Comença l'ordinador");
          return true;
      }
      else{
          System.out.println("Comences tu");
          return false;
      }
        
  }
  
  //Aquest mètode retorna la tirada de l'ordinador (un random 1 o 2)
  static int tiradaOrdinador(){
      int tirada;
      tirada = (int)(Math.random() * 2 + 1);
      System.out.println("L'ordinador agafa " + tirada + " fitxes");
      return tirada;
  }
}