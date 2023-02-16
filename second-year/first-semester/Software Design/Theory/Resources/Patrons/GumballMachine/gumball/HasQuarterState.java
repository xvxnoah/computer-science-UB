package gumball;

public class HasQuarterState implements State{
    @Override
    public void insertQuarter() {
        System.out.println("You can't insert another quarter");
    }

    @Override
    public void ejectQuarter() {
        System.out.println("Quarter returned");
    }

    @Override
    public void turnCrank() {
        System.out.println("You turned...");

        dispense();
    }

    @Override
    public void dispense() {
        System.out.println("No gumball dispensed");
    }
}



