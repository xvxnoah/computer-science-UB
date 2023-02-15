package prog2.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Iterator;
import prog2.vista.ExcepcioClub;

public class LlistaSocis implements InSociList, Serializable{

    /*Atributs*/
    //inicialitzem a -1 perquè el mètode isFull funcioni en el cas que no fem
    //servir la variable mida (com és el nostre cas)
    int mida = -1; 
    private static final int MIDA_MAXIMA = 100;
    private ArrayList<Soci> llista;

    /**
     * Constructor sense paràmetres de la classe LlistaSocis on inicialitzem un
     * ArrayList anomenat llista on guardarem els socis.
     *
     */
    public LlistaSocis() {
        this.llista = new ArrayList<>();
    }
    
    /**
     * Constructor per paràmetres amb el que donarem l'opció a l'usuari d'introduir
     * una mida màxima per l'ArrayList.
     * @param mida, mida màxima de la llista.
     */
    public LlistaSocis(int mida){
        this.llista = new ArrayList<>();
        this.mida = mida;
    }

    /**
     * Donar el número d'elemnts que hi ha actualment emmagatzemants a la llista.
     * @return int amb el número d'elements de la llista.
     */
    @Override
    public int getSize() {
        return this.llista.size();
    }

    /**
     * Afegir un nou soci
     * @param soci objecte per afegir a la llista.
     * @throws prog2.vista.ExcepcioClub si la llista està plena o si el soci ja
     * es troba a la llista.
     */
    @Override
    public void addSoci(Soci soci) throws ExcepcioClub {
        if (isEmpty()) {
            llista.add(soci);
        } else if (isFull()) {
            throw new ExcepcioClub("La llista está plena!");
        } else {
            Iterator<Soci> it = llista.iterator();
            boolean flag = false;

            while (it.hasNext() && !flag) {
                Soci s = it.next();
                if (s.equals(soci)) {
                    flag = true;
                }
            }
            if (!flag) {
                llista.add(soci);
            } else {
                throw new ExcepcioClub("Aquest soci ja es troba a la llista");
            }
        }
    }

    /**
     * Eliminar un objecte de la llista
     * @param soci objecte per eliminar
     * @throws prog2.vista.ExcepcioClub si el soci no es troba a la llista.
     */
    @Override
    public void removeSoci(Soci soci) throws ExcepcioClub {
        if (llista.contains(soci)) {
            llista.remove(soci);
        } else {
            throw new ExcepcioClub("Aquest soci no es troba a la llista");
        }
    }

    /**
     * Obtenir el soci guardat a una certa posició donada //CAMBIAR
     * @param position posició a la llista de socis.
     * @return objecte soci a la posició donada. Les excepcions es controlen a
     * la classe ClubUB.
     */
    @Override
    public Soci getAt(int position) throws ExcepcioClub {
        
        return llista.get(position);
    }

    /**
     * Obtenir el soci donat el seu DNI
     * @param dni DNI del soci al que volem accedir.
     * @return Objecte soci amb el dni donat o null (excepció) si no existeix.
     * @throws prog2.vista.ExcepcioClub si la llista està buida o si no s'ha trobat
     * cap soci amb el dni introduït.
     */
    @Override
    public Soci getSoci(String dni) throws ExcepcioClub {
        if(isEmpty()) throw new ExcepcioClub ("La llista està buida.");
        Soci soci = null;
        for (int i = 0; i < llista.size(); i++) {
            if (llista.get(i).getDNI().equals(dni)) {
                soci = llista.get(i);
            }
        }
        if(soci == null) throw new ExcepcioClub("No s'ha trobat cap soci amb el DNI indicat");
        return soci;
    }

    /**
     * Eliminar tots els elements de la llista
     * @throws prog2.vista.ExcepcioClub si la llista està buida.
     */
    @Override
    public void clear() throws ExcepcioClub {
        if (isEmpty()) {
            throw new ExcepcioClub("La llista està buida");
        } else {
            Iterator itr = llista.iterator();
            while (itr.hasNext()) {
                itr.remove();
            }
        }
    }

    /**
     * Comprovar si la llista està a la seva capacitat màxima o no.
     * @return True si la llista està plena (no hi ha lloc per més elements) o
     * false sinó.
     */
    @Override
    public boolean isFull() {
        return this.llista.size() == mida || this.llista.size() == MIDA_MAXIMA;
    }

    /**
     * Comprovar si la llista està buida o no.
     * @return True si la llista està buida (no hi ha cap element) o false
     * sinó.
     */
    @Override
    public boolean isEmpty() {
        return this.llista.isEmpty();
    }

    /**
     * 
     * @return str, String amb la llista de socis.
     */
    @Override
    public String toString() {
        String str = "Llista de Socis:\n";
        str += "==============\n";
        Iterator<Soci> it = llista.iterator();

        for (int i = 0; i < llista.size(); i++) {
            Soci s = it.next();
            str += "[" + (i + 1) + "]  " + s.toString() + "\n";
        }

        return str;
    }
}
