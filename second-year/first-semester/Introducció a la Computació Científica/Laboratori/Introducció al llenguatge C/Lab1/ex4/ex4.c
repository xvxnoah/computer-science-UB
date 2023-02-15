#include <stdio.h>

int main() {
    double e;
    e  = 1;

    while ((1.f + e) != 1.f){
        e = e/2;
    }
    printf("%3d %18.6e\n", e);
}
