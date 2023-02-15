package patternBasic;

import java.util.ArrayList;


public class Composite implements Component {

    private ArrayList<Component> components;
    private String name;

    public Composite(String name) {
        this.name = name;
        components = new ArrayList<>();
    }

    public String getName() {
        return name;
    }


    public void add(Component component) {
        components.add(component);
    }


    public void remove(Component component) {
        components.remove(component);
    }

    @Override
    public void doSomething() {
        System.out.println(getName() + " doing something...");
        for(Component component : components){
            component.doSomething();
        }
    }
}
