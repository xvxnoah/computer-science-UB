/******************************
 * 
 * Practica_03_PAE Timers i interrupcions
 * UB, 03/2021.
 *
 *****************************/

#include <msp432p401r.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

#include "lib_PAE.h"

#define LED_V_BIT BIT0
#define LED_RGB_R BIT0
#define LED_RGB_G BIT1
#define LED_RGB_B BIT2

#define SW1_POS 1
#define SW2_POS 4
#define SW1_INT 0x04
#define SW2_INT 0x0A
#define SW1_BIT BIT(SW1_POS)
#define SW2_BIT BIT(SW2_POS)

typedef struct
{
    bool r, g, b;
    uint8_t time;
} color_t;

color_t color_sequence[] = { { .r = true, .g = false, .b = false, .time = 1 }, 
	//TODO
        };

/**************************************************************************
 * INICIALIZACIÓN DEL CONTROLADOR DE INTERRUPCIONES (NVIC).
 *
 * Sin datos de entrada
 *
 * Sin datos de salida
 *
 **************************************************************************/
void init_interrupciones()
{
    // Configuracion al estilo MSP430 "clasico":
    // --> Enable Port 4 interrupt on the NVIC.
    // Segun el Datasheet (Tabla "6-39. NVIC Interrupts", apartado "6.7.2 Device-Level User Interrupts"),
    // la interrupcion del puerto 1 es la User ISR numero 35.
    // Segun el Technical Reference Manual, apartado "2.4.3 NVIC Registers",
    // hay 2 registros de habilitacion ISER0 y ISER1, cada uno para 32 interrupciones (0..31, y 32..63, resp.),
    // accesibles mediante la estructura NVIC->ISER[x], con x = 0 o x = 1.
    // Asimismo, hay 2 registros para deshabilitarlas: ICERx, y dos registros para limpiarlas: ICPRx.

    //Int. port 1 = 35 corresponde al bit 3 del segundo registro ISER1:
    NVIC->ICPR[1] |= 1 << (PORT1_IRQn & 31); //Primero, me aseguro de que no quede ninguna interrupcion residual pendiente para este puerto,
    NVIC->ISER[1] |= 1 << (PORT1_IRQn & 31); //y habilito las interrupciones del puerto

	//TODO
}

/**************************************************************************
 * INICIALIZACIÓN DE LOS BOTONES & LEDS DEL BOOSTERPACK MK II.
 * 
 * Sin datos de entrada
 * 
 * Sin datos de salida
 * 
 **************************************************************************/
void init_botons(void)
{
    //Configuramos botones i LED vermell
    //***************************
    P1SEL0 &= ~(BIT0 + BIT1 + BIT4 );    //Els polsadors son GPIOs
    P1SEL1 &= ~(BIT0 + BIT1 + BIT4 );    //Els polsadors son GPIOs

    //LED vermell = P1.0
    P1DIR |= LED_V_BIT;      //El LED es una sortida
    P1OUT &= ~LED_V_BIT;     //El estat inicial del LED es apagat

    //Botó S1 = P1.1 i S2 = P1.4
    P1DIR &= ~(SW1_BIT + SW2_BIT);    //Un polsador es una entrada
    P1REN |= (SW1_BIT + SW2_BIT);     //Pull-up/pull-down pel pulsador
    P1OUT |= (SW1_BIT + SW2_BIT); //Donat que l'altra costat es GND, volem una pull-up
    P1IE |= (SW1_BIT + SW2_BIT);      //Interrupcions activades
    P1IES &= ~(SW1_BIT + SW2_BIT);    // amb transicio L->H
    P1IFG = 0;                  // Netegem les interrupcions anteriors
}

/*****************************************************************************
 * CONFIGURACIÓN DE LOS LEDs DEL PUERTO 1. A REALIZAR POR EL ALUMNO
 * 
 * Sin datos de entrada
 * 
 * Sin datos de salida
 *  
 ****************************************************************************/
void config_RGB_LEDS(void)
{

    //LEDs RGB = P2.0, P2.1, P2.2
    P2SEL0 &= ~(BIT0 + BIT1 + BIT2 );    //P2.0, P2.1, P2.2 son GPIOs
    P2SEL1 &= ~(BIT0 + BIT1 + BIT2 );    //P2.0, P2.1, P2.2 son GPIOs
    P2DIR |= (BIT0 + BIT1 + BIT2 );      //Els LEDs son sortides
    P2OUT &= ~(BIT0 + BIT1 + BIT2 );     //El seu estat inicial sera apagat

}

void init_timers(void)
{
	//TODO 
    //Timer A0, used for red LED PWM

    //Timer A1, used for RGB LEDs
	//Divider = 1; CLK source is ACLK; clear the counter; MODE is up
    TIMER_A1->CTL = TIMER_A_CTL_ID__1 | TIMER_A_CTL_SSEL__ACLK | TIMER_A_CTL_CLR
            | TIMER_A_CTL_MC__UP;
    TIMER_A1->CCR[0] = (1 << 15) - 1;     // 1 Hz
    TIMER_A1->CCTL[0] |= TIMER_A_CCTLN_CCIE; //Interrupciones activadas en CCR0
}

void main(void)
{
    WDTCTL = WDTPW + WDTHOLD;       // Stop watchdog timer

    //Inicializaciones:
    init_ucs_24MHz();
    init_botons();         //Configuramos botones y leds
    config_RGB_LEDS();
    init_interrupciones(); //Configurar y activar las interrupciones de los botones
    init_timers();

    __enable_interrupts();

    //Bucle principal (infinito):
    while (true)
    {
        ;
    }

}

#define CNT_MAX 100

volatile int8_t pwm_duty = 50;

void TA0_0_IRQHandler(void)
{
    static uint8_t cnt = 0;
	
	TA0CCTL0 &= ~TIMER_A_CCTLN_CCIFG; //Clear interrupt flag

	//TODO

}


void TA1_0_IRQHandler(void)
{
	//TODO
}

#define PWM_DUTY_CHANGE 10

/**************************************************************************
 * RUTINAS DE GESTION DE LOS BOTONES:
 * Mediante estas rutinas, se detectará qué botón se ha pulsado
 * 		 
 * Sin Datos de entrada
 * 
 * Sin datos de salida
 * 
 * Actualizar el valor de la variable global estado
 * 
 **************************************************************************/

//ISR para las interrupciones del puerto 1:
void PORT1_IRQHandler(void)
{
    uint8_t flag = P1IV; //guardamos el vector de interrupciones. De paso, al acceder a este vector, se limpia automaticamente.
    P1IE &= ~(SW1_BIT + SW2_BIT); //interrupciones del boton S2 en port 3 desactivadas

    switch (flag)
    {
    case SW1_INT:

        break;
    case SW2_INT:

        break;
    default:
        break;
    }

    P1IE |= (SW1_BIT + SW2_BIT);   //interrupciones S2 en port 3 reactivadas
}

