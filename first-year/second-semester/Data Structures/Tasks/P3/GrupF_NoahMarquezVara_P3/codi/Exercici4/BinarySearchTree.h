#ifndef BINARYSEARCHTREE_H
#define BINARYSEARCHTREE_H

#include "BinaryTreeNode.h"
#include <iostream>
#include <stdexcept>
#include <exception>
#include <vector>

/*-----------------------------------------------------------------------------
 * COST TEORIC DELS MÈTODES:
 *
 * BinarySearchTree(constructor per defecte): O(1)
 * BinarySearchTree(constructor copia): O(n) on n = nombre d'elements que hi ha a orig
 * ~BinarySearchTree : O(n) on n = nombre d'elements a l'arbre
 * isEmpty: O(1)
 * size: O(n) on n = nombre d'elements a l'arbre
 * height: O(n) en el pitjor cas, O(log(n)) casos normals
 * add: O(n) en el pitjor cas, O(log(n)) casos normals
 * has: O(n) en el pitjor cas, O(log(n)) casos normals
 * valuesOf: O(n) en el pitjor cas, O(log(n)) casos normals ja que utilitza find()
 * showKeysPreorder: O(n) en el pitjor cas, O(log(n)) casos normals
 * showKeysInorder: O(n) en el pitjor cas, O(log(n)) casos normals
 * showKeysPostorder: O(n) en el pitjor cas, O(log(n)) casos normals
 * equals: O(n) en el pitjor cas, O(log(n)) casos normals
 * getLeafs: O(n) en el pitjor cas, O(log(n)) casos normals
 * find: O(n) en el pitjor cas, O(log(n)) casos normals
 * equalsAux: el mateix que equals
 * sizeAux: el mateix que size
 * getLeafsAux: el mateix que getLeafs
 * hasAux: igual que el mètode has
 * ----------------------------------------------------------------------------
 */

using namespace std;

template<class K, class V>
class BinarySearchTree {
public:
    BinarySearchTree(); //constructor per defecte
    BinarySearchTree(const BinarySearchTree &orig); //constructor còpia
    virtual ~BinarySearchTree(); //destructor

    bool isEmpty() const; //comprova si el BinarySearchTree (BST) està buit
    int size() const; //retorna el tamany de l'arbre
    int height() const; //retorna height de l'arbre

    virtual BinaryTreeNode<K, V> *add(const K &k, const V &value); //inserta un element
    bool has(const K &k) const; //comprova si l'arbre conté el key
    const vector<V> &valuesOf(const K &k) const; //retorna un vector amb els values

    //visita en aquest ordre -> root, left, right
    void showKeysPreorder(const BinaryTreeNode<K, V> *n = nullptr) const;

    //visita en aquest ordre -> left, root, right
    void showKeysInorder(const BinaryTreeNode<K, V> *n = nullptr) const;

    //visita en aquest ordre -> right, left, root
    void showKeysPostorder(const BinaryTreeNode<K, V> *n = nullptr) const;

    //comprova si dos arbres són iguals
    bool equals(const BinarySearchTree<K, V> &other) const;

    const vector<BinaryTreeNode<K, V> *> &getLeafs() const;

protected:
    BinaryTreeNode<K, V> *p_root; //root de l'arbre
    BinaryTreeNode<K, V> *find(const K &k) const; //busca un key a l'arbre

private:
    //mètode auxiliar que comprova si dos arbres són iguals
    bool equalsAux(const BinaryTreeNode<K, V> *node, const BinaryTreeNode<K, V> *node2) const;

    //mètode auxiliar de size() que calcula el tamany de l'arbre recursivament
    int sizeAux(const BinaryTreeNode<K, V> *node) const;

    //mètode auxiliar del mètode getLeafs
    void getLeafsAux(BinaryTreeNode<K, V> *temp, vector<BinaryTreeNode<K, V> *> &leafs) const;

    //mètode auxiliar del mètode has per implementar de forma recursiva
    bool hasAux(const K &k, BinaryTreeNode<K, V> *node) const;
};

template<class K, class V>
BinarySearchTree<K, V>::BinarySearchTree() {
    p_root = nullptr;
}

template<class K, class V>
BinarySearchTree<K, V>::BinarySearchTree(const BinarySearchTree &orig) {
    //crida al constructor còpia de la classe BinaryTreeNode
    this->p_root = new BinaryTreeNode<K, V>(*orig.p_root);
    cout << "Arbre AVL copiat\n";
}

template<class K, class V>
BinarySearchTree<K, V>::~BinarySearchTree() {
    //crida al destructor del BinaryTreeNode
    cout << "\nDestruïnt arbre AVL\n";
    delete p_root;
    cout << "...\n";
    cout << "Arbre AVL destruït\n";
}

