//
// Created by alicia on 20/02/18.
//

#include <iostream>
#include "Pacients.h"

Pacient::Pacient() {}

Pacient::Pacient(string name, double age, double weight, double height){
    this->name = name;
    this->age = age;
    this->heigth = height;
    this->weigth = weight;

}

double Pacient::calcBMI() {
    return this->weigth / ((this->heigth) * (this->heigth));
}

string Pacient::evalBMI(double BMI){
    string sentence;
    if(BMI > 30) {
        sentence = "Obessity";

    }else if(BMI > 25){
        sentence = "Overweight";

    }else if(BMI < 18.5){
        sentence = "Thin";

    }else if(BMI >= 18.5){
        sentence = "Normal";
    }
    return sentence;
}

/**int main(){
    Pacient *me = new Pacient("David", 28, 87, 1.87);
    cout << me->evalBMI(me->calcBMI()) << endl;
    return 0;
}
 **/