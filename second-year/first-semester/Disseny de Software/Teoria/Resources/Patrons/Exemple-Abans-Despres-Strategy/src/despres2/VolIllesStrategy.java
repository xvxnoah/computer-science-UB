package despres2;

public class VolIllesStrategy implements CalculadoraStrategy{
    @Override
    public String calcularPreuVol(double preuVolSenseDesc) {
        return String.valueOf(preuVolSenseDesc * (1-0.75));
    }
}
