package document.SingletonStates;

public class DraftState extends State {

    private static State state;
    private DraftState() {
    }

    protected static State getInstance() {
        if (state==null) {
            state = new DraftState();
        }
        return state;
    }

    @Override
    public void render() {
        System.out.println("Draft");
    }

    @Override
    public void update(Rol role, Actions action) {
        if (role == Rol.User)
            doc.changeState( ModerationState.getInstance());
        else if (role == Rol.Admin)
            doc.changeState( PublishedState.getInstance());
    }
}
