package comparator;

import java.util.ArrayList;
import java.util.List;

public class ordenarTest {

    public static void main(String[] args) {
        List<User> list = new ArrayList<>();
        list.add(new User("Maria", 21));
        list.add(new User("David", 23));
        list.add(new User("Raul", 19));
        list.add(new User("Marta", 20));
        list.add(new User("Cristina", 21));

        list.sort(new perNom());

        System.out.println("Llista ordenada per noms:");
        for(User a: list)   // printing the sorted list of names by names
            System.out.print(a.getNom() + ", ");

        System.out.println();
        System.out.println("Llista ordenada per edat:");
        list.sort(new perEdat());
        for(User a: list)   // printing the sorted list of names by age
            System.out.print(a.getNom() + ":  " + a.getEdat()+ ", ");
    }
}
