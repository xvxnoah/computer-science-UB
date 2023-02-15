#include <iostream>
#include <stdlib.h>     /* srand, rand */

using namespace std;



int main()
{
    cout << "How many multiplications do you want to do now?: ";
    int num, num1, num2, result, max = 5, count;
    cin >> num;

    for(int i = 0; i < num; i++){

        num1 = rand() % 10 + 1;
        num2 = rand() % 10 + 1;

        cout << "Solve:  " << num1 << " * " << num2 << " = " << endl;

        cin >> result;
        count = 0;
        while (result != (num1*num2) && count < max){
            cout << "It's wrong, try agaain" << endl;
            cin >> result;
            count++;
        }

        if(count == 5){
            cout << "the correct result is: " << (num1*num2) << endl;
        }else{
            cout << "Well done!" << endl;
        }

    }

    return 0;
}



