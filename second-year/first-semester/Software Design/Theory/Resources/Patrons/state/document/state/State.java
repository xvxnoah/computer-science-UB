package document.state;

public interface State {

	void setDocument(Document doc);

	public void render();
	public void update(Rol rol, Actions action);
}
