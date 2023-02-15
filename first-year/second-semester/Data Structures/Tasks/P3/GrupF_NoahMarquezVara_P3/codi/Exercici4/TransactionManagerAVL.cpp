
#include "TransactionManagerAVL.h"
#include <vector>
#include <string>
#include <iostream>
#include <fstream>
#include <sstream>
#include <cmath>

using namespace std;

TransactionManagerAVL::TransactionManagerAVL(float buyingFee, float sellingFee) : AVLTree<string, Transaction>() {
    this->buyingFee = buyingFee;
    this->sellingFee = sellingFee;
}

TransactionManagerAVL::TransactionManagerAVL(string file_path, float buyingFee, float sellingFee)
        : AVLTree<string, Transaction>() {
    this->buyingFee = buyingFee;
    this->sellingFee = sellingFee;
    loadFromFile(file_path); //crida al mètode loadFromFile per carregar a l'arbre les transaccions del fitxer
}

TransactionManagerAVL::TransactionManagerAVL(const TransactionManagerAVL &orig) {
    this->buyingFee = orig.buyingFee;
    this->sellingFee = orig.sellingFee;
}

TransactionManagerAVL::~TransactionManagerAVL(){
    cout << "Destruïnt TransactionManagerAVL" << endl;
}

void TransactionManagerAVL::loadFromFile(string file_path) {
    string data, id, quantitat, line;
    ifstream meu_fitxer;
    int _id;
    float _quantitat;

    Transaction *transaccio;
    //Obrim l'arxiu en mode lectura
    meu_fitxer.open(file_path, ios::in);
    //ignorem la primera linea
    meu_fitxer.ignore(100, '\n');

    //bucle fins al final del fitxer
    while (getline(meu_fitxer, line)) {
        stringstream ss(line);
        getline(ss, data, ',');
        ss >> _id; //passem a int
        getline(ss, id, ',');
        ss >> _quantitat; //passem a float
        getline(ss, quantitat, ',');

        transaccio = new Transaction(data, _id, _quantitat); //creació d'una transacció amb les dades captades
        this->add(data, *transaccio); //afegim la transacció a l'arbre
    }
    meu_fitxer.close(); //tanquem el fitxer
}

void TransactionManagerAVL::showAll() const {
    int comptador = 0; //comptador de dates a mostrar
    cout << "Quantes dates vols imprimir? (0 per finalitzar)" << endl;
    cin >> comptador;
    cout << "\n";
    //fins que l'usuari no introdueixi un 0, no parem de mostrar dates
    do {
        showAllAux(p_root, comptador); //crida al mètode auxiliar
        cout << "\n";

        cout << "Quantes dates vols imprimir? (0 per finalitzar)" << endl;
        cin >> comptador;
        cout << "\n";
    } while (comptador != 0);

}

void TransactionManagerAVL::showAllAux(const BinaryTreeNode<string, Transaction> *aux, int &compt) const {
    //si el node passat per paràmetre és nullptr vol dir que no hi ha transaccions a mostrar
    if (aux == nullptr) {
        throw invalid_argument("No hi ha transaccions a mostrar.");
    } else if (compt != 0) { //mentre el comptador sigui 0, avancem
        vector<Transaction> transaccions; //creació d'un vector de transaccions per quan haguem d'imprimir-les donat un node

        //si el node té fill esquerra i el comptador no és 0, anem a la branca esquerra
        if (aux->left() != nullptr && compt != 0) {
            showAllAux(aux->left(), compt);
        }

        if(compt != 0){ //si el comptadr és diferent de 0, imprimim les transaccions
            transaccions = aux->getValues(); //assignem al vector creat anteriorment els values del node que estem tractant

            for (vector<Transaction>::iterator it = transaccions.begin(); it != transaccions.end(); ++it) {
                it->print();
                cout << "\n";
            }
            compt--; //al mostrar una transacció decreix el comptador
        }

        //si el node té fill dret i el comptador no és 0, anem a la branca dreta
        if (aux->right() != nullptr && compt != 0) {
            showAllAux(aux->right(), compt);
        }
    }
}

void TransactionManagerAVL::showAllReverse() const {
    int comptador = 0; //comptador de dates a mostrar
    cout << "Quantes dates vols imprimir? (0 per finalitzar)" << endl;
    cin >> comptador;
    cout << "\n";
    //fins que l'usuari no introdueixi un 0, no parem de mostrar dates
    do {
        showAllReverseAux(p_root, comptador); //crida al mètode auxiliar
        cout << "\n";

        cout << "Quantes dates vols imprimir? (0 per finalitzar)" << endl;
        cin >> comptador;
        cout << "\n";
    } while (comptador != 0);
}

