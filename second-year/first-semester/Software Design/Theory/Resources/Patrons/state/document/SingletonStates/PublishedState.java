package document.SingletonStates;

import java.util.Calendar;
import java.util.Date;

public class PublishedState extends State {
    private static State state;
    private PublishedState() {
    }

    protected static State getInstance() {
        if (state==null) {
            state = new PublishedState();
        }
        return state;
    }


    @Override
    public void render() {
        System.out.println("Published");
    }

    @Override
    public void update(Rol rol, Actions action) {
        Calendar obj = Calendar.getInstance();
        Date currentDate = obj.getTime();
        System.out.println("Current Date and time: "+currentDate);
        if (doc.data.after(currentDate)) {
            doc.changeState(DraftState.getInstance());
        }
    }
}
