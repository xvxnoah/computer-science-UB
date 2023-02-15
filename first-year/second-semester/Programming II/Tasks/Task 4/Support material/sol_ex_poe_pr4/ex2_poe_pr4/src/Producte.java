/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author dortiz
 */
public class Producte {
    private String nom;
    private String descripcio;
    
    public Producte(String nom, String descripcio){
        this.nom = nom;
        this.descripcio = descripcio;
    }
    
    @Override
    public String toString(){
        return "Nom: " + nom + " ; Descripcio: " + descripcio;
    }
}
