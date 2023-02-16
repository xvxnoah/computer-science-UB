package comparator;

public class User {
    private String nom;
    private int edat;

    public User (String nom, int edat) {
        this.nom = nom;
        this.edat = edat;
    }
    String getNom (){ return nom;}
    int getEdat() { return edat;}
}
