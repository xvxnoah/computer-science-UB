package previ;

public class SingletonClient {
    public static void main(String[] args) {

        System.out.println("Main starts");

        Singleton singleton = Singleton.getInstance();

        System.out.println(singleton);

        singleton = Singleton.getInstance();

        System.out.println(singleton);
    }
}
