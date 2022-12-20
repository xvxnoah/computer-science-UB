
public class testex__1 {
   public static final double EPSILON = 0.000001;  
        public static void main (String [] args){
            int a, b, c, d, e, i;
            double x, z, u, f, g, h;
            boolean sonIgualsF, sonIgualsD;
            char car1 = 'b', car2;
        
            a = 10 / 3 + 2;
            b = 3 * 10 / 7;
            c = 3 / 10 * 7;
        
            System.out.println("a=" + a + "b=" + b + "c=" + c);
        
            z = 10e3;
            u = 10e-3;
            x = 1000 * (2 / 3 + 1 / 3 - 1);
            System.out.println("z=" + z + " u=" + u + " x=" + x);

            b = b + 1 / b;
            x = 1 / x;
            a = (int) x;
            z = 1. / a;
            System.out.println("b=" + b + " x=" + x + " a=" + a + " z=" + z);
        
            a = 50 % b;
            b = 678 % 10;
            c = 67 % 10;
            d = 6 % 10;
            e = 1 / 1;
            System.out.println("a=" + a + " b=" + b + " c=" + c + " d=" + d + " e=" + e);
        
            f = 0.0f;
            f += 0.02f;
            f += 0.03f;
       
            sonIgualsF = f == 0.05f;
            System.out.println("sonIgualsF = " + sonIgualsF);
       
            sonIgualsF = Math.abs(f - 0.05f) < EPSILON;
            System.out.println("sonIgualsF = " + sonIgualsF);
            
            g = 1.000001;
            h = 0.000001;
       
            sonIgualsD = (g-h) == 1.0;
            System.out.println("sonIgualsD = " + sonIgualsD);
       
            sonIgualsD = Math.abs((g-h) - 1.0) < EPSILON;
            System.out.println("sonIgualsD = " + sonIgualsD);
            
            car2 = (char) (car1 + 1);
            System.out.println("car2 = " + car2);
       
            i = car2 + 1;
            System.out.println("i=" + i + " i= " + (char) i);
    }
}
