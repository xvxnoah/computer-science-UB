
#include "Transaction.h"
#include <iostream>

using namespace std;

Transaction::Transaction(const Transaction &orig) {
    data = orig.data;
    id = orig.id;
    quantitat = orig.quantitat;
}

const string Transaction::getData() const {
    return this->data;
}

void Transaction::setData(const string data) {
    this->data = data;
}

const int Transaction::getId() const {
    return this->id;
}

void Transaction::setId(const int id) {
    this->id = id;
}

const float Transaction::getQuantitat() const {
    return this->quantitat;
}

void Transaction::setQuantitat(const float quantitat) {
    this->quantitat = quantitat;
}

void Transaction::print() {
    cout << "{" << this->data << ", " << this->id << ", " << this->quantitat << "}";
}

Transaction::Transaction(string data, int id, float quantitat) {
    this->data = data;
    this->id = id;
    this->quantitat = quantitat;
}
