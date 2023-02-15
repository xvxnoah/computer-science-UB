package prog2.vista;

public class ExcepcioClub extends Exception{

    public ExcepcioClub () {
        super();
    }
    
    /**
     *
     * @param msg, amb el missatge de l'excepció.
     */
    public ExcepcioClub(String msg) {
        super(msg);
    }
}
