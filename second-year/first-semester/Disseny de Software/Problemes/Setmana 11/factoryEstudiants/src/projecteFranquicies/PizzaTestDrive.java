package projecteFranquicies;

public class PizzaTestDrive {
 
	public static void main(String[] args) {
		DependentPizzaStore store = new DependentPizzaStore();
		
		Pizza pizza = store.createPizza("NY", "cheese");
		System.out.println("Ethan ordered a " + pizza.getName() + "\n");
 
		pizza = store.createPizza("Chicago", "cheese");
		System.out.println("Joel ordered a " + pizza.getName() + "\n");

		pizza = store.createPizza("NY","clam");
		System.out.println("Ethan ordered a " + pizza.getName() + "\n");
 
		pizza = store.createPizza("Chicago", "clam");
		System.out.println("Joel ordered a " + pizza.getName() + "\n");

		pizza = store.createPizza("NY","pepperoni");
		System.out.println("Ethan ordered a " + pizza.getName() + "\n");
 
		pizza = store.createPizza("Chicago", "pepperoni");
		System.out.println("Joel ordered a " + pizza.getName() + "\n");

		pizza = store.createPizza("NY","veggie");
		System.out.println("Ethan ordered a " + pizza.getName() + "\n");
 
		pizza = store.createPizza("Chicago", "veggie");
		System.out.println("Joel ordered a " + pizza.getName() + "\n");
	}
}
