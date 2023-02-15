package document.opcions;
import java.util.Calendar;
import java.util.Date;

public class Document {
    StatesDocument currentState;
    Date data;
    String title;

    public Document(String title, Date data) {
        this.title = title;
        this.data = data;
        this.currentState = StatesDocument.Draft;
    }

    public void update(Rol role, Actions action ) {
        System.out.println("The role: "+role + " is doing "+action);
        switch (currentState) {
            case Draft:
                if (action == Actions.Publish) {
                    if (role == Rol.User)
                        currentState = StatesDocument.Moderation;
                    else if (role == Rol.Admin)
                        currentState = StatesDocument.Published;
                }
                break;
            case Moderation:
                if (role == Rol.Admin) {
                    if (action == Actions.Approved)
                        currentState = StatesDocument.Published;
                    else if (action == Actions.ReviewFailed)
                        currentState = StatesDocument.Draft;
                }
                break;
            case Published:
                Calendar obj = Calendar.getInstance();
                Date currentDate = obj.getTime();
                System.out.println("Current Date and time: "+currentDate);
                if (data.after(currentDate)) {
                    currentState = StatesDocument.Draft;
                }
                break;
        }
    }

    public String toString() {
        return "The document: "+ this.title + " is in " + this.currentState;
    }

}
