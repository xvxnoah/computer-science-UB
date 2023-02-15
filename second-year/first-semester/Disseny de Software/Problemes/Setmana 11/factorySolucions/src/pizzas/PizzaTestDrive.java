package pizzas;

public class PizzaTestDrive {

	public static void main(String[] args) {
		try {
			SimplePizzaFactory factory =  SimplePizzaFactory.INSTANCE;

			PizzaStore store = new PizzaStore(factory);

			Pizza pizza = store.orderPizza("cheese");
			System.out.println("We ordered a " + pizza.getName() + "\n");
			System.out.println(pizza);

			pizza = store.orderPizza("veggie");
			System.out.println("We ordered a " + pizza.getName() + "\n");
			System.out.println(pizza);
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
	}
}
