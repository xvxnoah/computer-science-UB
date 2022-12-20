import org.junit.jupiter.api.Test;

/**
 *
 * @author Noah Márquez
 */
public class TresEnRatllaTest {
    

    /**
     * Test of initTauler method, of class TresEnRatlla.
     */
    @Test
    public void testInitTauler() {
        System.out.println("initTauler");
        String[][] tauler = new String[3][3];
        TresEnRatlla.initTauler(tauler);
    }

    /**
     * Test of mostraTauler method, of class TresEnRatlla.
     */
    @Test
    public void testMostraTauler() {
        System.out.println("mostraTauler");
        String[][] tauler = new String[3][3];
        TresEnRatlla.mostraTauler(tauler);
    }


}
