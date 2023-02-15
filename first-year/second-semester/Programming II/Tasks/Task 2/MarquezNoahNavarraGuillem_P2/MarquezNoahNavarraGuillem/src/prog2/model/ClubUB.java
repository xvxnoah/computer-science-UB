package prog2.model;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;

import prog2.vista.ExcepcioClub;

public class ClubUB implements Serializable {

    /* Atributs */
    private static final float PREU_EXCURSIO = 20;
    private static final float QUOTA_MENSUAL = 25;
    private static final float DESCOMPTE_PREU_EXCURSIO = 20.0f;
    private static final float DESCOMPTE_QUOTA_MENSUAL = 30.0f;
    private LlistaSocis _llistaSocis;

    /**
     * Constructor sense paràmetres de la classe ClubUB. Inicialitza l'ArrayList
     * de socis.
     */
    public ClubUB() {
        _llistaSocis = new LlistaSocis();
    }

    /**
     * Retorna la llista de socis.
     * @return llista, String amb la llista de socis o amb el missatge:
     * "La llista no conté cap soci"
     */
    public String getLlistaSocis() {
        String llista = "La llista no conté cap soci.\n";

        if (!llistaBuida()) {
            llista = _llistaSocis.toString();
        }

        return llista;
    }

    /**
     * Ens diu si la llista està buida.
     * @return true si la llista està buida, false altrament.
     */
    public boolean llistaBuida() {
        return _llistaSocis.isEmpty();
    }

    /**
     * Ens diu si la llista està plena.
     * @return true si la llista està plena, false altrament.
     */
    public boolean llistaPlena(){
        return _llistaSocis.isFull();
    }
    /**
     *  Elimina un soci en la posició introduïda per l'usuari.
     * @param pos, posicio del soci a eliminar.
     * @throws ExcepcioClub si la posició és incorrecte.
     */
    public void removeSoci(int pos) throws ExcepcioClub {
        if (pos <= 0 || pos > _llistaSocis.getSize()) {
            throw new ExcepcioClub("Posició no vàlida!");
        }

        Soci sociBorrar = null;
        if (pos > 0) {
            sociBorrar = _llistaSocis.getAt(pos - 1);
        }

        _llistaSocis.removeSoci(sociBorrar);
    }

    /**
     * Calcula la factura d'un soci donat el seu DNI i el nombre d'excursions que
     * ha realitzat en un mes.
     * @param dni, dni del soci
     * @param nombreExcursions, nombre d'excursions realitzades en un mes.
     * @return importFactura, float amb l'import total a pagar pel soci.
     * @throws ExcepcioClub si el nombre d'excursions és més gran que el número
     * de dies en un mes, o si no es troba cap soci amb el dni introduït.
     */
    public float calcularFactura(String dni, int nombreExcursions) throws ExcepcioClub {
        if (nombreExcursions > 31) {
            throw new ExcepcioClub("Només es pot fer una esxcursió per dia (31 dies).");
        }

        float importFactura = 0;
        Soci soci = _llistaSocis.getSoci(dni);

        float preu = soci.calculaPreuExcursio(PREU_EXCURSIO);
        importFactura = (soci.calculaQuota(QUOTA_MENSUAL) + (nombreExcursions * preu));

        return importFactura;
    }

    /**
     * Afegeix un objecte de tipus SociFederat.
     * @param nom, nom del soci.
     * @param dni, dni del soci.
     * @param nomFederacio, nom de la federació.
     * @param preu, preu de la federació.
     * @throws ExcepcioClub si la llista està plena o bé si ja existeix un soci
     * amb el mateix dni introduït.
     */
    public void afegirSociFederat(String nom, String dni, String nomFederacio, float preu) throws ExcepcioClub {
        SociFederat nouSoci = null;

        Federacio federacio = new Federacio(nomFederacio, preu);
        float descompteQuota = DESCOMPTE_QUOTA_MENSUAL;
        float descompteExcursio = DESCOMPTE_PREU_EXCURSIO;

        nouSoci = new SociFederat(nom, dni, federacio, descompteQuota, descompteExcursio);

        _llistaSocis.addSoci(nouSoci);
    }

