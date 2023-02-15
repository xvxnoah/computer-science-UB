package document.SingletonStates;

import java.util.Date;

public class Document {
    State currentState;
    Date data;
    String title;

    public Document(String title, Date data) {
        this.title = title;
        this.data = data;
    }

    public void update(Rol role, Actions action ) {
        currentState.update(role, action);
    }
    public void changeState(State state) {
        currentState = state;
        currentState.setDocument(this);
    }
    public void render() {
       System.out.println(this);
       currentState.render();
    }
    public String toString() {
        return "The document: "+ this.title + " is in " ;
    }
}
