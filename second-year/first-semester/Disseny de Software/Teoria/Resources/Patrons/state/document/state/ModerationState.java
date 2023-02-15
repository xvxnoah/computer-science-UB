package document.state;

public class ModerationState implements State{
    Document doc;

    public ModerationState() {

    }
    @Override
    public void setDocument(Document doc) {
        this.doc = doc;
    }


    @Override
    public void render() {
        System.out.println("Moderation");
    }

    @Override
    public void update(Rol rol, Actions action) {
        if (rol == Rol.Admin) {
            if (action == Actions.Approved)
                doc.changeState(new PublishedState());
            else if (action == Actions.ReviewFailed)
                doc.changeState(new DraftState());
        }
    }
}
