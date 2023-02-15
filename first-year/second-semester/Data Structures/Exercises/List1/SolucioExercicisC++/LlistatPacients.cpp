//
// Created by alicia on 25/02/18.
//

#include <iostream>
#include <fstream>
#include "LlistatPacients.h"


LlistatPacients::LlistatPacients(){
    this->pacients = (Pacient*) malloc(sizeof(Pacient) * 100);

};
void LlistatPacients::afegirPacient(Pacient *p) {
    if(pacientsNum < 100) {
        this->pacients[pacientsNum++] = *p;
    }
}

void LlistatPacients::eliminarPacient(string nom) {
    int i = 0;

    for(; i < 100; i++) {
        if(this->pacients[i].name.compare(nom) == 0)
            break;
    }

    this->pacients[i] = *(new Pacient());
}

void LlistatPacients::carregarPacients(LlistatPacients *ll){
    ifstream input( "pacients.txt" );
    for( string nom; getline( input, nom, ','); )
    {
        string pes; getline( input, pes, ',');
        string alt; getline( input, alt, ',');
        string edat; getline( input, edat, ',');
        cout << nom << edat << pes;
        ll->afegirPacient(new Pacient(nom,stod(edat),stod(pes),stod(alt)));
    }

}

void LlistatPacients::abocaPacients(LlistatPacients *ll){
    ofstream myfile;
    myfile.open ("pacients.txt");
    for(int i = 0; i< ll->pacientsNum; i++){
        myfile << ll->pacients[i].name << "," << ll->pacients[i].weigth <<"," << ll->pacients[i].heigth << "," << ll->pacients[i].age << "," << endl;
    }
    myfile << "\n";
    myfile.close();
}

int main(){
    LlistatPacients *list = new LlistatPacients();
    while(true) {
        cout << "1. Afegir pacients" << endl;
        cout << "2. Eliminar pacient" << endl;
        cout << "3. Carrega pacients" << endl;
        cout << "4. Aboca pacients" << endl;

        int seleccio;

        cin >> seleccio;

        switch (seleccio){
            case 1:
                list->afegirPacient(new Pacient("Pep",23,43,1.5));
                break;
            case 2:
                list->eliminarPacient("Pep");
                break;
            case 3:
                list->carregarPacients(list);
                break;
            case 4:
                list->abocaPacients(list);
                break;
        }
    }
}
