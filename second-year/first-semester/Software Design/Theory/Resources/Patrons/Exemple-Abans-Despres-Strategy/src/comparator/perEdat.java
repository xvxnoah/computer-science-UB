package comparator;

import java.util.Comparator;

public class perEdat implements Comparator<User> {
    @Override
    public int compare(User o1, User o2) {
        return o1.getEdat()-o2.getEdat();
    }
}
