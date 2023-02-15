/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author dortiz
 */
public class Bicicleta extends Producte {
    private String model;
    
    public Bicicleta(String nom, String descripcio, String model){
        super(nom, descripcio);
        this.model = model;
    }
    
    @Override
    public String toString(){
        return super.toString() + "; Model: " + model;
    }
}
