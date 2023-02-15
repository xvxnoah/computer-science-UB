package document.AbstractState;

public class ModerationState extends State {

    public ModerationState(Document doc) {
        super(doc);
    }


    @Override
    public void render() {
        System.out.println("Moderation");
    }

    @Override
    public void update(Rol rol, Actions action) {
        if (rol == Rol.Admin) {
            if (action == Actions.Approved)
                doc.changeState(new PublishedState(doc));
            else if (action == Actions.ReviewFailed)
                doc.changeState(new DraftState(doc));
        }
    }
}
