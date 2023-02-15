#ifndef TRANSACTION_H
#define TRANSACTION_H

#include <iostream>
#include <string>

/*-----------------------------------------------------------------------------
 * COST TEORIC DELS MÈTODES:
 *
 * Transaction (constructor amb paràmetres): O(1)
 * Transaction (constructor còpia): O(1)
 * getData: O(1)
 * getId: O(1)
 * getQuantitat: O(1)
 * setData: O(1)
 * setId: O(1)
 * setQuantitat: O(1)
 * print: O(1)s
 * ----------------------------------------------------------------------------
 */

using namespace std;

class Transaction {
public:
    Transaction(string data, int id, float quantitat); //constructor per paràmetres
    Transaction(const Transaction &orig); //constructor còpia

    /* Consultors */
    const string getData() const; //retorna la data
    const int getId() const; //retorna l'id
    const float getQuantitat() const; //retorna la quantitat

    /* Modificadors */
    void setData(const string data); //modifica la data
    void setId(const int id); //modifica l'id
    void setQuantitat(const float quantitat); //modifica la quantitat

    void print(); //imprimeix la transacció

private:
    string data;
    int id;
    float quantitat;
};

#endif /* TRANSACTION_H */

