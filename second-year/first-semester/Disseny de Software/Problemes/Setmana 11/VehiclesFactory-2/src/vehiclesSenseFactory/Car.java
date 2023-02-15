package vehiclesSenseFactory;

public class Car implements Vehicle{
    /**
     *
     */
    public Car() {
        System.out.println("Estic creant un coche"); // TODO Auto-generated constructor stub
    }

    /* (non-Javadoc)
     * @see com.globinch.pattern.factory.simple.Vehicle#drive()
     */
    @Override
    public void drive() {
        System.out.println("I am driving a car!");

    }
}
