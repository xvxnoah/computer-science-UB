import java.util.Scanner;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 *
 * @author Noah Márquez Vara
 */
public class FlotaCorrecteBatallaNavalTest {
    
    public FlotaCorrecteBatallaNavalTest() {
    }
    
    /**
     * Test of initJoc method, of class FlotaCorrecteBatallaNaval.
     */
    @Test
    public void testInitJoc() {
        System.out.println("initJoc");
        FlotaCorrecteBatallaNaval.initJoc();
        
    }


    /**
     * Test of inputCorrecte method, of class FlotaCorrecteBatallaNaval.
     */
    @Test
    public void testInputCorrecte() {
        System.out.println("inputCorrecte");
        int min = 0;
        int max = 1;
        int celda = 2;
        boolean expResult = false;
        boolean result = FlotaCorrecteBatallaNaval.inputCorrecte(min, max, celda);
        assertEquals(expResult, result);
    }
    
}
