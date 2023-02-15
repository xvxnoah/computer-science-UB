package prog2.model;

import java.io.Serializable;

public class SociJunior extends Soci implements Serializable{

    /**
     * Constructor per paràmetres de la classe SociJunior.
     * @param _nom, nom del soci.
     * @param _dni, dni del soci.
     */
    public SociJunior(String _nom, String _dni){
        super(_nom, _dni);
    }
    
    /**
     * Calcular el preu de les excursions del soci.
     * @param preuExcursioBase preu de les excursions del club.
     * @return float amb el preu de les excursions d'aquest soci.
     */
    @Override
    public float calculaPreuExcursio(float preuExcursioBase) {
        return 0; 
    }
    
    /**
     * Calcular la quota mensual del soci.
     * @param quotaBase quota mensual base del club.
     * @return float amb la quota mensual d'aquest soci.
     */
    public float calculaQuota(float quotaBase){
        return quotaBase;
    }
    
    /**
     * 
     * @return String amb la informació d'un soci estàndard.
     */
    @Override
    public String toString(){
       return "Nom = " + this.getNom() + ", DNI = " + this.getDNI() + ".";
    }
}
