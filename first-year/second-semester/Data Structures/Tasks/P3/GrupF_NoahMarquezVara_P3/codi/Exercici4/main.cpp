#include <cstdlib>
#include "AVLTree.h"
#include "TransactionManagerAVL.h"
#include <iostream>
#include <vector>
#include<fstream>
#include <chrono>
#include <stdexcept>
#include<exception>

////////////////////////////////////////////////////////////////////////////////
/*                      |    BinarySearchTree    |           AVLTree           | 
*-----------------------|------------------------|-----------------------------|                                                                                    
* Inserció arbre petit  |         1733ms         |            39ms             |
*-----------------------|------------------------|-----------------------------|                                                                                              
* Inserció arbre petit  |          36ms          |            35ms             |
*     (shuffled)        |                        |                             | 
*-----------------------|------------------------|-----------------------------|                                                  
*    Cerca arbre gran   |        412752ms        |            494ms            |                          
*-----------------------|------------------------|-----------------------------|                                                
*    Cerca arbre gran   |         555ms          |            508ms            |
*       (shuffled)      |                        |                             |
*-----------------------|------------------------|-----------------------------|  
////////////////////////////////////////////////////////////////////////////////
 */
using namespace std;

int main(int argc, char **argv) {

    int opcio;
    vector<string> opcions{"Ruta al fitxer per carregar en el Gestor de Transaccions: ",
                           "Mostrar totes les transaccions ordenades temporalment: ",
                           "Mostrar transaccions en ordre temporal invers: ",
                           "Mostrar transacció del instant de temps més antic: ",
                           "Mostrar transacció del darrer instant de temps: ",
                           "Mostrar comissió recaptada amb totes les transaccions: ",
                           "Mostrar comissió recaptada a partir d'una data específica: ",
                           "Mostrar comissió recaptada entre dues dates (introdueix les dues dates): ",
                           "Balanç de totes les transaccions efectuades en el fitxer 'queries.txt': ",
                           "Sortir"};

    TransactionManagerAVL *trans = new TransactionManagerAVL();
    string fitxer;

    do {
        for (int i = 0; i < opcions.size(); i++) {
            cout << (i + 1) << ". " << opcions[i] << endl;
        }
        cin >> opcio;

        //Bucle per comprovar que la opció introduïda sigui correcte
        while (opcio < 1 || opcio > 10) {
            cout << "Opció no vàlida. Introdueix un altre nombre: " << endl;
            for (int i = 0; i < opcions.size(); i++) {
                cout << (i + 1) << ". " << opcions[i] << endl;
            }
            cin >> opcio;
        }
        cout << "\n";

        switch (opcio) {
            case 1: {
                cin.ignore();
                cout << "Ruta al fitxer: " << endl;
                getline(cin, fitxer);

                cout << "\n";
                chrono::steady_clock::time_point begin = chrono::steady_clock::now();
                trans = new TransactionManagerAVL(fitxer);
                chrono::steady_clock::time_point end = chrono::steady_clock::now();
                cout << "\nTemps transcorregut: " << chrono::duration_cast<chrono::milliseconds>(end - begin).count()
                     << " ms.\n" << endl;
            }
                break;
            case 2:
                try {
                    trans->showAll();
                } catch (exception const &ex) {
                    cerr << "EXCEPTION: " << ex.what() << endl;
                }
                break;
            case 3:
                try {
                    trans->showAllReverse();
                } catch (exception const &ex) {
                    cerr << "EXCEPTION: " << ex.what() << endl;
                }
                break;
            case 4:
                try {
                    trans->showOldest();
                } catch (exception const &ex) {
                    cerr << "EXCEPTION: " << ex.what() << endl;
                }
                break;
            case 5:
                try {
                    trans->showNewest();
                } catch (exception const &ex) {
                    cerr << "EXCEPTION: " << ex.what() << endl;
                }
                break;
            case 6:
                try {
                    cout << "feesInTotal: " << trans->feesInTotal() << endl;
                    cout << "\n";
                } catch (exception const &ex) {
                    cerr << "EXCEPTION: " << ex.what() << endl;
                }
                break;
            case 7: {
                try {
                    cin.ignore();
                    string data;
                    cout
                            << "Introdueix la data a partir de la qual vols mostrar les comissions recaptades (format: AAAA-MM-DD HH:MM): "
                            << endl;
                    getline(cin, data);
                    cout << "\nfeesSinceTime: " << trans->feesSinceTime(data) << endl;
                    cout << "\n";
                } catch (exception const &ex) {
                    cerr << "EXCEPTION: " << ex.what() << endl;
                }
            }
                break;
            case 8: {
                try {
                    cin.ignore();
                    pair<string, string> interval;
                    cout
                            << "Introdueix la primera data de l'interval a partir de la qual vols mostrar les comissions recaptades (format: AAAA-MM-DD HH:MM): "
                            << endl;
                    getline(cin, interval.first);
                    cout
                            << "Introdueix la darrera data de l'interval fins la qual vols mostrar les comissions recaptades (format: AAAA-MM-DD HH:MM): "
                            << endl;
                    getline(cin, interval.second);
                    cout << "\nfeesInTimeInterval: " << trans->feesInTimeInterval(interval);
                    cout << "\n\n";
                } catch (exception const &ex) {
                    cerr << "EXCEPTION: " << ex.what() << endl;
                }
            }
                break;
            case 9: {
                try {
                    cin.ignore();
                    cout << "Introdueix el nom del fitxer: " << endl;
                    getline(cin, fitxer);
                    cout << "\n";
                    chrono::steady_clock::time_point begin = chrono::steady_clock::now();

                    cout << "Balanç total sobre queries: " << trans->feesFromFile(fitxer) << endl;

                    chrono::steady_clock::time_point end = chrono::steady_clock::now();
                    cout << "\nTemps transcorregut: "
                         << chrono::duration_cast<chrono::milliseconds>(end - begin).count() << " ms.\n" << endl;
                } catch (exception const &ex) {
                    cerr << "EXCEPTION: " << ex.what() << endl;
                }
            }
                break;
            case 10:
                delete trans;
                break;
        }
    } while (opcio != 10);

    return 0;
}

