package abans;

public class CalculadoraPreuVol {
    private String moneda;

    public CalculadoraPreuVol(String moneda) {
        this.moneda = moneda;
    }

    public String calcularVolInternacional(double preuVolSenseDesc){
        return preuVolSenseDesc + moneda;
    }

    public String calcularVolIlles(double preuVolSenseDesc){
        return preuVolSenseDesc * (1-0.75) + moneda;
    }

    public String calcularVolNacionalNoResident(double preuVolSenseDesc){
        return preuVolSenseDesc * (1-0.05) + moneda;
    }
}
