import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 *
 * @author Noah Márquez
 */
public class ContentesTest {

    @Test
    public void testTotesContentes() {
        boolean test = Contentes.totesContentes("aabcdaaefaa");
        assertTrue(test);
        
        test = Contentes.totesContentes("aabcdaefaa");
        assertFalse(test);
        
        test = Contentes.totesContentes("hola");
        assertFalse(test);
        
        test = Contentes.totesContentes("aabeeeeddqqqaa");
        assertTrue(test);
        
        test = Contentes.totesContentes("abbquehfeirfheiaa");
        assertFalse(test);
    }

}  

