//
// Created by alicia on 20/02/18.
//

#ifndef PACIENTS_H
#define PACIENTS_H

#include <string>
#include <iostream>


using namespace std;

class Pacient {

public:
    int age;
    double heigth;
    string name;
    double weigth;

    double calcBMI();
    string evalBMI(double BMI);
    Pacient(string name, double age, double weight, double height);
    Pacient();

};


#endif //PACIENTS_H
