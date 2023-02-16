/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vehicleSimpleFactory;

/**
 * VehicleFactory.
 * 
 * @author Anna Puig
 * @since 2021
 * @version 1.0
 */

import vehicleSimpleFactory.Vehicle;

import java.util.HashMap;
import java.util.Map;


public enum VehicleFactory {
	INSTANCE;

	public Vehicle createVehicle (VehicleTypes name) {
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
}