package stat;

public class SingletonClient {
	public static void main(String[] args) {

        System.out.println("Main starts");

        System.out.println(Singleton.description);

		Singleton singleton = Singleton.getInstance();

		System.out.println(singleton.getDescription());

		singleton = Singleton.getInstance();

		System.out.println(singleton.getDescription());

	}
}
