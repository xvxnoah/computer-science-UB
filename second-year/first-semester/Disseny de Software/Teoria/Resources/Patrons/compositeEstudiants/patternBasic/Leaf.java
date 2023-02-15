package patternBasic;


public class Leaf implements Component {

    String name;

    public Leaf(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }
    @Override
    public void doSomething() {
        System.out.println("    " + getName() + " doing something...");
    }
}
