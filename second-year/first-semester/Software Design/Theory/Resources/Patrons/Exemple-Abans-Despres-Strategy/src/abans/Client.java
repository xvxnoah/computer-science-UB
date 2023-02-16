package abans;

public class Client {
    public static void main(String[] args){
        System.out.println("OUTPUT ABANS:");
        String moneda = "euros";
        CalculadoraPreuVol calculadora = new CalculadoraPreuVol(moneda);

        System.out.println("Preu final vol 100 € internacional: " + calculadora.calcularVolInternacional(100));

        System.out.println("Preu final vol 100 € Mallorca - Barcelona: " + calculadora.calcularVolIlles(100));

        System.out.println("Preu final vol 100 € Barcelona - Madrid: " + calculadora.calcularVolNacionalNoResident(100));


    }
}
