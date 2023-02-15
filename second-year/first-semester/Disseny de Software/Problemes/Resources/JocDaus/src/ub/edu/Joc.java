package ub.edu;

public class Joc {
    private Jugador jugador1;
    private Jugador jugador2;

    public Joc() {
        jugador1 = new Jugador();
        jugador2 = new Jugador();
    }
    public String jugar() {
        int x1;
        int x2;

        x1 = jugador1.tirar();
        x2 = jugador2.tirar();

        if (x1>x2) return "Guanya el jugador 1: " + x1 +" contra " + x2;
        else if (x1<x2) return "Guanya el jugador 2: "+x2 + " contra " + x1;
        else return "Heu empatat";

    }
}
