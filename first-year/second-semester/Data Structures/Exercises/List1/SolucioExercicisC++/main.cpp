
#include "Usuari.h"

using namespace std;



int main()
{
    Usuari usr1;
    Usuari usr2("Lolala", 341234);
    Usuari *usr3 = new Usuari();
    Usuari *usr4 = new Usuari("Pablolo", 654534);

    cout << "Intro the new id for the default constructor objects " << endl;
    string id;
    cin >> id;
    cout << "Intro the new pin for the default constructor objects " << endl;
    int pin;
    cin >> pin;
    usr1.setData(id,pin);
    usr3->setData(id,pin);

    Usuari usuaris[4];
    usuaris[0] = usr1;
    usuaris[1] = usr2;
    usuaris[2] = *usr3;
    usuaris[3] = *usr4;

    for(int i=0; i<4; i++){
        usuaris[i].print();
    }
    delete usr3;
    delete usr4;

    return 0;
}



