package document.AbstractState;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DocumentTestDrive {
    public static void main(String[] args) {
        Document doc;
        String date_string = "11-12-2021";
        //Instantiating the SimpleDateFormat class
        SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy");
        //Parsing the given String to Date object
        Date date = null;
        try {
            date = formatter.parse(date_string);
            doc = new Document("Prova de canvis d'estat", date);
            doc.changeState(new DraftState(doc));
            doc.render();
            doc.update(Rol.User, Actions.Publish);
            doc.render();
            doc.update(Rol.Admin, Actions.ReviewFailed);
            doc.render();
            doc.update(Rol.Admin, Actions.Publish);
            doc.render();
            doc.update(Rol.Admin, Actions.Publish);
            doc.render();

        } catch (ParseException e) {
            e.printStackTrace();
        }


    }
}
