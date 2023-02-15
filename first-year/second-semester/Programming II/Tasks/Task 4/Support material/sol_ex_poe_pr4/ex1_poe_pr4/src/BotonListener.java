
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
public class BotonListener implements java.awt.event.MouseListener {

    private Main main;
    
    public BotonListener(Main main){
        this.main = main;
    }
    
    @Override
    public void mouseClicked(MouseEvent e) {
        if(main.isBtnClickCount(e.getSource())){
            main.setClickCount(main.getClickCount()+1);
            main.refreshClickCount();
        }
        else if(main.isBtnClickBg(e.getSource())){
            main.setBgColor();
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
