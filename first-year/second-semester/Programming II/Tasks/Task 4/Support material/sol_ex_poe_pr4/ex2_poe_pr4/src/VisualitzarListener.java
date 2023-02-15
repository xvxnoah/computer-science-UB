
import java.awt.event.MouseEvent;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author dortiz
 */
public class VisualitzarListener implements java.awt.event.MouseListener {
    
    private Main main;
    
    public VisualitzarListener(Main main){
        this.main = main;
    }

    @Override
    public void mouseClicked(MouseEvent e) {
        main.mostrarLlistatProductes();
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
