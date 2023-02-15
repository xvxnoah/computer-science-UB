package despres2;

public class Client2 {
    public static void main(String[] args){
        System.out.println("OUTPUT DESPRES2:");
        String moneda = "euros";

        CalculadoraStrategy str = new VolInternacionalStrategy();
        //obligo a inicialitzar el context amb una Strategy per assegurar-me que sempre podré fer el càlcul
        //però puc canviar l'estratègia sempre que vulgui amb el setStrategy
        Calculadora calculadora = new Calculadora(str, moneda);

        System.out.println("Preu final vol 100 € internacional: " +
                calculadora.calcularPreuVolAmbMoneda(100));

        CalculadoraStrategy str2 = new VolIllesStrategy();
        calculadora.setStrategy(str2);
        System.out.println("Preu final vol 100 € Mallorca - Barcelona: " +
                calculadora.calcularPreuVolAmbMoneda(100));

        CalculadoraStrategy str3 = new VolNacionalStrategy();
        calculadora.setStrategy(str3);
        System.out.println("Preu final vol 100 € Barcelona - Madrid: " +
                calculadora.calcularPreuVolAmbMoneda(100));

    }
}
