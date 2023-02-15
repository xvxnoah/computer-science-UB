#ifndef BINARYTREENODE_H
#define BINARYTREENODE_H

#include <vector>
#include <stdexcept>
#include <iostream>

#include "BinarySearchTree.h"

/*-----------------------------------------------------------------------------
 * COST TEORIC DELS MÈTODES:
 *
 * BinaryTreeNode(constructor amb paràmetre): O(1)
 * BinaryTreeNode(constructor còpia): O(n) on n = nombre d'elements que hi ha a orig
 * ~BinaryTreeNode : O(n) on n = nombre d'elements a l'arbre
 * setKey: O(1)
 * setRight: O(1)
 * setLeft: O(1)
 * setParent: O(1)
 * getKey: O(1)
 * getValues: O(1)
 * right: O(1)
 * left: O(1)
 * parent: O(1)
 * isRoot: O(1)
 * hasLeft: O(1)
 * hasRight: O(1)
 * isLeaf: O(1)
 * addValue: O(1)
 * depth: O(n) en el pitjor cas, O(log(n)) casos normals
 * height: O(n) en el pitjor cas, O(log(n)) casos normals
 * operator==: O(1)
 * ----------------------------------------------------------------------------
 */


using namespace std;

template <class K, class V>
class BinaryTreeNode {
public:
    BinaryTreeNode(const K& key); //constructor
    BinaryTreeNode(const BinaryTreeNode& orig); //constructor còpia recursiu
    virtual ~BinaryTreeNode(); //destructor

    /* Modificadors */
    void setKey(const K& data);
    void setRight(BinaryTreeNode<K, V>* right);
    void setLeft(BinaryTreeNode<K, V>* left);
    void setParent(BinaryTreeNode<K, V>* parent);

    /* Consultors */
    const K& getKey() const; //retorna el key del node
    const vector<V>& getValues() const; //retorna un vector
    BinaryTreeNode<K, V>* right() const; //retorna el fill dret del node
    BinaryTreeNode<K, V>* left() const; //retorna el fill esquerra del node
    BinaryTreeNode<K, V>* parent() const; //retorna el parent del node

    /* Operacions */
    bool isRoot() const; //comprova si el node és root
    bool hasLeft() const; //retorna true si left != nullptr, false altrament
    bool hasRight() const; //retorna true si right != nullptr, false altrament
    bool isLeaf() const; //comprova si el node és fulla

    void addValue(const V& v); //afegeix un nou valor al vector
    int depth() const; //profunditat del node en l'arbre binari de cerca
    int height() const; //alçada del node en l'arbre de cerca binari
    bool operator==(const BinaryTreeNode<K, V>& node) const; //comprova si dos nodes són iguals

private:
    K key;
    vector<V> values;
    BinaryTreeNode<K, V>* _left;
    BinaryTreeNode<K, V>* _right;
    BinaryTreeNode<K, V>* _parent;
};

template <class K, class V>
BinaryTreeNode<K, V>::BinaryTreeNode(const K& key) {
    //inicialitzar atributs
    this->_left = nullptr;
    this->_right = nullptr;
    this->_parent = nullptr;
    this->key = key;
}

template <class K, class V>
BinaryTreeNode<K, V>::BinaryTreeNode(const BinaryTreeNode<K, V>& orig) : BinaryTreeNode(orig.key) {
    //copiem el contingut del value i el key del node
    this->values = orig.values;
    //si el node passat per paràmetre té fills, aleshores copiem els seus fills
    if (orig._left != nullptr) {
        //cridem al constructor còpia dels fills per així copiar recursivament tots els descendents
        this->_left = new BinaryTreeNode<K, V>(*orig._left);
        this->_left->setParent(this);
    }
    if (orig._right != nullptr) {
        this->_right = new BinaryTreeNode<K, V>(*orig._right);
        this->_right->setParent(this);
    }
}

template <class K, class V>
BinaryTreeNode<K, V>::~BinaryTreeNode() {
    cout << "Eliminant BinaryTreeNode " << this->key << "\n";
    //eliminem els fills
    delete _left;
    delete _right;
}

template <class K, class V>
int BinaryTreeNode<K, V>::depth() const {
    //si és root, depth == 0
    if (this->isRoot()) {
        return 0;
    } else {
        //calculem els ancestres que té
        return _parent->depth() + 1;
    }
}

template <class K, class V>
BinaryTreeNode<K, V>* BinaryTreeNode<K, V>::parent() const {
    return _parent;
}

template <class K, class V>
BinaryTreeNode<K, V>* BinaryTreeNode<K, V>::left() const {
    return _left;
}

template <class K, class V>
BinaryTreeNode<K, V>* BinaryTreeNode<K, V>::right() const {
    return _right;
}

template <class K, class V>
const K& BinaryTreeNode<K, V>::getKey() const {
    return key;
}

template <class K, class V>
const vector<V>& BinaryTreeNode<K, V>::getValues() const {
    return values;
}

template <class K, class V>
bool BinaryTreeNode<K, V>::isRoot() const {
    return _parent == nullptr;
}

template <class K, class V>
bool BinaryTreeNode<K, V>::hasLeft() const {
    return _left != nullptr;
}

template <class K, class V>
bool BinaryTreeNode<K, V>::hasRight() const {
    return _right != nullptr;
}

template <class K, class V>
bool BinaryTreeNode<K, V>::isLeaf() const {
    //el node és una fulla si no té fills
    return _left == nullptr && _right == nullptr;
}

template <class K, class V>
void BinaryTreeNode<K, V>::addValue(const V& v) {
    this->values.push_back(v);
}

template <class K, class V>
int BinaryTreeNode<K, V>::height() const {
    //si el node és una fulla -> height == 1
    if (this->isLeaf()) {
        return 1;
    } //si el node té els dos fills, s'ha de calcular l'alçada màxima dels dos fills + 1
    else if (_left != nullptr && _right != nullptr) {
        return max(_left->height(), _right->height()) + 1;
    }//quan només té fill dret
    else if (_left == nullptr) {
        return _right->height() + 1;
    }//quan només té fill esquerra
    else {
        return _left->height() + 1;
    }
}

template <class K, class V>
bool BinaryTreeNode<K, V>::operator==(const BinaryTreeNode<K, V>& node) const {
    //els nodes són iguals si el key i el value són iguals
    return key == node.key && values == node.values;
}

template <class K, class V>
void BinaryTreeNode<K, V>::setLeft(BinaryTreeNode<K, V>* left) {
    _left = left;
}

template <class K, class V>
void BinaryTreeNode<K, V>::setRight(BinaryTreeNode<K, V>* right) {
    _right = right;
}

template <class K, class V>
void BinaryTreeNode<K, V>::setParent(BinaryTreeNode<K, V>* parent) {
    _parent = parent;
}
#endif /* BINARYTREENODE_H */

