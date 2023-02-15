#ifndef EX3_AVLTREE_H
#define EX3_AVLTREE_H
#include "BinarySearchTree.h"
#include <iostream>
#include <stdexcept>
#include <exception>
#include <vector>

/*-----------------------------------------------------------------------------
 * COST TEORIC DELS MÈTODES:
 *
 * AVLTree(constructor per defecte): O(1)
 * add: O(log(n)), la cerca inicial d'on inserir el node és O(log(n)) i reestructurar cap a dalt de l'arbre, mantenint
 * les alçades té un cost de O(log(n))
 * leftRotate: O(1) una reestructuració simple costa O(1)
 * rightRotate: O(1) una reestructuració simple costa O(1)
 * rebalance: O(1) encarregat de fer les reestructuracions, tant simples com dobles (però les dobles són simplement dues
 * simples una darrera l'altre)
 * updateBalance: O(log(n)), reestructura cap a dalt de l'arbre actualitzant els height i els factors de balanç
 * ----------------------------------------------------------------------------
 */

using namespace std;

template <class K, class V>
class AVLTree : public BinarySearchTree<K, V> {
public:
    AVLTree(); //constructor per defecte

    BinaryTreeNode<K, V>* add(const K& k, const V& value); //inserta un element a l'arbre AVL
    void leftRotate(BinaryTreeNode<K, V> *alpha); //rotació esquerra
    void rightRotate(BinaryTreeNode<K, V> *alpha); //rotació dreta

private:
    void rebalance(BinaryTreeNode<K,V> *node); //mètode per fer rebalanceig si cal
    void updateBalance(BinaryTreeNode<K , V> *node); //mètode per actualitzar height i factor de balanç
};

template <class K, class V>
AVLTree<K, V>::AVLTree() : BinarySearchTree<K, V>(){
    cout << "Arbre AVL creat\n";
}

template <class K, class V>
BinaryTreeNode<K, V> *AVLTree<K,V>::add(const K &k, const V &value) {
    BinaryTreeNode<K, V> *node = BinarySearchTree<K, V>::add(k, value); //afegim node a l'arbre
    updateBalance(node); //cridem al mètode amb el nou node per actualitzar els factors de balanç i les altures
    //des del node inserit cap amunt
}

template <class K, class V>
void AVLTree<K, V>::rebalance(BinaryTreeNode<K, V> *node){
    //assignem el valor del factor de balanç del node a una variable
    int bf = node->getFactorBalanc();

    //desbalanceig a la dreta
    if(bf == 2){
        //rotació esquerra simple
        if(node->right()->getFactorBalanc() == 1){
            leftRotate(node);
        } //rotació dreta-esquerra
        else if(node->right()->getFactorBalanc() == -1){
            rightRotate(node->right());
            leftRotate(node);
        }
    }
        //desbalanceig a l'esquerra
    else if(bf == -2){
        //rotació dreta simple
        if(node->left()->getFactorBalanc() == -1){
            rightRotate(node);
        } //rotació esquerra-dreta
        else if(node->left()->getFactorBalanc() == 1){
            leftRotate(node->left());
            rightRotate(node);
        }
    }
}

template <class K, class V>
void AVLTree<K, V>::updateBalance(BinaryTreeNode<K, V> *node){
    //mentre el node sigui diferent de nullptr, iterem
    while(node != nullptr){
        node->calculateBalanceHeight(); //mètode de la classe BinaryTreeNode que actualitza el height i el factor de balanç
        if(node){ //si el node és diferent de nullptr:
            rebalance(node); //crida al mètode auxiliar per comprovar si cal fer rebalanceig
        }
        node = node->parent(); //anem pujant per l'arbre
    }
}

