/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author dortiz
 */
public class Cadira extends Producte {
    private String marca;
    
    public Cadira(String nom, String descripcio, String marca){
        super(nom, descripcio);
        this.marca = marca;
    }
    
    @Override
    public String toString(){
        return super.toString() + " ; Marca: " + marca;
    }
}
