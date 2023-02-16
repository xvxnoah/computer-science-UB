package vehiclesSenseFactory;

import vehiclesSenseFactory.VehicleTypes;

import java.util.Scanner;

public class TestDrive {
    public static void main(String[] args) {

        System.out.println("Quin tipus de vehicle vols?");

        String name;
        Scanner teclado = new Scanner(System.in);
        name = teclado.nextLine();
        Vehicle vehicle = null;

        switch (name) {
            case "CAR":
                vehicle = new Car();
                break;
            case "TRUCK":
                vehicle = new Truck();
                break;
        }
        vehicle.drive();

    }
}
