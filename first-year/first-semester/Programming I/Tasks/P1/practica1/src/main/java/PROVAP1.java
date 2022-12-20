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

import java.util.*;
public class PROVAP1 {
    public static void main(String[] args){
        int compt1, compt2, i, n, posicio = 0;  //compt1 i compt2 comptadors de nombres de l'interval
        float a, b, c, d, num;
        float aux, maxim;
        Scanner scan = new Scanner(System.in);
        
        System.out.println("Introdueix els extrems del primer interval");
        a = scan.nextFloat();
        b = scan.nextFloat();
        
        if (a > b){
            aux = a;
            a = b;
            b = aux;
        }
        
        System.out.println("Introdueix els extrems del segon interval");
        c = scan.nextFloat();
        d = scan.nextFloat();
        
        if (c > d){
            aux = c;
            c = d;
            d = aux;
        }
        
        System.out.println("[" + a + " , " + b + "]");
        System.out.println("[" + c + " , " + d + "]");
        
        compt1 = compt2 = 0;
        maxim = a - 1;
        
        System.out.println("Introdueix n: ");
        n = scan.nextInt();
        
        System.out.println("Introdueix els " + n + " reals: ");
        
        for (i = 1; i <= n; i++){
            num = scan.nextFloat();
            
            if (a <= num && num <= b){
                compt1++;
            }
            if (c <= num && num <= d){
                compt2++;
            }
            if (maxim < num){
                maxim = num;
                posicio = i;
            }
        }
        
        if (compt1 <= 0 && compt2 <= 0){
            System.out.println("No hi ha cap nombre dins de cap interval");
        }else{
           if (compt1 > 0){
                System.out.println("Hi ha " + compt1 + " nombres del primer interval");
            }
            if (compt2 > 0){
                System.out.println("Hi ha " + compt2 + " nombres del segon interval");
            }
            System.out.println("El maxim es " + maxim + " i ocupa la posicio " + posicio);
        }
        
    }
}
