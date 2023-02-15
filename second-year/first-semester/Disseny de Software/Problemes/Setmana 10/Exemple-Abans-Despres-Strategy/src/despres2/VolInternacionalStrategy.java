package despres2;

public class VolInternacionalStrategy implements CalculadoraStrategy{
    @Override
    public String calcularPreuVol(double preuVolSenseDesc) {
        return String.valueOf(preuVolSenseDesc);
    }
}
