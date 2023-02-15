/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package prog2.model;

import java.io.Serializable;
import java.util.ArrayList;
import prog2.vista.MercatException;

public class Llista<T> implements Serializable {
   protected ArrayList<T> llista;

   public Llista() {        
       llista = new ArrayList<>();
    }

    public int getSize() {
          // TO-BE-DONE
    }

    public void afegir(T t) throws MercatException {
          // TO-BE-DONE
    }

    public void esborrar(T t) {
          // TO-BE-DONE
    }
    
    public T getAt(int position) {
          // TO-BE-DONE
    }

    public void clear() {
          // TO-BE-DONE
    }
    
    public boolean isEmpty() {
          // TO-BE-DONE
    }

    public ArrayList<T> getArrayList() {
        ArrayList<T> arrlist = new ArrayList<>(llista);
        return arrlist;
    }
}
