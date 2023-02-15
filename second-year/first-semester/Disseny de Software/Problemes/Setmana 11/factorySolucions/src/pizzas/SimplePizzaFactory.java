package pizzas;

public enum SimplePizzaFactory {

	INSTANCE;
	public Pizza createPizza(String type) throws Exception {
		Pizza pizza = null;

		try {
			String name = Pizza.class.getPackage().getName();
			pizza = (Pizza) Class.forName(name+"."+type).newInstance();
			return pizza;
		} catch (Exception e) {
			throw new Exception("The pizza type is unknown!");
		}
	}
}
