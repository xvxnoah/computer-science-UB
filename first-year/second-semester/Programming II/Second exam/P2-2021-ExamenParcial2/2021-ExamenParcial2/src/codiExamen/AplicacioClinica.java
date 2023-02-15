package codiExamen;

import java.awt.BorderLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import javax.swing.BoxLayout;
import javax.swing.DefaultListModel;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextField;

/**
 *
 * @author lauraigual
 */
public class AplicacioClinica {

    JFrame frame;
    JButton btnAfegirVisita;
    JList jlistEmpleats, jlistAnimals, jlistVisites;
    JLabel lbData, lbHora;
    JTextField txtData, txtHora;

    private ArrayList<Empleat> empleats;
    private ArrayList<Animal> animals;

    public static void main(String[] args) {
        AplicacioClinica gui = new AplicacioClinica();
        gui.go();
    }

    /**
     * Mètode principal de la classe.
     */
    public void go() {

        empleats = new ArrayList<Empleat>();
        animals = new ArrayList<Animal>();

        frame = new JFrame("Aplicació gestió clínica veterinaria");

        JPanel panel1 = new JPanel();
        panel1.setLayout(new BoxLayout(panel1, BoxLayout.Y_AXIS));

        jlistEmpleats = new JList();
        JScrollPane scr1 = new JScrollPane(jlistEmpleats);

        jlistAnimals = new JList();
        JScrollPane scr2 = new JScrollPane(jlistAnimals);

        btnAfegirVisita = new JButton("Afegir Visita");
        btnAfegirVisita.addActionListener(new BotoAfegirVisitaEscoltador());

        lbData = new JLabel("Data de la visita:");
        txtData = new JTextField(5);
        lbHora = new JLabel("Hora de la visita (de 1 a 6):");
        txtHora = new JTextField(5);

        panel1.add(scr1);
        panel1.add(scr2);
        panel1.add(lbData);
        panel1.add(txtData);
        panel1.add(lbHora);
        panel1.add(txtHora);
        panel1.add(btnAfegirVisita);

        frame.getContentPane().add(BorderLayout.CENTER, panel1);

        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(900, 500);
        frame.setVisible(true);

        omplirDades();
    }

    /**
     * Una vegada tingueu implementada la classe Empleat podeu descomentar
     * aquest mètode per tal d'omplir la llista d'animals i d'empleats.
     */
    private void omplirDades() {

        String id = "12345X";
        String especie = "Gat";
        String descripcioMalaltia = "Conjuntivitis";

        Animal animal1 = new Animal(id, especie, descripcioMalaltia);

        id = "12345Z";
        especie = "Gos";
        descripcioMalaltia = "Hepatitis";

        Animal animal2 = new Animal(id, especie, descripcioMalaltia);

        animals.add(animal1);
        animals.add(animal2);

        Empleat veterinari1 = new Veterinari("Pere Andreu", "12345678E");
        Empleat veterinari2 = new Veterinari("Berta Andreu", "19022441P");
        Empleat Veterinari3 = new Veterinari("Joan Garcia", "70012300N");

        empleats.add(veterinari1);
        empleats.add(veterinari2);
        empleats.add(Veterinari3);

        omplirLlistaEmpleats();
        omplirLlistaAnimals();

    }

    /**
     * Mètode per omplir la JList amb la llista d'empleats.
     */
    void omplirLlistaEmpleats() {
        DefaultListModel model = new DefaultListModel();
        for (Empleat item : empleats) {
            model.addElement(item);
        }
        jlistEmpleats.setModel(model);

    }

    /**
     * Mètode per omplir la JList amb la llista d'animals.
     */
    void omplirLlistaAnimals() {
        DefaultListModel model = new DefaultListModel();
        for (Animal item : animals) {
            model.addElement(item);
        }
        jlistAnimals.setModel(model);

    }

    class BotoAfegirVisitaEscoltador implements ActionListener {

        public void actionPerformed(ActionEvent ev) {
            btnAfegirVisitaActionPerformed();
        }
    }

    private void btnAfegirVisitaActionPerformed() {
        Empleat empleat = empleats.get(jlistEmpleats.getSelectedIndex());
        Animal animal = animals.get(jlistAnimals.getSelectedIndex());
        Data data = new Data(txtData.getText());
        int horaVisita = Integer.parseInt(txtHora.getText());

        try {
            empleat.afegirVisita(animal, horaVisita, data);
            
        } catch (ClinicaException ex) {
            JOptionPane.showMessageDialog(jlistEmpleats, ex.getMessage(), "CLINICA EXCEPTION!", JOptionPane.ERROR_MESSAGE);
        }
        omplirLlistaEmpleats();
    }

    /**
     * **************************************
     */
    /*PREGUNTES A CONTESTAR*/
 /*
    a) Indiqueu quin són els LayoutManagers que es fan servir:
        -BoxLayout
        -BorderLayout
    
    b) Indiqueu quines components es fan servir:
        -JFrame   
        -JButton
        -JList
        -JLabel
        -JTextField
        -JPanel
        -JScrollPane
        -JOptionPane
     */
}
