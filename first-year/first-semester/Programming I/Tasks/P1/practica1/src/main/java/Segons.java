/*
  author:  Noah
  date:    .................
  version: .................
*/

//Feu un programa que converteix una quantitat donada de segons en hores, minuts i segons. 
//Per exemple, donan't 89999 segons ha de sortir el missatge "89999 segons son: 24h 59m 59s".

import java.util.*;

public class Segons{

//RECORDEU FER AQUESTA TAULA DE TEST EN TOTS ELS EXERCICIS
/* 
Taula de test
-------------------------------
entrada           | sortida
89999             | 24h 59m 59s
0                 | 0h  0m  0s
3600              | 1h  0m  0s //TODO: defineix més casos de test
7200              | 2h  0m  0s
*/

  public static void main(String [] args){

    Scanner teclado = new Scanner(System.in);
    int hores, minuts, seg, segons;

    System.out.println("Dona'm un nombre de segons:");
    seg = teclado.nextInt();
    hores = seg / 3600;
    minuts = (seg - (hores * 3600)) / 60;
    segons = seg - ((hores * 3600) + (minuts * 60));

    System.out.println(seg + " segons son: " + hores+ "h " + minuts+ "m " + segons+ "s");
  }
}