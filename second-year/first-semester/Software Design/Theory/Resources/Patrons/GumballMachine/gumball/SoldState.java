package gumball;

public class SoldState implements State{
    @Override
    public void insertQuarter() {
        System.out.println("Please wait, we're already giving you a gumball");
    }

    @Override
    public void ejectQuarter() {
        System.out.println("Sorry, you already turned the crank");
    }

    @Override
    public void turnCrank() {
        System.out.println("Turning twice doesn't get you another gumball!");
    }

    @Override
    public void dispense() {
        System.out.println("A gumball comes rolling out the slot");
//        //count = count - 1;
//        if (count == 0) {
//            System.out.println("Oops, out of gumballs!");
//            state = SOLD_OUT;
//        } else {
//            state = NO_QUARTER;
//        }
    }

}
