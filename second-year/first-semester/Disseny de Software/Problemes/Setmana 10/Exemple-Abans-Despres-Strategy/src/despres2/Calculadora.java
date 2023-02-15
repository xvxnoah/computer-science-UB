package despres2;

public class Calculadora {
    private CalculadoraStrategy strategy;
    private String moneda;

    //demano en el constructor un strategy inicial per assegurar-me que sempre tindré un strategy per fer el càlcul
    //si es vol canviar d'estratègia es pot fer a través del setStrategy, sense necessitat de crear una nova instància
    public Calculadora(CalculadoraStrategy strategy, String moneda) {
        this.strategy = strategy;
        this.moneda = moneda;
    }

    public void setStrategy(CalculadoraStrategy strategy) {
        this.strategy = strategy;
    }

    public String calcularPreuVolAmbMoneda(double preuVolSenseDescompte){
        return strategy.calcularPreuVol(preuVolSenseDescompte) + moneda;
    }
}
