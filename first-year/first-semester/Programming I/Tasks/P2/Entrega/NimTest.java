import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
/**
 *
 * @author Noah Márquez
 */

public class NimTest {

    @Test
    public void testtiradaOrdinador() {
        int maxAleatoriInt = 2;
        int minAleatoriInt = 1;
        int result = Nim.tiradaOrdinador();
        assertTrue(result <= maxAleatoriInt, "El random es demasiado grande");
        assertTrue(result >= minAleatoriInt, "El random es demasiado pequeño");
    }

}  