template <class K, class V>
void AVLTree<K, V>::rightRotate(BinaryTreeNode<K, V> *alpha){
    BinaryTreeNode<K,V> *pare = alpha->parent(); //node auxiliar amb el pare d'alpha
    BinaryTreeNode<K, V> *beta = alpha->left(); //node auxiliar amb el fill esquerra d'alpha

    //cas en que alpha sigui root
    if(pare == nullptr){
        //si beta té fill dret
        if(beta->hasRight()){
            alpha->setLeft(beta->right()); //assignem el fill dret de beta al fill esquerra d'alpha
            alpha->left()->setParent(alpha); //el fill dret d'alpha tindrà com a pare alpha
        } //si beta no té fill dret
        else{
            alpha->setLeft(nullptr); //el fill esquerra d'alpha serà nullptr
        }
        this->p_root = beta; //el nou root serà beta
        beta->setRight(alpha); //beta tindrà com a right alpha
        alpha->setParent(beta); //alpha pasarà a tenir de pare a beta
        beta->setParent(nullptr); //com beta és root, pasa a tenir nullptr com a pare
    } //cas en què alpha no és root
    else{
        //si alpha és el fill esquerra del seu pare
        if(alpha == pare->left()){
            pare->setLeft(beta);
        } //si alpha és el fill dret del seu pare
        else{
            pare->setRight(beta);
        }
        beta->setParent(pare); //el pare de beta pasarà a ser el pare d'alpha

        alpha->setParent(beta); //alpha tindrà a beta com a pare
        //si beta té fill dret
        if(beta->hasRight()){
            alpha->setLeft(beta->right()); //el fill esquerra d'alpha passa a ser el fill dret de beta
            alpha->left()->setParent(alpha); //el fill esquerra d'alpha tindrà com a pare el propi alpha
        }//si beta no té fill dret
        else{
            alpha->setLeft(nullptr);
        }
        beta->setRight(alpha);//el fill dret de beta passa a ser alpha
    }

    alpha->calculateBalanceHeight(); //actualitzem height i factor de balanç d'alpha
    beta->calculateBalanceHeight(); //actualitzem height i factor de balanç de beta
}

template <class K, class V>
void AVLTree<K, V>::leftRotate(BinaryTreeNode<K, V> *alpha){
    BinaryTreeNode<K,V> *pare = alpha->parent(); //node auxiliar amb el pare d'alpha
    BinaryTreeNode<K, V> *beta = alpha->right(); //node auxiliar amb el fill dret d'alpha

    //cas en què alpha és root
    if(pare == nullptr){
        //si beta té fill esquerra
        if(beta->hasLeft()){
            alpha->setRight(beta->left()); //assignem el fill esquerra de beta al fill dret d'alpha
            alpha->right()->setParent(alpha); //el fill dret d'alpha tindrà com a pare el propi alpha
        } //si beta no té fill dret
        else{
            alpha->setRight(nullptr); //el fill dret d'alpha passa a ser nullptr
        }
        this->p_root = beta; //beta serà el nou root
        beta->setLeft(alpha); //el fill esquerra de beta passa a ser alpha
        alpha->setParent(beta); //el pare d'alpha serà beta
        beta->setParent(nullptr); //com beta ara és root, el seu pare serà nullptr
    } //si alpha no és root
    else{
        //si alpha és el fill dret del seu pare
        if(alpha == pare->right()){
            pare->setRight(beta);
        }//si alpha és el fill esquerra del seu pare
        else{
            pare->setLeft(beta);
        }
        beta->setParent(pare); //beta tindrà com a pare el pare d'alpha

        alpha->setParent(beta); //ara el pare d'alpha serà beta

        //si beta té fill esquerra
        if(beta->hasLeft()){
            alpha->setRight(beta->left()); //assignem el fill esquerra de beta al fill dret d'alpha
            alpha->right()->setParent(alpha); //el fill dret d'alpha passarà a tenir com a pare el propi alpha
        } //si beta no té fill esquerra
        else{
            alpha->setRight(nullptr); //el fill dret d'alpha passarà a ser nullptr
        }
        beta->setLeft(alpha); //el fill esquerra de beta passa a ser alpha
    }

    alpha->calculateBalanceHeight(); //actualitzem height i factor de balanç d'alpha
    beta->calculateBalanceHeight(); //actualitzem height i factor de balanç de beta
}

#endif //EX3_AVLTREE_H
