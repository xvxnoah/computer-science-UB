#include <iostream>
#include <stdlib.h>     /* srand, rand */

using namespace std;



int main()
{
    cout << "Enter your grade: " << endl;
    int grade;
    cin >> grade;

    if(grade >= 9){
        cout << "Excelent!" << endl;
    }else if(grade >= 7){
        cout << "Notable" << endl;
    } else if(grade >= 6){
        cout << "Be" << endl;
    }else if(grade >= 5){
        cout << "Suficient" << endl;
    }else if(grade < 5){
        cout << "Suspes" << endl;
    }else{
        cout << "Incorrect number" << endl;
    }

    return 0;
}



