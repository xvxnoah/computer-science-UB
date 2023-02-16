/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vehiclesSenseFactoryStatic;

/**
 *
 * @author anna
 */
// LISKOV
public abstract class Vehicle {

    public static Vehicle createVehicle (VehicleTypes name) {
		Vehicle vehicle = null;
		switch (name) {
			case Car:
				vehicle = new Car();
				break;
			case Truck:
				vehicle = new Truck();
				break;
		}
		return vehicle;

	}
	public abstract void drive();
}