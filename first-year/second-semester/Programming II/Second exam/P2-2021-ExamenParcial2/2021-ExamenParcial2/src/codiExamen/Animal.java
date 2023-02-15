/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package codiExamen;

/**
 *
 * @author lauraigual
 */
public class Animal{
    private String id;
    private String especie;
    private String descripcioMalaltia;
    
    public Animal(String id, String especie, String descripcioMalaltia){
        this.id = id;
        this.especie = especie;
        this.descripcioMalaltia = descripcioMalaltia; 
    }
           
    public String getID(){
        return id;
    }
    
    public void setDia(String id){
        this.id=id;
    }
      
    public String getEspecie(){
        return especie;
    }
    
    public void setEspecie(String especie){
        this.especie=especie;
    }
         
    public String getDescripcioMalaltia(){
        return descripcioMalaltia;
    }
    
    public void setDescripcioMalaltia(String descripcioMalaltia){
        this.descripcioMalaltia=descripcioMalaltia;
    }
    
    @Override
    public String toString(){        
        String str = "";
        str +=  "L'animal amb ID " + getID() +" de l'especie: " + getEspecie() + " amb la següent malaltia: " + getDescripcioMalaltia(); 
    
        return str;
    }
    
}
