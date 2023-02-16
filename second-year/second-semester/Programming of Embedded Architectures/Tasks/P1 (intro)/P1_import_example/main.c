#include "msp.h"
#include <stdint.h>

/**
 * main.c
 */
void main(void)
{
    volatile uint32_t i;

    WDT_A->CTL = WDT_A_CTL_PW | WDT_A_CTL_HOLD;		// stop watchdog timer

    P1->DIR |= BIT0;    //P1.0 set as output

    while (1)
    {
        P1->OUT ^= BIT0; //Blink P1.0 led
        //Simple instruction delay (wrong way to implement it)
        for (i = 20000; i > 0; i--)
            ;
    }
}
