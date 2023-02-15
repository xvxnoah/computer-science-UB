/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   TestTime.cpp
 * Author: maria
 *
 * Created on 20 de febrero de 2018, 11:06
 */

#include <iostream>
#include <stdexcept>
#include "Time.h"

using namespace std;

/*
 * 
 */
int main(int argc, char** argv) {
    // Time t2 (25, 0, 0);  // excepció i acabara el programa 
    // t2.print()  // la resta del programa no s'executara
    
    // amb la gestio de excepcions 
        try {
        // objecte normal 
        cout << " Objecte normal" << endl; 
        
        Time t1(1, 2, 3); 
        t1.print();
        
        cout << " Punter a objecte estatic" << endl; 
        // punter a objecte estàtic
        Time *ptime = &t1; 
        (*ptime).print(); 
        ptime->print(); 
        
        cout << " Referencia a objecte " << endl; 
        // referencia a objete 
        Time &refT1 = t1; 
        refT1.print(); 
        
        cout << " Objecte dinamic" << endl; 
        // Objecte dinàmic 
        Time * ptrT2 = new Time(4, 5, 6); 
        ptrT2->print(); 
        delete ptrT2; 
        
        cout << " Array d'objectes 1" << endl; 
        // Array d'objectes 
        Time tArray[2]; 
        
        tArray[0].print(); //00::00:00
        tArray[1].print(); //00::00:00

        cout << " Array d'objectes 2 " << endl; 
        Time tArray2[2] = {Time(7,8,9), Time(10)}; // Invoca al constructor
        tArray2[0].print(); // 07:08:09
        tArray2[1].print(); // 10:00:00

        cout << " Array d'objectes 3 " << endl; 
        Time *ptrArray3 = new Time[2];  // es un punter a Time
        
        ptrArray3[0].print(); //00::00:00
        ptrArray3[1].print(); //00::00:00
        delete [] ptrArray3; // allibera la memoria via delete[]
        
        cout << " Array d'objectes 4" << endl; 
        // C++11 syntax 
        Time * ptrArray4 = new Time[2] {Time(11,12,13), Time(14)} ;
        ptrArray4->print(); //11:12:13 
        (ptrArray4 +1)->print();  // 14:00:00
        delete[] ptrArray4; 
        
        
        
    } catch(invalid_argument & ex){
        cout << "Excepcio: " << ex.what() << endl; 
    }
    
    
    
    try {
        Time t10(25, 0, 0); 
        t10.print();
        
    } catch(invalid_argument & ex){
        cout << "Excepcio: " << ex.what() << endl; 
    }
    
    cout << " fi del programa " << endl; 
    
    return 0;
}

