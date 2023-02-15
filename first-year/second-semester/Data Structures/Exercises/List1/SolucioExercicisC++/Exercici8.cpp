#include <iostream>
#include <stdlib.h>     /* srand, rand */

using namespace std;



int main()
{
    cout << "Table: ";
    int num;
    cin >> num;

    if(num <= 10){
        for(int i = 0; i <= 9; i++){
            cout << num << " * " << i << " = " << num*i << "\n";
        }
    }

    return 0;
}



