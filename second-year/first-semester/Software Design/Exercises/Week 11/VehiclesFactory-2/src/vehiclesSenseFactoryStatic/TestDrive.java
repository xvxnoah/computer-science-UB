/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vehiclesSenseFactoryStatic;

/**
 * Test Sesne Factory static method.
 * 
 * @author Anna Puig
 * @since 2021
 * @version 1.0
 */
public class TestDrive {

	/**
	 * Main test method
	 * @param args
	 */
	public static void main(String[] args) {
		Vehicle vehicle;

		vehicle = Vehicle.createVehicle(VehicleTypes.Car);
		vehicle.drive();
		vehicle = Vehicle.createVehicle(VehicleTypes.Truck);
		vehicle.drive();

	}

}