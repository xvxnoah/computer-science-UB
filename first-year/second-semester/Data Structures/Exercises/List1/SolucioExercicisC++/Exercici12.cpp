#include <iostream>

using namespace std;



int main()
{
    int n, temp ; // array size

    cout << "Intro the array size 'n'"<< endl;
    cin >> n;

    int staticArray[n];

    for(int v = 0; v < n; v++){
        staticArray[v] = (v+1);
    }
    if(n%2 == 0){ //even
        for(int i = 0; i < n/4; i++){
            //swap
            temp = staticArray[((int)n/2)-i-1];
            staticArray[((int)n/2)-i-1] = staticArray[i];
            staticArray[i] = temp;

            temp = staticArray[((int)n/2) + i];
            staticArray[((int)n/2) + i] = staticArray[n-1-i];
            staticArray[n-1-i] = temp;

        }
    }

    // Showing the result

    for(int i = 0; i < n; i++){
        cout << staticArray[i] << "  " << endl;
    }
    return 0;
}



