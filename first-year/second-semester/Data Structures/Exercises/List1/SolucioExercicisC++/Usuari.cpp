//
// Created by alicia on 25/02/18.
//

#include "Usuari.h"


Usuari::Usuari() {
    //Default construncto
    this->setId("ALICIA");
    this->setPin(12345); // Best password ever


}

Usuari::Usuari(string id, int pin) {
    this->setData(id, pin);
}

void Usuari::setData(string id, int pin){
    this->setId(id);
    this->setPin(pin);
}
void Usuari::setId(string id){
    if(id.size() >= 6){
        this->id = id;
    }else{
        cout << "Incorrect id" << endl;
    }
}

void Usuari::setPin(int pin) {
    this->pin = pin;
}

void Usuari::print() {
    cout << "The user: " << this->id << " has the pin: " << this->pin << endl;
}