    /**
     * Afegeix un objecte de tipus SociEstandard
     * @param nom, nom del soci.
     * @param dni, dni del soci.
     * @param tipus, tipus d'assegurança.
     * @param preu, preu de l'assegurança.
     * @throws ExcepcioClub si la llista està plena o bé si ja existeix un soci
     * amb el mateix dni introduït.
     */
    public void afegirSociEstandard(String nom, String dni, String tipus, float preu) throws ExcepcioClub {
        SociEstandard nouSoci = null;

        Asseguranca asse = new Asseguranca(tipus, preu);

        nouSoci = new SociEstandard(nom, dni, asse);

        _llistaSocis.addSoci(nouSoci);
    }

    /**
     * Afegeix un objecte de tipus SociJunior.
     * @param nom, nom del soci.
     * @param dni, dni del soci.
     * @throws ExcepcioClub si la llista està plena o bé si ja existeix un soci
     * amb el mateix dni introduït.
     */
    public void afegirSociJunior(String nom, String dni) throws ExcepcioClub {
        SociJunior nouSoci = new SociJunior(nom, dni);

        _llistaSocis.addSoci(nouSoci);
    }

    /**
     * Modifica el nom d'un soci donat el seu DNI.
     * @param dni, dni del soci a modificar
     * @param nouNom, nou nom del soci
     * @throws ExcepcioClub si no existeix cap soci amb el dni introduït.
     */
    public void modificaNom(String dni, String nouNom) throws ExcepcioClub {
        Soci soci = _llistaSocis.getSoci(dni);
        soci.setNom(nouNom);
    }

    /**
     * Modifica el tipus d'assegurança d'un soci estàndard donat el seu DNI.
     * @param dni, dni del soci a modificar l'assegurança
     * @param nouTipus, nou tipus d'assegurança
     * @throws ExcepcioClub si no existeix cap soci amb el dni introduït o bé
     * si el soci amb aquest dni no és de tipus SociEstandard.
     */
    public void modificaAsseguranca(String dni, String nouTipus) throws ExcepcioClub {
        Soci soci = _llistaSocis.getSoci(dni);
        if (soci instanceof SociEstandard) {
            SociEstandard soci2 = (SociEstandard) soci;
            Asseguranca novaAsse = soci2.getAsseguranca();
            novaAsse.setTipus(nouTipus);
        } else {
            throw new ExcepcioClub("Aquest soci no té assegurança!");
        }
    }

    /**
     * Mètode static de classe per càrregar la informació del club des d'un fitxer.
     * @param origen, ruta d'origen del fitxer a carregar
     * @return club, objecte de tipus ClubUB
     * @throws ExcepcioClub diferents tipus d'excepció especificats abaix.
     */
    public static ClubUB load(String origen) throws ExcepcioClub {
        if (origen == null) {
            throw new ExcepcioClub("Origen de fitxer incorrecte");
        }

        File origenFitxer = new File(origen);
        if (!origenFitxer.exists()) {
            throw new ExcepcioClub("Fitxer destí no existeix");
        }

        ClubUB club = null;

        FileInputStream fin = null;
        ObjectInputStream ois = null;

        try {
            fin = new FileInputStream(origenFitxer);

            ois = new ObjectInputStream(fin);
            club = (ClubUB) ois.readObject();
        } catch (ClassNotFoundException ex) {
            throw new ExcepcioClub("No es pot castejar a objecte tipus ClubUB.");
        } catch (FileNotFoundException ex) {
            throw new ExcepcioClub("Fitxer no trobat.");
        } catch (IOException ex) {
            throw new ExcepcioClub("Problema de lectura.");
        } finally {
            try {
                fin.close();
            } catch (IOException ex) {
                throw new ExcepcioClub("No es pot tancar fitxer.");
            }
            try {
                ois.close();
            } catch (IOException ex) {
                throw new ExcepcioClub("No es pot tancar sortida.");
            }
        }
        return club;
    }

    /**
     * Mètode per guardar la informació del club.
     * @param fileName, ruta i nom on guardar el fitxer, de l'estil: "./llista.dat".
     * @throws ExcepcioClub diferents tipus d'excepció especificats més abaix.
     */
    public void save(String fileName) throws ExcepcioClub {
        File file = new File(fileName);
        FileOutputStream fout = null;

        try {
            fout = new FileOutputStream(file);

            ObjectOutputStream oos = new ObjectOutputStream(fout);

            oos.writeObject(this);
        } catch (FileNotFoundException ex) {
            throw new ExcepcioClub("Fitxer no trobat.");
        } catch (IOException ex) {
            throw new ExcepcioClub("Problema d'escriptura.");
        } finally {
            try {
                fout.close();
            } catch (IOException ex) {
                throw new ExcepcioClub("No es pot tancar fitxer.");
            }
        }
    }
}
