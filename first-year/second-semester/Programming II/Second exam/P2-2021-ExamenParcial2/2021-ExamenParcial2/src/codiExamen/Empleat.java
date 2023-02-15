package codiExamen;

import java.util.ArrayList;
import java.util.Iterator;

public abstract class Empleat {

    private String nom, NIF;
    private ArrayList<HorariDiari> horariDiari;

    public Empleat(String nom, String NIF) {
        this.nom = nom;
        this.NIF = NIF;
        horariDiari = new ArrayList();
    }

    private HorariDiari getHorariDiari(Data data) throws ClinicaException {
        if (data.isBefore(Data.getData())) {
            throw new ClinicaException("La data passada no és correcte.");
        }

        Iterator<HorariDiari> itr = horariDiari.iterator();
        HorariDiari horari;

        while (itr.hasNext()) {
            horari = itr.next();

            if (horari.getDia().isSameDate(data)) {
                return itr.next();
            } else {
                itr.next();
            }
        }
        return null;
    }

    public void afegirVisita(Animal an, int numVisita, Data data) throws ClinicaException {
        Iterator<HorariDiari> itr = horariDiari.iterator();
        HorariDiari horari = getHorariDiari(data);
        
        if(horari == null){
            HorariDiari nouHorari = new HorariDiari(data);
            nouHorari.afegirVisita(an, numVisita);
            horariDiari.add(nouHorari);
        } else{
            throw new ClinicaException("No existeix horari per la data passada");
        }
    }

    @Override
    public String toString() {
        if (horariDiari.isEmpty()) {
            return "- L'empleat " + nom + " amb Nif: " + NIF + " te la següent agenda: Agenda buida";
        } else {
            for(Iterator<HorariDiari> itr = horariDiari.iterator(); itr.hasNext();){
                HorariDiari horari = itr.next();
                return "- L'empleat " + nom + " amb Nif: " + NIF + " te la següent agenda: " + horari.toString();
            }
            return "";
        }
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getNIF() {
        return NIF;
    }

    public void setNIF(String NIF) {
        this.NIF = NIF;
    }

    public ArrayList<HorariDiari> getHorariDiari() {
        return horariDiari;
    }

    public void setHorariDiari(ArrayList<HorariDiari> horariDiari) {
        this.horariDiari = horariDiari;
    }

}
