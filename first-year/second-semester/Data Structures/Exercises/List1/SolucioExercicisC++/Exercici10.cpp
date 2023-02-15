#include <iostream>
#include <stdlib.h>     /* srand, rand */

using namespace std;



int main()
{
    cout << "Enter ten numbers: " << endl;
    int staticArray[10], min, max;

    for(int i = 0; i < 10; i++){
        cin >> staticArray[i];
    }

 // Traversing the array looking for the min and max values
    min = staticArray[0];
    max = staticArray[0];
    for(int i = 1; i < 10; i++){
        if(staticArray[i] > max){
            max = staticArray[i];
        }
        if(staticArray[i] < min){
            min = staticArray[i];
        }
    }
    cout << "The max value is: " << max << endl;
    cout << "The min value is: " << min << endl;


    return 0;
}



