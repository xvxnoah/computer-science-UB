
import java.awt.event.MouseEvent;
import javax.swing.JOptionPane;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author dortiz
 */
public class AfegirListener implements java.awt.event.MouseListener {
    
    private Main main;
    
    public AfegirListener(Main main){
        this.main = main;
    }

    @Override
    public void mouseClicked(MouseEvent e) {
        if(main.isBtnAfegirBicicleta(e.getSource())){
            main.afegirProducte(new Bicicleta("Bicicleta","blava cadira","IKEA"));
            JOptionPane.showMessageDialog(main, "Bicicleta afegida");
        }
        else if(main.isBtnAfegirCadira(e.getSource())){
            main.afegirProducte(new Cadira("Cadira","blanca bicicleta","BH"));
            JOptionPane.showMessageDialog(main, "Cadira afegida");
        }
        else{
            System.out.println("Error");
        }

    }

    @Override
    public void mousePressed(MouseEvent e) {
    }

    @Override
    public void mouseReleased(MouseEvent e) {
    }

    @Override
    public void mouseEntered(MouseEvent e) {
    }

    @Override
    public void mouseExited(MouseEvent e) {
    }
}
