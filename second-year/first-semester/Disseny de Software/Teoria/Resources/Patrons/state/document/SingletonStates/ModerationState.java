package document.SingletonStates;

public class  ModerationState extends State {

    private static State state;
    private ModerationState() {
    }

    protected static State getInstance() {
        if (state==null) {
            state = new ModerationState();
        }
        return state;
    }

    @Override
    public void render() {
        System.out.println("Moderation");
    }

    @Override
    public void update(Rol rol, Actions action) {
        if (rol == Rol.Admin) {
            if (action == Actions.Approved)
                doc.changeState( PublishedState.getInstance());
            else if (action == Actions.ReviewFailed)
                doc.changeState( DraftState.getInstance());
        }
    }
}
