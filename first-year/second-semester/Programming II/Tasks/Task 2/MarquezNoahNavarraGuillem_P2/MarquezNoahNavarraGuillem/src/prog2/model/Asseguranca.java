package prog2.model;

import java.io.Serializable;

public class Asseguranca implements Serializable{
    String tipus;
    float preu;
            
    /**
     * Constructor per paràmetres de la classe Assegurança.
     * @param tipus, tipus d'assegurança
     * @param preu, preu de l'assegurança
     */
    public Asseguranca(String tipus, float preu){
        this.tipus = tipus;
        this.preu = preu;
    }

    /**
     *
     * @return tipus d'assegurança
     */
    public String getTipus() {
        return tipus;
    }

    /**
     * A l'hora de crear un SociEstandard es comprova que el tipus sigui correcte
     * al constructor d'aquest, en canvi quan es solicita canviar el tipus
     * d'assegurança, es comprova a la classe VistaClubUB.
     * @param tipus d'assegurança (Bàsica o Completa)
     */
    public void setTipus(String tipus) {
        this.tipus = tipus;
    }

    /**
     *
     * @return preu, preu assegurança
     */
    public float getPreu() {
        return preu;
    }

    /**
     *
     * @param preu, preu assegurança
     */
    public void setPreu(float preu) {
        this.preu = preu;
    }
    
    /**
     * 
     * @return String amb la informació de l'assegurança
     */
    @Override
    public String toString(){
        return " Assegurança: Tipus = " + getTipus() + ", Preu = " + getPreu() + ".";
    }
}