template<class K, class V>
bool BinarySearchTree<K, V>::isEmpty() const {
    return p_root == nullptr;
}

template<class K, class V>
int BinarySearchTree<K, V>::size() const {
    //crida al mètode auxiliar per calcular el size del tree
    return sizeAux(p_root);
}

template<class K, class V>
int BinarySearchTree<K, V>::sizeAux(const BinaryTreeNode<K, V> *node) const {
    //si l'arbre està buit
    if (node == nullptr) {
        return 0;
    }//torna la mida de les dues branques recursivament
    else {
        return (sizeAux(node->left()) + 1 + sizeAux(node->right()));
    }
}

template<class K, class V>
int BinarySearchTree<K, V>::height() const {
    if (isEmpty()) { //si està buit
        throw invalid_argument("Binary Search Tree buit.");
    } //crida al mètode height de la classe BinaryTreeNode per calcular recursivament
    return p_root->height();
}

template<class K, class V>
BinaryTreeNode<K, V> *BinarySearchTree<K, V>::add(const K &k, const V &value) {
    BinaryTreeNode<K, V> *node;
    //si l'arbre està buit
    if (isEmpty()) {
        this->p_root = new BinaryTreeNode<K, V>(k);
        this->p_root->addValue(value);

        cout << "Inserta a l'arbre element: " << k << "\n";
        return p_root;
    } else {
        //auxiliar per iterar sobre els nodes
        BinaryTreeNode<K, V> *aux = p_root;
        //auxiliar 2 per guardar l'adreça del node on afegirem el nou value
        BinaryTreeNode<K, V> *aux2;

        while (aux != nullptr) {
            aux2 = aux;
            //si el key a insertar és menor, anem al fill esquerra
            if (k < aux->getKey()) {
                aux = aux->left();
            }//si el key a inserir és major, anem al fill dreta
            else if (k > aux->getKey()) {
                aux = aux->right();
            }//si el key a introduir ja està dins el BST sortim del bucle
            else {
                aux = nullptr;
            }
        }
        //si el key a introduir és menor, s'assigna el new node com a fill esquerra
        if (k < aux2->getKey()) {
            node = new BinaryTreeNode<K, V>(k);
            node->addValue(value);
            aux2->setLeft(node);
            node->setParent(aux2);
        }//si el key a introduir és major, s'assigna el new node com a fill dret
        else if (k > aux2->getKey()) {
            node = new BinaryTreeNode<K, V>(k);
            node->addValue(value);
            aux2->setRight(node);
            node->setParent(aux2);
        }//si el key a introduir ja es troba dins del Binary Search Tree, aleshores
            //afegim el value al vector del node
        else {
            node = aux2;
            node->addValue(value);
        }

        cout << "Inserta a l'arbre element: " << k << "\n";
        return node;
    }
}

template<class K, class V>
bool BinarySearchTree<K, V>::has(const K &k) const {
    //si l'arbre està buit
    if (isEmpty()) {
        throw invalid_argument("Binary Search Tree buit \n");
    }
    bool trobat = false;
    //auxiliar per iterar sobre els nodes
    BinaryTreeNode<K, V> *aux = p_root;

    //crida al mètode auxiliar peer comprovar recursivament si l'arbre té l'element indexat
    trobat = hasAux(k, aux);

    return trobat;
}

template<class K, class V>
bool BinarySearchTree<K, V>::hasAux(const K &k, BinaryTreeNode<K, V> *node) const {
    //si root és nullptr retornem false
    if (node == nullptr) {
        return false;
    } //si el key del root és el que busquem, retornem true
    else if (node->getKey() == k) {
        return true;
    }//si el key és menor que el key del node, anem a mirar als seus fills esquerra
    else if (k < node->getKey()) {
        return hasAux(k, node->left());
    } //si el key és major que el key del node, anem a mirar
    else {
        return hasAux(k, node->right());
    }
}

template<class K, class V>
const vector<V> &BinarySearchTree<K, V>::valuesOf(const K &k) const {
    //fem ús del mètode find per buscar un node a l'arbre amb la key donada
    BinaryTreeNode<K, V> *aux = find(k);
    //si no hem trobat cap node amb la key donada (nullptr)
    if (aux == nullptr) {
        throw invalid_argument(k + " no existeix.");
    }
    return aux->getValues();
}

