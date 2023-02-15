package prog2.model;

import java.io.Serializable;

public class Federacio implements Serializable{
    String nomFederacio;
    float preu;
    
    /**
     * Constructor per paràmetres de la classe Federacio.
     * @param nom, nom de la federació.
     * @param preu, preu de la federació.
     */
    public Federacio(String nom, float preu){
        nomFederacio = nom;
        this.preu = preu;
    }

    /**
     *
     * @return nomFederacio, el nom de la federació.
     */
    public String getNomFederacio() {
        return nomFederacio;
    }

    /**
     *
     * @param nomFederacio, nom de la federació.
     */
    public void setNomFederacio(String nomFederacio) {
        this.nomFederacio = nomFederacio;
    }

    /**
     *
     * @return preu, de la federació.
     */
    public float getPreu() {
        return preu;
    }

    /**
     * Es comprovarà des del constructor de la classe SociFederat que el preu
     * de la federació no sigui inferior a 100.
     * @param preu, preu de la federació.
     */
    public void setPreu(float preu) {
        this.preu = preu;
    }
    
    /**
     * 
     * @return String amb la informació de la federació.
     */
    @Override
    public String toString(){
        return " Federació: Nom = " + getNomFederacio()+ ", Preu = " + getPreu() + ".";
    }
}