void TransactionManagerAVL::showAllReverseAux(const BinaryTreeNode<string, Transaction> *aux, int &compt) const {
    //si el node passat per paràmetre és nullptr vol dir que no hi ha transaccions a mostrar
    if (aux == nullptr) {
        throw invalid_argument("No hi ha transaccions a mostrar.");
    } else if (compt != 0) { //mentre el comptador sigui 0, avancem
        vector<Transaction> transaccions; //creació d'un vector de transaccions per quan haguem d'imprimir-les donat un node

        //si el node té fill dret i el comptador no és 0, anem a la branca dreta
        if (aux->right() != nullptr && compt != 0) {
            showAllReverseAux(aux->right(), compt);
        }

        //si el comptadr és diferent de 0, imprimim les transaccions
        if (compt != 0) {
            transaccions = aux->getValues();
            for (vector<Transaction>::iterator it = transaccions.begin(); it != transaccions.end(); ++it) {
                it->print();
                cout << "\n";
            }
            compt--; //al mostrar una transacció decreix el comptador
        }

        //si el node té fill esquerra i el comptador no és 0, anem a la branca esquerra
        if (aux->left() != nullptr && compt != 0) {
            showAllReverseAux(aux->left(), compt);
        }
    }
}

void TransactionManagerAVL::showOldest() const {
    //si el root és nullptr, no hi ha transaccions a mostrar
    if (p_root == nullptr) {
        throw new out_of_range("No hi ha transactions.");
    }
    //node auxiliar per recorre l'arbre
    BinaryTreeNode<string, Transaction> *temp = p_root;

    //iterem fins arribar el màxim a l'esquerra possible (la primera transacció que es va realitzar)
    while (temp->left() != nullptr) {
        temp = temp->left();
    }
    //creació d'un vector de transaccions al que assignem els valors del node més a l'esquerra que hem trobat
    vector<Transaction> transaccions = temp->getValues();
    //imprimim la transacció(s) en questió
    for (vector<Transaction>::iterator it = transaccions.begin(); it != transaccions.end(); ++it) {
        it->print();
        cout << "\n";
        cout << "\n";
    }
}

void TransactionManagerAVL::showNewest() const {
    //si el root és nullptr, no hi ha transaccions a mostrar
    if (p_root == nullptr) {
        throw new out_of_range("No hi ha transactions.");
    }
    //node auxiliar per recorre l'arbre
    BinaryTreeNode<string, Transaction> *temp = p_root;

    //iterem fins arribar el màxim a la dreta possible (la primera transacció que es va realitzar)
    while (temp->right() != nullptr) {
        temp = temp->right();
    }
    //creació d'un vector de transaccions al que assignem els valors del node més a la dreta que hem trobat
    vector<Transaction> transaccions = temp->getValues();
    //imprimim la transacció(s) en questió
    for (vector<Transaction>::iterator it = transaccions.begin(); it != transaccions.end(); ++it) {
        it->print();
        cout << "\n";
        cout << "\n";
    }
}

float TransactionManagerAVL::feesInTotal() const {
    float feesTotals = feesInTotalAux(p_root); //crida al mètode auxiliar per calcular les fees totals
    return feesTotals;
}

float TransactionManagerAVL::feesInTotalAux(const BinaryTreeNode<string, Transaction> *aux) const {
    float fees = 0;
    //si el node donat és nullptr, vol dir que no hi ha transaccions per a poder calcular les comissions
    if (aux == nullptr) {
        throw invalid_argument("No hi ha transaccions per calcular les comissions.");
    }

    //si el node té fill esquerra, anem a calcular la branca esquerra
    if (aux->left() != nullptr) {
        fees += feesInTotalAux(aux->left());
    }

    //crida al mètode de suport per calcular les fees d'un node
    fees += calculateFeesInNode(aux);

    //si el node té fill dret, anem a calcular la branca dreta
    if (aux->right() != nullptr) {
        fees += feesInTotalAux(aux->right());
    }

    return fees;
}

float TransactionManagerAVL::feesSinceTime(std::string date) const {
    float fees = 0;

    //si el root és null, no hi haurà cap transacció per calcular les comissions
    if(p_root == nullptr){
        throw invalid_argument("No hi ha cap transacció per mostrar les seves comissions.");
    }

    BinaryTreeNode<string, Transaction> *temp = p_root; //node auxiliar al que assignem el valor del root per iterar sobre l'arbre

    //crida al mètode auxiliar per calcular les comissions a partir de la data donada
    feesSinceTimeAux(date, temp, fees);

    return fees;
}

