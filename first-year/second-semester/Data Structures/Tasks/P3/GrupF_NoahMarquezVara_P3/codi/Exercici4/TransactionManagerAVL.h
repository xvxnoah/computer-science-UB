#ifndef TRANSACTIONMANAGER_H
#define TRANSACTIONMANAGER_H

#include <string>
#include <iostream>
#include <utility>
#include "Transaction.h"
#include "AVLTree.h"

/*-----------------------------------------------------------------------------
 * COST TEORIC DELS MÈTODES:
 *
 * TransactionManager (constructor amb paràmetres per defecte): O(1)
 * TransactionManager (constructor amb paràmetres amb la ruta del fitxer): O(1)
 * TransactionManager (constructor còpia): O(n) on n = nombre d'elements que hi ha a orig
 * ~TransactionManager : O(n) on n = nombre d'elements a l'arbre
 * loadFromFile: O(1)
 * showAll: O(n) en el pitjor cas, O(log(n)) casos normals
 * showAllReverse: O(n) en el pitjor cas, O(log(n)) casos normals
 * showOldest: O(n) en el pitjor cas, O(log(n)) casos normals
 * showNewest: O(n) en el pitjor cas, O(log(n)) casos normals
 * feesInTotal: O(n) en el pitjor cas, O(log(n)) casos normals
 * feesSinceTime: O(n) en el pitjor cas, O(log(n)) casos normals
 * feesInTimeInterval: O(n) en el pitjor cas, O(log(n)) casos normals
 * feesFromFile: O(n) en el pitjor cas, O(log(n)) casos normals
 * showAllAux: igual que showAll
 * showAllReverseAux: igual que showAllReverse
 * feesInTotalAux: igual que feesInTotal
 * feesSinceTimeAux: igual que feesSinceTime
 * feesInTimeIntervalAux: igual que feesInTimeInterval
 * calculateFeesInNode: O(n) en el pitjor cas, O(log(n)) casos normals
 * closestNode: O(n) en el pitjor cas, O(log(n)) casos normals
 * ----------------------------------------------------------------------------
 */

class TransactionManagerAVL : protected AVLTree<string, Transaction> {
public:
    TransactionManagerAVL(float buyingFee = 0.02, float sellingFee = 0.03); //constructor amb paràmetres
    TransactionManagerAVL(string file_path, float buyingFee = 0.02, float sellingFee = 0.03); //constructor fitxer
    TransactionManagerAVL(const TransactionManagerAVL &orig); //constructor còpia
    virtual ~TransactionManagerAVL(); //destructor

    void loadFromFile(string file_path);

    void showAll() const;

    void showAllReverse() const;

    void showOldest() const;

    void showNewest() const;

    float feesInTotal() const;

    float feesSinceTime(string date) const;

    float feesInTimeInterval(pair<string, string> interval) const;

    float feesFromFile(string file_path) const; //mètode per mostrar el balanç de transaccions d'unes dates donades en
    //un fitxer

private:
    float sellingFee;
    float buyingFee;

    //mètode auxiliar del mètode showAll per fer recursió
    void showAllAux(const BinaryTreeNode<string, Transaction> *aux, int &compt) const;

    //mètode auxiliar del mètode showAllReverse per fer recursió
    void showAllReverseAux(const BinaryTreeNode<string, Transaction> *aux, int &compt) const;

    //mètode auxiliar del mètode feesInTotal per fer recursió
    float feesInTotalAux(const BinaryTreeNode<string, Transaction> *aux) const;

    //mètode auxiliar del mètode feesSinceTime per fer recursió
    void feesSinceTimeAux(string date, const BinaryTreeNode<string, Transaction> *aux, float &fees) const;

    //mètode auxiliar del mètode feesInTimeInterval per fer recursió
    void feesInTimeIntervalAux(string first, string second, const BinaryTreeNode<string, Transaction> *aux, float &fees) const;

    //mètode auxiliar que farem servir als mètodes on haguem de calcular les fees, així no hem de repetir codi
    float calculateFeesInNode(const BinaryTreeNode<string, Transaction> *node) const;
};

#endif /* TRANSACTIONMANAGER_H */

