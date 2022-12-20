import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 *
 * @author Noah Márquez
 */
public class JocDelPenjatTest {
    
    /**
     * Test of lletraEncertada method, of class JocDelPenjat.
     */
    @Test
    public void testLletraEncertada() {
        System.out.println("lletraEncertada");
        String paraulaEsbrinar = "POMA";
        int pos = 0;
        char c = 'P';
        boolean[] lletresEncertades = new boolean[10];
        boolean expResult = true;
        boolean result = JocDelPenjat.lletraEncertada(paraulaEsbrinar, pos, c, lletresEncertades);
        assertEquals(expResult, result);
    }

    /**
     * Test of mostraParaula method, of class JocDelPenjat.
     */
    @Test
    public void testMostraParaula() {
        System.out.println("mostraParaula");
        String paraulaEsbrinar = "POMA";
        boolean[] lletresEncertades = new boolean[4];
        String expResult = "????";
        String result = JocDelPenjat.mostraParaula(paraulaEsbrinar, lletresEncertades);
        assertEquals(expResult, result);
    }

    
    
}
