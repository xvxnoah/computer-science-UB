package ub.edu;

public class Jugador {
    private Dau dau;
    public Jugador() {
        dau = new Dau();
    }

    public int tirar() {
        return dau.tirar();
    }
}
