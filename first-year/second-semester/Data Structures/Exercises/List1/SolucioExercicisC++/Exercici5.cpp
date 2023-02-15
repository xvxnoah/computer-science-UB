#include <iostream>
using namespace std;



int main()
{
    cout << "Enter your years into the enterprise";
    int years;
    double s = 40000.;
    cin >> years;

    if(years > 10){
        s *= 1.1;

    }else if(years > 5){
        s *= 1.07;

    }else if(years > 3){
        s *= 1.05;

    }else{
        s *= 1.03;
    }
    return 0;
}


