package prog2.model;

import java.io.Serializable;

public abstract class Soci implements InSoci, Serializable {
    /* Atributs */
    private String nomSoci;
    private String DNI;
    
    /**
     * Constructor per paràmetres de la classe Soci.
     * @param nom, nom del soci
     * @param dni, dni del soci
     */
    public Soci(String nom, String dni){
        nomSoci = nom;
        DNI = dni;
    }
    
    /**
     * Calcular el preu de les excursions del soci
     * @param preuExcursioBase preu de les excursions del club.
     * @return float amb el preu de les excursions d'aquest soci.
     */
    @Override
    public abstract float calculaPreuExcursio(float preuExcursioBase);
    
    /**
     * 
     * @param nom, nom del soci.
     */
    @Override
    public void setNom(String nom) {
        nomSoci = nom;
    }
    
    /**
     * 
     * @return nomSoci, nom del soci.
     */
    @Override
    public String getNom() {
        return nomSoci;
    }

    /**
     * 
     * @param dni, dni del soci.
     */
    @Override
    public void setDNI(String dni) {
        DNI = dni;
    }
    
    /**
     * 
     * @return DNI, dni del soci.
     */
    @Override
    public String getDNI() {
        return DNI;
    }
    
    /**
     * Calcular la quota mensual del soci
     * @param quotaBase quota mensual base del club.
     * @return float amb la quota mensual d'aquest soci.
     */
    @Override
    public float calculaQuota(float quotaBase){
        return quotaBase;
    }
    
    /**
     * Mètode per comprovar si el soci passat per paràmetres i el soci actual tenen
     * el mateix dni.
     * @param soci, objecte de tipus Soci
     * @return true si tenen el mateix dni, false altrament.
     */
    public boolean equals(Soci soci){
        return soci.getDNI().equals(this.DNI);
    }
    
    /**
     * 
     * @return String amb l'informació de cada tipus de soci. 
     */
    @Override
    public String toString(){
        return this.toString();
    }
}
