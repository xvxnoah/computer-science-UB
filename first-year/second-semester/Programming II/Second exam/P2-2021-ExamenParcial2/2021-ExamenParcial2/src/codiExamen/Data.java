/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package codiExamen;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author lauraigual
 */
public class Data {
      /**
     * Atribut de la classe
     * Ens servirà per accedir al temps de la data en milisegons.
     */
    Calendar cal;
           
    /**
     * Constructor de la classe 
     * que es crida des del mètode de classe getData().
     */
    public Data(){
        cal = Calendar.getInstance();
    } 
    
     /**
     * Constructor de la classe passant-li una data en el següent format de string:
     * "MM/dd/yy" MM=mes, dd=dia, YY=any.
     * que es crida des del mètode de classe getData(String ).
     */
    public Data(String data){
        DateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");

        cal = Calendar.getInstance();
        try {
            cal.setTime(formatter.parse(data));
        } catch (ParseException ex) {
            Logger.getLogger(Data.class.getName()).log(Level.SEVERE, null, ex);
        }
    } 
        
    /**
     * Crea una nova instància d'aquesta classe amb la data actual.
     * @return instància de Data amb la data actual.
     */
    public static Data getData(){
        Data dia = new Data();
        return dia;
    }
    
    /**
     * Crea una nova instància d'aquesta classe amb la data donada.
     * @return instància de Data amb la data actual.
     */
    public static Data getData(String data){
        Data dia= new Data(data);
        return dia;
    }

    /**
     * Mètode que comprova si la data de l'objecte és la mateixa que la data passada.
     * @param data correpon a la Data a la que ens comparem.
     * @return true si la data és la mateixa, false sinó.
     */
    public boolean isSameDate(Data data){   
 
        Calendar cal1=this.cal;
        Calendar cal2=data.getCal();
        if (cal1 == null || cal2 == null)
            return false;
        boolean sameDay = cal1.get(Calendar.YEAR) == cal2.get(Calendar.YEAR) &&
                  cal1.get(Calendar.DAY_OF_YEAR) == cal2.get(Calendar.DAY_OF_YEAR);
        return sameDay;
    }
    
    
        
    /**
     * Mètode que comprova si la data de l'objecte és anterior a la data passada
     * @param limit correpon a la Data a la que ens comparem.
     * @return true si la data de l'objecte és anterior a limit, false sinó.
     */
    public boolean isBefore(Data limit){   
 
        Calendar cal1=this.cal;
        Calendar cal2=limit.getCal();
        if (cal1 == null || cal2 == null)
            return false;
        boolean previous = cal1.get(Calendar.YEAR) < cal2.get(Calendar.YEAR) &&
                  cal1.get(Calendar.DAY_OF_YEAR) < cal2.get(Calendar.DAY_OF_YEAR);
        return previous;
    }
    
    /**
     * Mètode que retorna l'atribut de tipus Calendari
     * @return el calendari d'aquesta data.
     */   
    public Calendar getCal(){
        return cal;        
    }
    
    /**
     * Mètode per mostrar la data en un format simple.
     * @return String per poder imprimir per pantalla la data.
     */
    @Override
    public String toString(){
        DateFormat dateFormat= new SimpleDateFormat("dd/MM/yyyy");
        String str = "";
        str +=  dateFormat.format(cal.getTime()); 
        //2014/08/06 
        return str;

    }  
}