template<class K, class V>
void BinarySearchTree<K, V>::showKeysPreorder(const BinaryTreeNode<K, V> *n) const {
    //exception si està buit
    if (isEmpty()) {
        throw invalid_argument("Binary Search Tree buit.");
    }
    //si el node és null aleshores imprimim tot el Binary Search Tree
    if (n == nullptr) {
        showKeysPreorder(p_root);
    } else {
        //Preorder -> root, left, right
        cout << n->getKey() << " ";

        if (n->left() != nullptr) {
            showKeysPreorder(n->left());
        }

        if (n->right() != nullptr) {
            showKeysPreorder(n->right());
        }
    }
}

template<class K, class V>
void BinarySearchTree<K, V>::showKeysInorder(const BinaryTreeNode<K, V> *n) const {
    //exception si està buit
    if (isEmpty()) {
        throw invalid_argument("Binary Search Tree buit.");
    }
    //si el node és null aleshores imprimim tot el Binary Search Tree
    if (n == nullptr) {
        showKeysInorder(p_root);
    } else {
        //InOrder -> left, root, right
        if (n->left() != nullptr) {
            showKeysInorder(n->left());
        }

        cout << n->getKey() << " ";

        if (n->right() != nullptr) {
            showKeysInorder(n->right());
        }
    }
}

template<class K, class V>
void BinarySearchTree<K, V>::showKeysPostorder(const BinaryTreeNode<K, V> *n) const {
    //exception si està buit
    if (isEmpty()) {
        throw invalid_argument("Binary Search Tree buit.");
    }
    //si el node és null aleshores imprimim tot el Binary Search Tree
    if (n == nullptr) {
        showKeysPostorder(p_root);
    } else {
        //PostOrder -> left, right, root
        if (n->left() != nullptr) {
            showKeysPostorder(n->left());
        }

        if (n->right() != nullptr) {
            showKeysPostorder(n->right());
        }

        cout << n->getKey() << " ";
    }
}

template<class K, class V>
bool BinarySearchTree<K, V>::equals(const BinarySearchTree<K, V> &other) const {
    //si el tamany dels dos Binary Search Tree són iguals, aleshores comprovem els nodes
    if (size() == other.size()) {
        return equalsAux(p_root, other.p_root);
    }//si no tenen el mateix tamany, aleshores no poden ser iguals
    else {
        return false;
    }
}

template<class K, class V>
const vector<BinaryTreeNode<K, V> *> &BinarySearchTree<K, V>::getLeafs() const {
    vector<BinaryTreeNode<K, V> *> leafs = {};
    getLeafsAux(p_root, leafs);
    return leafs;
}

template<class K, class V>
void BinarySearchTree<K, V>::getLeafsAux(BinaryTreeNode<K, V> *temp, vector<BinaryTreeNode<K, V> *> &leafs) const {
    //si el node és una fulla
    if (temp->isLeaf()) {
        leafs.push_back(temp);
    } else {
        //si el node té branca esquerra
        if (temp->hasLeft()) {
            getLeafsAux(temp->left(), leafs);
        }
        //si el node té branca dreta
        if (temp->hasRight()) {
            getLeafsAux(temp->right(), leafs);
        }
    }
}

template<class K, class V>
BinaryTreeNode<K, V> *BinarySearchTree<K, V>::find(const K &k) const {
    //node auxiliar que comença al p_root
    BinaryTreeNode<K, V> *aux = p_root;

    while (aux != nullptr) {
        //si la key és igual a la key del node actual, retornem aquest node
        if (k == aux->getKey()) {
            return aux;
        }
            //si la key és menor a la del node actual, busquem a la branca esquerra
        else if (k < aux->getKey()) {
            aux = aux->left();
        }
            //si la key és major a la del node actual, busquem a la branca dreta
        else {
            aux = aux->right();
        }
    }

    //si hem arribat aquí, és perquè no s'ha trobat la key en l'arbre binari de cerca
    return nullptr;
}

template<class K, class V>
bool BinarySearchTree<K, V>::equalsAux(const BinaryTreeNode<K, V> *node, const BinaryTreeNode<K, V> *node2) const {
    //si els dos nodes són nulls, aleshores són iguals
    if (node == nullptr && node2 == nullptr) {
        return true;
    }//si els dos nodes no són nulls, mirem si els seus keys i values són iguals
    else if (node != nullptr && node2 != nullptr) {
        //si són iguals aleshores mirem recursivament els fills
        if (*node == *node2) {
            return equalsAux(node->left(), node2->left()) &&
                   equalsAux(node->right(), node2->right());
        }
    }
    //si no és cap de les opcions anteriors vol dir que un dels nodes és null i
    //l'altre no ho és, o que el node i el node2 són diferents
    return false;
}

#endif /* BINARYSEARCHTREE_H */

