#include <iostream>

float toPounds(float kg);

using namespace std;



int main()
{
    cout << "Enter a number in kg: ";
    float kg;
    cin >> kg;

    float pounds = toPounds(kg);

    cout << "The pounds are " << pounds << endl;

    return 0;
}

float toPounds(float kg) {
    return kg / 0.454;;
}

