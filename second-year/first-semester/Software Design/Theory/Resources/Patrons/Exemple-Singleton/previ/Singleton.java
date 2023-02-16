package previ;

public class Singleton {

    private Singleton() { System.out.println("Constructor singleton");}

    public static Singleton getInstance() {
        return new Singleton();
    }
}
