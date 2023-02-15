#include <cstdlib>
#include "BinarySearchTree.h"
using namespace std;


int main(int argc, char** argv) {
    BinarySearchTree<int, int> *tree1 = new BinarySearchTree<int, int>();
    
    tree1->add(7, 1);
    tree1->add(9, 1);
    tree1->add(4, 1);
    tree1->add(5, 1);
    tree1->add(2, 1);
    tree1->add(1, 1);
    tree1->add(3, 1);
    tree1->add(6, 1);
    tree1->add(8, 1);
    
    cout << "\n";
    tree1->mostraNodesNivell(0);
    cout << "\n";
    tree1->mostraNodesNivell(1);
    cout << "\n";
    tree1->mostraNodesNivell(2);
    cout << "\n";
    tree1->mostraNodesNivell(3);
    cout << "\n";
    tree1->mostraNodesNivell(4);
    cout << "\n";

    
    return 0;
}

