package document.AbstractState;

public class DraftState extends State {

    public DraftState(Document document) {
        super(document);
    }
    @Override
    public void render() {
        System.out.println("Draft");
    }

    @Override
    public void update(Rol role, Actions action) {
        if (role == Rol.User)
            doc.changeState(new ModerationState(doc));
        else if (role == Rol.Admin)
            doc.changeState(new PublishedState(doc));
    }
}
