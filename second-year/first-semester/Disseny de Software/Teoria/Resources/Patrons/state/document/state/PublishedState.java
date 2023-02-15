package document.state;

import java.util.Calendar;
import java.util.Date;

public class PublishedState implements State{

    Document doc;

    public PublishedState() {

    }
    @Override
    public void setDocument(Document doc) {
        this.doc = doc;
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
            doc.changeState(new DraftState());
        }
    }
}
