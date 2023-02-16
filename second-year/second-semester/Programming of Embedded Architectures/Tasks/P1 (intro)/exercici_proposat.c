/*
 * EXERCICI PROPOSAT
 */

#include "msp.h"
#include <stdio.h>
#include <stdint.h>

int main(void)
{
    WDT_A->CTL = WDT_A_CTL_PW | WDT_A_CTL_HOLD; // Stop watchdog timer

    volatile uint64_t foo;
    uint8_t a, c = 0, i, d;
    int8_t b;
    char string[16];

    d = 5;

    a = 255;
    b = a;
    a = 0x11FF;

    a = 0x01;
    a <<= 1;
    a = (0x10 >> 1);

    a = 0x80;
    a <<= 1;
    a = 0xFF;
    a >>= 1;
    b = 0xFF;
    b >>= 1;

    a = 0xAA;
    a ^= 0xFF;
    a ^= 0xFF;

    a &= 0x0F;
    a&= ~(0x01);

    a |= 0x0F;
    a |= ~(0xFE);

    string[0] = 32;
    for(i = 1; i < sizeof(string); ++i){
        string[i] = ' ';
    }

    sprintf(string, "Hello world!");
    sprintf(string, "Hello!");
    a = 101;
    sprintf(string, "Hello %d", a);
    a = 11;
    sprintf(string, "Hello %d", a);
    foo = sizeof(string);
    sprintf(string, "Hello %3d", a);
    a = 101;
    sprintf(string, "Hello world %03d!", a);
    foo = sizeof(string);

    while(1){
        __no_operation();
    }
}
