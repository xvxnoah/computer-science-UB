//
// Created by alicia on 25/02/18.
//

#ifndef LLISTATPACIENTS_H
#define LLISTATPACIENTS_H

#include "Pacients.h"
#include <string>

using namespace std;

class LlistatPacients {
    int pacientsNum = 0;
    Pacient *pacients;

public:
    LlistatPacients();
    void afegirPacient(Pacient *p);
    void eliminarPacient(string nom);
    void carregarPacients(LlistatPacients *ll);
    void abocaPacients(LlistatPacients *ll);
};


#endif // LLISTATPACIENTS_H
