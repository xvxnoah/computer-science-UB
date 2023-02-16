package document.state;

public class DraftState implements State{

    Document doc;

    public DraftState( ) {

    }

    @Override
    public void setDocument(Document doc) {
        this.doc = doc;
    }

    @Override
    public void render() {
        System.out.println("Draft");
    }

    @Override
    public void update(Rol role, Actions action) {
        if (role == Rol.User)
            doc.changeState(new ModerationState());
        else if (role == Rol.Admin)
            doc.changeState(new PublishedState());
    }
}
