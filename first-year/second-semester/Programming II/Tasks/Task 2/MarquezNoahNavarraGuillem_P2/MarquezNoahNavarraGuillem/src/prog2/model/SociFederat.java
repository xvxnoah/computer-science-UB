package prog2.model;

import java.io.Serializable;
import prog2.vista.ExcepcioClub;

public class SociFederat extends Soci implements Serializable{
    /* Atributs */
    private Federacio federacio;
    private float descompteQuota;
    private float descompteExcursio;
    
    /**
     * Constructor per paràmetres de la classe SociFederat.
     * @param _nom, nom del soci.
     * @param _dni, dni del soci.
     * @param federacio, objecte de tipus federació.
     * @param descompteQuota, descompte del soci en la quota base mensual.
     * @param descompteExcursio, descompte del soci en el preu base d'una excursió.
     * @throws ExcepcioClub si el preu de la federació és menor a 100.
     */
    public SociFederat(String _nom, String _dni, Federacio federacio, float descompteQuota, float descompteExcursio) throws ExcepcioClub{
        super(_nom, _dni);
        this.federacio = federacio;
        if(!comprova(federacio.getPreu())) throw new ExcepcioClub("El preu de la federació no és correcte.");
        
        this.descompteQuota = descompteQuota;
        this.descompteExcursio = descompteExcursio;
    }

    
    /**
     * Mètode que comprova que el preu introduït per l'usuari sigui correcte.
     * @param preu, preu de la federació.
     * @return true si és correcte, false altrament.
     */
    public boolean comprova(float preu){
        return preu >= 100;
    }
    
    /**
     * Calcular el preu de les excursions del soci.
     * @param preuExcursioBase preu de les excursions del club.
     * @return float amb el preu de les excursions d'aquest soci.
     */
    @Override
    public float calculaPreuExcursio(float preuExcursioBase) {
        return preuExcursioBase - (preuExcursioBase * (descompteExcursio/100));
    }
    
    /**
     * Calcular la quota mensual del soci.
     * @param quotaBase quota mensual base del club.
     * @return float amb la quota mensual d'aquest soci.
     */
    public float calculaQuota(float quotaBase){
        return quotaBase - (quotaBase * (descompteQuota/100));
    }
    
    /**
     * 
     * @return String amb la informació d'un soci federat més la informació
     * de la seva federació.
     */
    @Override
    public String toString(){
        return "Nom = " + this.getNom() + ", DNI = " + this.getDNI() + "." +
                federacio.toString();
    }
}
