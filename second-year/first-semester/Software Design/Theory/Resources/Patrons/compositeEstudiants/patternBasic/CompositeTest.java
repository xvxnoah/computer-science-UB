package patternBasic;


public class CompositeTest {

    public static void main(String[] args) {

        Component componentOne = new Composite("Composite One");
        Component componentTwo = new Composite("Composite Two");
        Component componentThree = new Composite("Composite Three");

        Component componentWrapper = new Composite("All components");

        ((Composite) componentWrapper).add(componentOne);
        ((Composite) componentWrapper).add(componentTwo);
        ((Composite) componentWrapper).add(componentThree);

        ((Composite) componentOne).add(new Leaf("ONE: Sub component one"));
        ((Composite) componentOne).add(new Leaf("ONE: Sub component two"));
        ((Composite) componentOne).add(new Leaf("ONE: Sub component three"));

        ((Composite) componentTwo).add(new Leaf("TWO: Sub component one"));
        ((Composite) componentTwo).add(new Leaf("TWO: Sub component two"));

        ((Composite) componentThree).add(new Leaf("THREE: Sub component one"));
        ((Composite) componentThree).add(new Leaf("THREE: Sub component two"));
        ((Composite) componentThree).add(new Leaf("THREE: Sub component three"));
        ((Composite) componentThree).add(new Leaf("THREE: Sub component four"));


        componentWrapper.doSomething();

    }

}
