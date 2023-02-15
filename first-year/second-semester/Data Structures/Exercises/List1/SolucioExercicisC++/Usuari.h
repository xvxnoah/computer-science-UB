//
// Created by alicia on 25/02/18.
//

#ifndef USUARI_H
#define USUARI_H

#include <string>
#include <iostream>


using namespace std;

class Usuari {
    string id;
    int pin;

    public:
        Usuari();
        Usuari(string id, int pin);
        void setData(string id, int pin);
        void setId(string id);
        void setPin(int pin);
        void print();
};

#endif //USUARI_H
