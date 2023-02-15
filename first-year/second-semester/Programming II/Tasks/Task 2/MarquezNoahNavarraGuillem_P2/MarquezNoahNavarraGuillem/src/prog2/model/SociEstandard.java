package prog2.model;

import java.io.Serializable;
import prog2.vista.ExcepcioClub;

public class SociEstandard extends Soci implements Serializable{
    /* Atributs */
    private Asseguranca asseguranca;
    
    /**
     * Constrtuctor per paràmetres de la classe SociEstandard.
     * @param _nom, nom del soci.
     * @param _dni, dni del soci.
     * @param asseguranca, objecte de tipus Asseguranca.
     * @throws ExcepcioClub si el tipus d'assegurança és incorrecte.
     */
    public SociEstandard(String _nom, String _dni, Asseguranca asseguranca) throws ExcepcioClub{
        super(_nom, _dni);
        this.asseguranca = asseguranca;
        if(!comprova(asseguranca.getTipus())) throw new ExcepcioClub("El tipus d'assegurança no és correcte.");
    }
    
    /**
     *
     * @return asseguranca, objecte de tipus Asseguranca.
     */
    public Asseguranca getAsseguranca() {
        return asseguranca;
    }

    /**
     *
     * @param asseguranca, objecte de tipus Asseguranca.
     */
    public void setAsseguranca(Asseguranca asseguranca) {
        this.asseguranca = asseguranca;
    }
    
    /**
     * Mètode per comprovar si el tipus d'assegurança és correcte.
     * @param tipus, tipus introduït oper l'usuari.
     * @return true si es correcte, false altrament.
     */
    public boolean comprova(String tipus){
        return tipus.equals("Bàsica") || tipus.equals("Completa");
    }
 
    /**
     * Calcular el preu de les excursions del soci.
     * @param preuExcursioBase preu de les excursions del club.
     * @return float amb el preu de les excursions d'aquest soci.
     */
    @Override
    public float calculaPreuExcursio(float preuExcursioBase){
        return (preuExcursioBase + asseguranca.getPreu());
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
     * @return String amb la informació d'un sociEstandard juntament amb la informació
     * de la seva assegurança.
     */
    @Override
    public String toString(){
        return "Nom = " + this.getNom() + ", DNI = " + this.getDNI() + "." +
                asseguranca.toString();
    }
}
