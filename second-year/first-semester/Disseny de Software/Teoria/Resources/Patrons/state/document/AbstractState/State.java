package document.AbstractState;

public abstract class State {

	protected Document doc;

	protected State(Document doc) {
		this.doc = doc;
	}

	public void setDocument(Document doc) {
		this.doc = doc;
	}

	abstract public void render();
	abstract public void update(Rol rol, Actions action);
}
