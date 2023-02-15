package vehiclesSenseFactory;

public class Truck implements Vehicle {
    /**
     *
     */
    public Truck() {
        System.out.println("Estic creant un camio"); // TODO Auto-generated constructor stub
    }

    /* (non-Javadoc)
     * @see com.globinch.pattern.factory.simple.Vehicle#drive()
     */
    @Override
    public void drive() {
        System.out.println("I am driving a truck !!");

    }

}
