#include <cstdlib>
#include "BinarySearchTree.h"
using namespace std;


int main(int argc, char** argv) {
    BinarySearchTree<int, int> *tree1 = new BinarySearchTree<int, int>();
    
    tree1->add(10, 1);
    tree1->add(6, 1);
    tree1->add(4, 1);
    tree1->add(12, 1);
    tree1->add(14, 1);
    
    if(tree1->esArbreSimetric()){
        cout << "\nTRUE\n" << endl;
    } else{
        cout << "\nFALSE\n" << endl;
    }
    
    BinarySearchTree<int, int> *tree2 = new BinarySearchTree<int, int>();
    
    tree2->add(10, 1);
    tree2->add(6, 1);
    tree2->add(4, 1);
    tree2->add(12, 1);
    tree2->add(14, 1);
    tree2->add(11, 1);
    
    if(tree2->esArbreSimetric()){
        cout << "\nTRUE\n" << endl;
    } else{
        cout << "\nFALSE\n" << endl;
    }
    
    BinarySearchTree<int, int> *tree3 = new BinarySearchTree<int, int>();
    
    tree3->add(10, 1);
    tree3->add(6, 1);
    tree3->add(4, 1);
    tree3->add(12, 1);
    tree3->add(14, 1);
    
    if(tree3->esArbreSimetric()){
        cout << "\nTRUE\n" << endl;
    } else{
        cout << "\nFALSE\n" << endl;
    }
    
    BinarySearchTree<int, int> *tree4 = new BinarySearchTree<int, int>();
    
    tree4->add(6, 1);
    tree4->add(7, 1);
    tree4->add(3, 1);
    tree4->add(5, 1);
    tree4->add(2, 1);
    tree4->add(1, 1);
    
    cout << "\n" << tree4->sumaMaximaAFulles() << "\n";
    return 0;
}

