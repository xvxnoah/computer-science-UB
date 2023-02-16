package despres1;

public class Client1 {
    public static void main(String[] args){
        System.out.println("OUTPUT DESPRES1:");
        String moneda = "euros";
        CalculadoraPreuVol calculadora;

        calculadora = new VolInternacionalCalculator(moneda);

        System.out.println("Preu final vol 100 € internacional: " + calculadora.calcularVol(100));

        calculadora = new VolIllesCalculator(moneda);

        System.out.println("Preu final vol 100 € Mallorca - Barcelona: " + calculadora.calcularVol(100));

        calculadora = new VolNacionalCalculator(moneda);

        System.out.println("Preu final vol 100 € Barcelona - Madrid: " + calculadora.calcularVol(100));


    }
}
