/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package codiExamen;

import java.util.ArrayList;
import java.util.Iterator;

/**
 *
 * @author lauraigual
 */
public class HorariDiari{
    private ArrayList<Animal> animals;
    private boolean [] visitesOcupades;
    private Data dia;
       
    public HorariDiari(Data dia){
        animals = new ArrayList<Animal>();
        int tamany=6;
        visitesOcupades = new boolean[tamany];
        this.dia=dia;
    }
    
    public void afegirVisita(Animal an, int numVisita){   
        visitesOcupades[numVisita-1]=true;
        animals.add(an);
    }
     
    public ArrayList<Animal> getAnimals(){
        return animals;
    }
    
    public void setAnimals(ArrayList<Animal> animals){
        this.animals=animals;
    }
    
    public boolean [] getVisitesOcupades(){
        return visitesOcupades;
    }
    
    public void setVisitesOcupades(boolean [] visitesOcupades){
        this.visitesOcupades=visitesOcupades;
    }
     
    public Data getDia(){
        return dia;
    }
    
    public void setDia(Data dia){
        this.dia=dia;
    }
    
    @Override
    public String toString(){        
        String str = "";
        str +=  "\n Les visites pel dia " + dia + " són dels següents animals: \n"; 
          
        Iterator<Animal> itr= animals.iterator();
        while(itr.hasNext()){                        
            str += itr.next() + "\n";         
        }    
        return str;
    }
}
