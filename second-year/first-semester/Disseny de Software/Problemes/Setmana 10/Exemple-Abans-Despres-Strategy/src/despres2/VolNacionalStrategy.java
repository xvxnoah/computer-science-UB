package despres2;

public class VolNacionalStrategy implements CalculadoraStrategy{
    @Override
    public String calcularPreuVol(double preuVolSenseDesc) {
        return String.valueOf(preuVolSenseDesc * (1-0.05));
    }
}
