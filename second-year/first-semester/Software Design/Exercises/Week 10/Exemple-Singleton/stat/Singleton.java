package stat;

public class Singleton {


	public static String description = "I'm a statically initialized Singleton!";
	private static Singleton uniqueInstance = new Singleton();
 
	private Singleton() {}
 
	public static Singleton getInstance() {

		return uniqueInstance;
	}
	
	// other useful methods here
	public String getDescription() {
		return description+" de dins del mètode " + uniqueInstance.hashCode();
	}
}
