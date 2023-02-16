package despres1;

public abstract class CalculadoraPreuVol {
    private String moneda;

    public CalculadoraPreuVol(String moneda) {
        this.moneda = moneda;
    }

    public String getMoneda() {
        return moneda;
    }

    public abstract String calcularVol(double preuVolSenseDesc);
}
