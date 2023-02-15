package prog2.model;

import prog2.vista.ExcepcioClub;

/**
 * Interfície InSoci
 */
public interface InSoci {
    
    /**
     *
     * @param nom .
     */
    public void setNom(String nom);

    /**
     *
     * @return nom .
     */
    public String getNom();

    /**
     *
     * @param dni .
     */
    public void setDNI(String dni);

    /**
     *
     * @return DNI .
     */
    public String getDNI();
    
    /**
     * Calcular la quota mensual del soci
     * @param quotaBase quota mensual base del club.
     * @return float amb la quota mensual d'aquest soci.
     * @throws ExcepcioClub .
     */
    public float calculaQuota(float quotaBase) throws ExcepcioClub;
    
    /**
     * Calcular el preu de les excursions del soci
     * @param preuExcursioBase preu de les excursions del club.
     * @return float amb el preu de les excursions d'aquest soci.
     * @throws ExcepcioClub .
     */
    public abstract float calculaPreuExcursio(float preuExcursioBase) throws ExcepcioClub;
}
