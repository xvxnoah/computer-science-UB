#include <iostream>

using namespace std;



int main()
{
    cout << "Enter fifteen letters: " << endl;
    char letter, staticArray[15], letterCounter[15]; // Current letter, letters list, letters counter
    bool exist; // boolean that shows if the letter appeared before
    int c = 0; // array traveler looking for the current letter in the already appeared letters array

    for(int i = 0; i < 15; i++){
        cin >> letter;

        exist = false;
        c = 0;
        // Traverse the older letters to see if this letter has already appeared
        while(c < i && (exist != true)){
            if(staticArray[c] == letter){
                letterCounter[c]++;
                staticArray[i] = '0'; // As the letter has already appeared, mark the counter and the letter saver position as useless
                letterCounter[i] = '0';
                exist = true;
            }
            c++;
        }
        if(!exist){
            // New letter found save, and count it.
            staticArray[i] = letter;
            letterCounter[i] = 1;
        }
    }

    // Showing the result

    for(int i = 0; i < 15; i++){
        if(staticArray[i]!= '0')
        cout << "Letter: " << staticArray[i] << " appeared " << (int)letterCounter[i] << " times " << endl;
    }



    return 0;
}



