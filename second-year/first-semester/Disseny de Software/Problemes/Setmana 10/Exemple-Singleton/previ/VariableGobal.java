package previ;

public class VariableGobal {
    public static void main(String[] args) {

        SenseSingleton variableGlobal;

        System.out.println("Main starts");

        variableGlobal = new SenseSingleton();

        System.out.println(variableGlobal);

        variableGlobal = new SenseSingleton();

        System.out.println(variableGlobal);

    }
}
