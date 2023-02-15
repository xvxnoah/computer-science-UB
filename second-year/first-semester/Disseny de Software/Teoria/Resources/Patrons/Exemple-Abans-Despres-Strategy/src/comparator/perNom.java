package comparator;

import java.util.Comparator;

public class perNom implements Comparator<User> {
    @Override
    public int compare(User o1, User o2) {
        return o1.getNom().compareToIgnoreCase(o2.getNom());
    }
}
