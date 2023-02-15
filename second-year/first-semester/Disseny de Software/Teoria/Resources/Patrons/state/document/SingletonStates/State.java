package document.SingletonStates;

public abstract class State {

	protected Document doc;

	public void setDocument(Document doc) {
		this.doc = doc;
	}

	abstract public void render();
	abstract public void update(Rol rol, Actions action);
}
