/*
Fes un programa que donada una frase digu si és palindroma o no.Treu-re espais
i passar-ho tot a minúscula.

Hi ha dues seqüències:

Primera seqüència:
------------------
    -->Inici: nextLine();
    -->Següent: nextLine();
    -->FiSeq: paraula.equals("fi") == true;
    -->Identificació de la seqüència: RECORREGUT.

Segona seqüència:
-----------------
    -->Inici: paraula.length()-1, j=0;
    -->Següent: j = j + 1, i = i - 1;
    -->FiSeq: (x!=0 || i<j);
    -->Identificació de la seqüència: RECORREGUT.

 */

import java.util.*;
public class SolPalindrom {
    public static void main(String[]args){
        Scanner sc = new Scanner(System.in);
        String paraula;
        int i, x = 0, j;
        
        System.out.println("Entra una frase [fi per acabar]:");
        paraula = sc.nextLine();
        paraula = paraula.replaceAll("\\s", ""); //Per treure els espais.
        paraula = paraula.toLowerCase();
        
        while(!paraula.equals("fi")){
            
            i = paraula.length()-1;
            j = 0;
            
            while(i>j && x==0){
                if(paraula.charAt(i) != (paraula.charAt(j))){
                    x++;
                }
                j++;
                i--;
                }
            if(x == 0){
                System.out.println("Si és palíndrom.");
            }
            else{
                System.out.println("No és palíndrom.");
            }
            x = 0;
            System.out.println("Entra una frase [fi per acabar]:");
            paraula = sc.nextLine();
            paraula = paraula.replaceAll("\\s", ""); //Per treure els espais.
            paraula = paraula.toLowerCase();
            }
        }
        
    }

