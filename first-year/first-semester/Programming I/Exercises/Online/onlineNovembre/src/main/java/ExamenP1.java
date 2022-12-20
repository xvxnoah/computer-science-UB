/*
  Author:     Noah Márquez
  Data:       04/11/2020
  Version:    1.0 
*/

/* Donats dos intervals [a, b] [c, d] i n nombres reals (n>0), volem saber
 * quants nombres son de l'interval [a,b] i quants son de l'interval [c,d].
 *
 * El programa llegeix a i b (no necessariament a <= b), llegeix c i d (no necessariament c <= d)
 * i escriu quants nombres llegits son de cada interval fent servir el missatge "Hi ha x nombres del primer interval" "Hi ha x nombres del segon interval". 
 * Si no hi ha nombres d'un interval s'escriu "No hi ha nombres del primer interval" "No hi ha nombres del segon interval"
 * El programa també escriu quin es el nombre mes gran dels intervals llegits i la seva posició en l'ordre de lectura
 */
 
/*
El format de la sortida ha seguir el que s'indica al següent exemple:

Introdueix els extrems del primer interval                                                                                          
1                                                                                                                                   
2                                                                                                                                   
Introdueix els extrems del segon interval                                                                                           
8                                                                                                                                   
-2                                                                                                                                  
[1.0 , 2.0]                                                                                                                         
[-2.0 , 8.0]                                                                                                                        
Introdueix n:                                                                                                                       
5                                                                                                                                   
Introdueix els 5 reals:                                                                                                             
1                                                                                                                                   
2                                                                                                                                   
3                                                                                                                                   
-4.5                                                                                                                                
8.4                                                                                                                                 
Hi ha 2 nombres del primer interval                                                                                                 
Hi ha 3 nombres del segon interval                                                                                                  
El maxim es 3 i ocupa la posicio 3  

*/


/* Escriu aqui la taula de test
Entrada                            | Sortida a pantalla
------------------------------------------------------
1, 2, 8, -2, 5, 1,2,3,-4.5,8.4      |[1.0 , 2.0]  [-2.0 , 8.0] Hi ha 2 nombres del primer interval Hi ha 3 nombres del segon interval El maxim es 3 i ocupa la posicio 3
3, 8, 1, 10, 3, 3, 5, 1,            |[3.0 , 8.0] [1.0 , 10.0] Hi ha 2 nombres del primer interval Hi ha 3 nombres del segon interval El maxim es 5 i ocupa la posicio 2
-30, 5, -15, 10.5, 2, -7, -8        |[-30.0 , 5.0] [-15.0 , 10.5] Hi ha 2 nombres del primer interval Hi ha 2 nombres del segon interval El maxim es -7 i ocupa la posicio 1
5, 7, 7, 13, 1, 8                   |[5.0 , 7.0] [7.0 , 13.0] No hi ha nombres del primer interval Hi ha 2 nombres del segon interval El maxim es 8 i ocupa la posicio 1
*/

import java.util.Scanner;
public class ExamenP1 {
    public static void main(String[] args) {
       Scanner sc = new Scanner(System.in);
       double a, b, c, d, real, max = -9999999;
       int n, j = 0, k = 0, i, pos  = 0;
       
       System.out.println("Introdueix els extrems del primer interval");
       a = sc.nextDouble();
       b = sc.nextDouble();
       
       System.out.println("Introdueix els extrems del segon interval");
       c = sc.nextDouble();
       d = sc.nextDouble();
       
       //Comprovem els nombres introduits per ordenar-los correctament als invervals.
       if(a < b){
           System.out.println("[" + a + " , " + b + "]");
       }else{
           System.out.println("[" + b + " , " + a + "]");
       }
       if(c < d){
           System.out.println("[" + c + " , " + d + "]");
       }else{
           System.out.println("[" + d + " , " + c + "]");
       }
       
       //Demanem la n, i si no es mes gran que 0, la continuem demanant.
       System.out.println("Introdueix n:");
       n = sc.nextInt();
       while (n < 0){
           System.out.println("Introdueix n:");
           n = sc.nextInt();
       }
       
       System.out.println("Introdueix els " + n + " reals:");
       //Bucle for per realitzar-lo fins que el comptador i sigui <= que els n nombres introduits.
       for (i = 1; i <= n; i++){
            real = sc.nextDouble();
            //Comprovacio de si el real introduit es troba dins del primer interval, si es aixi, incrementem en 1 la variable j.
            if (( a <= real && real <= b ) || (b <= real && real <= a)){
                j++;
                //Comprovem si el real es mes gran que max per assignar-lo a aquesta variable.
                if (real > max){
                    max = real;
                    pos = i;
                }
            }
            //Comprovacio de si el real introduit es troba dins del segon interval, si es aixi, incrementem en 1 la variable k.
            if (( c <= real && real <= d ) || (d <= real && real <= c)){
                k++;
                //Comprovem si el real es mes gran que max per assignar-lo a aquesta variable.
                if (real > max){
                    max = real;
                    pos = i; //En cas de que sigui màxim la variable posicio tindra el valor de la 'i' del for.
                }
            
             }
       }
       
       if (j > 0){
           System.out.println("Hi ha " + j + " nombres del primer interval");
       }else{
           System.out.println("No hi ha nombres del primer interval");
       }
       if (k > 0){
           System.out.println("Hi ha " + k + " nombres del segon interval");
       }else{
           System.out.println("No hi ha nombres del segon interval");
       }
       System.out.println("El maxim es " + max + " i ocupa la posicio " + pos);
       
   }
}