void TransactionManagerAVL::feesSinceTimeAux(string date, const BinaryTreeNode<string, Transaction> *aux, float &fees) const {
    //si el node auxiliar és diferent de nullptr
    if(aux != nullptr){
        //si la data del node auxiliar és anterior a la data donada
        if(aux->getKey() < date){
            feesSinceTimeAux(date, aux->right(), fees); //crida al mètode amb el fill dret del node auxiliar
        }
            //si la data del node auxiliar és posterior o igual a la data donada
        else{
            feesSinceTimeAux(date, aux->left(), fees); //crida al mètode amb el fill esquerra del node auxiliar

            fees += calculateFeesInNode(aux); //crida al mètode auxiliar per calcular les fees del node auxiliar

            feesSinceTimeAux(date, aux->right(), fees); //crida al mètode amb el fill dret del node auxiliar
        }
    }
}

float TransactionManagerAVL::feesInTimeInterval(pair<string, string> interval) const {
    float fees = 0;

    BinaryTreeNode<string, Transaction> *temp = p_root;

    feesInTimeIntervalAux(interval.first, interval.second, temp, fees);

    return fees;
}

void TransactionManagerAVL::feesInTimeIntervalAux(string first, string second, const BinaryTreeNode<string, Transaction> *aux,
                                                   float &fees) const {
    if(aux != nullptr){ //si aux és diferent de nullptr, avancem
        //si la data de l'aux és més petita que first i més petita que second, avancem cap a la dreta
        if(aux->getKey() < first && aux->getKey() < second){
            feesInTimeIntervalAux(first, second, aux->right(), fees);
        }
        else{
            if(aux->hasLeft()){
                feesInTimeIntervalAux(first, second, aux->left(), fees); //recursivitat cap a la branca esquerra
            }

            //mentre la data d'aux sigui <= second && >= first, calculem les fees del node auxiliar amb el mètode d'ajuda
            if(aux->getKey() <= second && aux->getKey() >= first){
                fees += calculateFeesInNode(aux);
            }

            //si tenim branca dreta
            if(aux->hasRight()){
                //si la data de la branca dreta és <= petita que la segona data, avancem cap a la dreta
                //o bé si la branca dreta té fill esquerra i la data d'aquest és més <= que la segona data
                if(aux->right()->getKey() <= second || (aux->right()->hasLeft() && aux->right()->left()->getKey() <= second)){
                    feesInTimeIntervalAux(first, second, aux->right(), fees);
                }//cas en que l'auxiliar sigui root, que avançarem cap a la dreta
                else if(aux == p_root){
                    feesInTimeIntervalAux(first, second, aux->right(), fees);
                }
            }
        }
    }
}

float TransactionManagerAVL::feesFromFile(string file_path) const {
    string line;
    ifstream meu_fitxer;
    float balancTotal = 0;
    BinaryTreeNode<string, Transaction> *actual; //node auxiliar al que assignarem les dates a tractar
    //Obrim l'arxiu en mode lectura
    meu_fitxer.open(file_path, ios::in);

    //bucle fins al final del fitxer
    while (getline(meu_fitxer, line, '\n')) {
        actual = this->find(line); //fem ús del mètode find de la classe BinarySearchTree per buscar si hi ha un node
                                  // amb la data que s'està tractant
        //si hem trobat un node amb la data a analitzar, calculem les seves comissions
        if (actual != nullptr) {
            balancTotal += calculateFeesInNode(actual);
        }
    }

    meu_fitxer.close(); //tanquem el fitxer
    return balancTotal;
}

float TransactionManagerAVL::calculateFeesInNode(const BinaryTreeNode<string, Transaction> *node) const {
    //si el node donat és nullptr
    if(node == nullptr){
        throw invalid_argument("No hi ha transaccions per calcular les comissions.");
    }

    float node_fees = 0;
    vector<Transaction> transaccions = node->getValues(); //vector de transaccions al que li assignem els values del node

    //iterem pel vector per a calcular les comissions
    for (vector<Transaction>::iterator it = transaccions.begin(); it != transaccions.end(); ++it) {
        //si la quantitat és negativa és tracta d'una compra, per tant hem de fer el càlcul amb l'atribut buyingFee
        if (it->getQuantitat() < 0) {
            node_fees += (abs(it->getQuantitat()) * buyingFee);
        } //si la quantitat és positiva és tracta d'una venda, per tant hem de fer el càlcul amb l'atribut seelingFee
        else {
            node_fees += (it->getQuantitat() * sellingFee);
        }
    }

    return node_fees;
}