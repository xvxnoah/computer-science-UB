/******************************
 *
 * Practica_03_PAE Timers i interrupcions
 * UB, 03/2022.
 * Alejandro Guzman & Noah Marquez
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

/* Variables per saber el flag d'interrupcio dels joysticks */
#define JSTK5_INT 0x0C /* Joystick dreta i avall */
#define JSTK4_INT 0x0A /* Joystick amunt */
#define JSTK7_INT 0x10 /* Joystick esquerra */

/* Estructura que ens definira el patro a seguir pels LEDS RGB:
 * -> 'r' fa referencia a RED (true: ences, false: apagat)
 * -> 'g' fa referencia a GREEN (true: ences, false: apagat)
 * -> 'b' fa referencia a BLUE (true: ences, false: apagat)
 * -> 'time' fa referencia al temps que s'haura de mantenir en el present
 * color
 *  */
typedef struct
{
    bool r, g, b;
    uint8_t time;
} color_t;

/* Fent us de l'estructura creem la sequencia de colors que hauran de seguir
 * els LEDS RGB de la placa */
color_t color_sequence[] = { { .r = true, .g = false, .b = false, .time = 2 },
                             { .r = true, .g = true, .b = false, .time = 1 },
                             { .r = false, .g = true, .b = false, .time = 3 },
                             { .r = false, .g = false, .b = true, .time = 2 },
                             { .r = true, .g = true, .b = true, .time = 1 }
                           };


/**************************************************************************
 * INICIALIZACION DEL CONTROLADOR DE INTERRUPCIONES (NVIC).
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

    //Int. port 4 = 38 correspon al bit 6 del segon registre ISER1 (Joysticks dreta i esquerra):
    NVIC->ICPR[1] |= 1 << (PORT4_IRQn & 31); //Primero, me aseguro de que no quede ninguna interrupcion residual pendiente para este puerto,
    NVIC->ISER[1] |= 1 << (PORT4_IRQn & 31); //y habilito las interrupciones del puerto

    //Int. port 5 = 39 correspon al bit 7 del segon registre ISER1 (Joysticks amunt i avall):
    NVIC->ICPR[1] |= 1 << (PORT5_IRQn & 31); //Primero, me aseguro de que no quede ninguna interrupcion residual pendiente para este puerto,
    NVIC->ISER[1] |= 1 << (PORT5_IRQn & 31); //y habilito las interrupciones del puerto

    //Int. Timer_A0 correspon al bit 8 del primer registre ISER0:
    NVIC->ICPR[0] |= BIT8; //Primero, me aseguro de que no quede ninguna interrupcion residual pendiente para este puerto,
    NVIC->ISER[0] |= BIT8; //y habilito las interrupciones del puerto

    //Int. Timer_A1 correspon al bit 10 del primer registre ISER0:
    NVIC->ICPR[0] |= BITA; //Primero, me aseguro de que no quede ninguna interrupcion residual pendiente para este puerto,
    NVIC->ISER[0] |= BITA; //y habilito las interrupciones del puerto
}

/**************************************************************************
 * INICIALIZACIO DEL LED DEL BOOSTERPACK MK II.
 *
 * Sin datos de entrada
 *
 * Sin datos de salida
 *
 **************************************************************************/
void init_botons(void)
{
    /* Configurem el LED vermell (els polsadors S1 i S2 no s'han inicialitzat
     * ja que en aquesta practica no es fan servir */
    //***************************
    // El LED vermell es GPIOs
    P1SEL0 &= ~(BIT0);
    P1SEL1 &= ~(BIT0);

    //LED vermell = P1.0
    P1DIR |= LED_V_BIT; //El LED es una sortida
    P1OUT &= ~LED_V_BIT; //El estat inicial del LED es apagat

}

/**************************************************************************
 * INICIALIZACIO DELS JOYSTICKS DEL BOOSTERPACK MK II.
 *
 * Sin datos de entrada
 *
 * Sin datos de salida
 *
 **************************************************************************/
void init_joysticks(void){
    // Els Joysticks son GPIOs (el joystick centre no s'ha utilitzat en aquesta practica)
    P4SEL0 &= ~(BIT5 + BIT7);
    P4SEL1 &= ~(BIT5 + BIT7);
    P5SEL0 &= ~(BIT4 + BIT5);
    P5SEL1 &= ~(BIT4 + BIT5);

    // Els joysticks son entrades
    P4DIR &= ~(BIT5 + BIT7);
    P5DIR &= ~(BIT4 + BIT5);

    // Pull-up/Pull-down pels joysticks
    P4REN |= (BIT5 + BIT7);
    P5REN |= (BIT4 + BIT5);

    // Donat que l'altre costat es GND, volem una pull-up
    P4OUT |= (BIT5 + BIT7);
    P5OUT |= (BIT4 + BIT5);

    /* Interrupcions */
    // Activem les interrupcions
    P4IE |= (BIT5 + BIT7);
    P5IE |= (BIT4 + BIT5);

    // Amb transicio L->H
    P4IES &= ~(BIT5 + BIT7);
    P5IES &= ~(BIT4 + BIT5);

    // Netegem les interrupcions anteriors
    P4IFG = 0;
    P5IFG = 0;
}

/*****************************************************************************
 * CONFIGURACION DE LOS LEDs RGB. A REALIZAR POR EL ALUMNO
 *
 * Sin datos de entrada
 *
 * Sin datos de salida
 *
 ****************************************************************************/
void config_RGB_LEDS(void)
{
    //LEDs RGB = P2.4, P2.6, P5.6
    P2SEL0 &= ~(BIT4 + BIT6);  // P2.4, P26 son GPIOs
    P2SEL1 &= ~(BIT4 + BIT6);  // P2.4, P2.6 son GPIOs
    P5SEL0 &= ~(BIT6); // P5.6 es GPIO
    P5SEL1 &= ~(BIT6); // P5.6 es GPIO


    P2DIR |= (BIT4 + BIT6); //Els LEDs son sortides
    P5DIR |= (BIT6); // Els LEDs son sortides
    P2OUT &= ~(BIT4 + BIT6); //El seu estat inicial sera apagat
    P5OUT &= ~(BIT6); //El seu estat inicial sera apagat

}

/**************************************************************************
 * INICIALIZACIO DELS TIMERS DEL BOOSTERPACK MK II.
 *
 * Sin datos de entrada
 *
 * Sin datos de salida
 *
 **************************************************************************/
void init_timers(void)
{
    //Timer A0, used for red LED PWM
    //Divider = 1; CLK source is SMCLK; clear the counter; MODE is up
    TIMER_A0->CTL = TIMER_A_CTL_ID__1 | TIMER_A_CTL_SSEL__SMCLK | TIMER_A_CTL_CLR | TIMER_A_CTL_MC__UP;
    TIMER_A0->CCR[0] = (.001 * 24000000) - 1; // 10 KHz (0.1 ms)
    TIMER_A0->CCTL[0] |= TIMER_A_CCTLN_CCIE; // Capture & Compare enabled (interrupcions activades a CCR0)


    //Timer A1, used for RGB LEDs
    //Divider = 1; CLK source is ACLK; clear the counter; MODE is up
    TIMER_A1->CTL = TIMER_A_CTL_ID__1 | TIMER_A_CTL_SSEL__ACLK | TIMER_A_CTL_CLR
            | TIMER_A_CTL_MC__UP;
    TIMER_A1->CCR[0] = (1 << 15) - 1;     // 1 Hz (1 s)
    TIMER_A1->CCTL[0] |= TIMER_A_CCTLN_CCIE; //Interrupciones activadas en CCR0
}

void main(void)
{
    WDTCTL = WDTPW + WDTHOLD;       // Stop watchdog timer

    //Inicializaciones:
    init_ucs_24MHz(); // Amb aquesta funcio, l'ACLK ens queda a 37268 Hz i SMCLK a 24 MHz.
    init_botons(); // Configurem el LED vermell
    init_joysticks(); // Configurem els Joysticks que farem servir
    config_RGB_LEDS(); // Configuracio dels LEDS RGB que farem servir
    init_interrupciones(); //Configurar y activar les interrupcions dels botons
    init_timers(); // Inicialitzem els timers (fonamentals en aquesta pràctica)

    __enable_interrupts(); // Habilitem les interrupcions a nivell global del microcontrolador.

    //Bucle principal (infinit):
    while (true)
    {
        ;
    }

}

/* Valors maxims i minims que pot valdre la nostra variable comptador */
#define CNT_MAX 100
#define CNT_MIN 0

/* Variable que marca el valor on s'apaga el LED vermell */
volatile int8_t pwm_duty = 50;

/* Variable que anira guardant el temps/cops que entrem a la interrupcio pel timer (cada 1 segon pel
 * timer A1) per tal de comprovar si hem de canviar al seguent color del patro o si l'hem de mantenir */
volatile int8_t aux_TA1 = 1;

/* Variable que ens servira per recorrer l'array color_sequence que hem declarat al principi del programa */
volatile int8_t index_TA1 = 0;

/* Variable que podra incrementar o disminuir la variable pwm_duty segons les accions que fem amb els
 * joysticks (tambe podra incrementar o decrementar el seu valor en 5) */
static uint8_t step = 0;


/**************************************************************************
 * RUTINES DE GESTIO DELS TIMERS:
 * Mitjançant les due següents rutines realitzarem les accions requerides pel timer A0 i el timer A1.
 *
 * Sense dades d'entrada
 *
 * Sense dades de sortida
 *
 * Timer A0 -> Modificar la intensitat de la llum del LED vermell.
 * Timer A1 -> Generar un patro de colors amb els LEDS RGB.
 *
 **************************************************************************/

// Interrupcio al timer A0 (rutina d'atencio a la interrupcio directa)
void TA0_0_IRQHandler(void)
{
    // Variable comptador que anira de 0 a 100
    static uint8_t cnt = 0;

    TA0CCTL0 &= ~TIMER_A_CCTLN_CCIFG; //Clear interrupt flag

    // Si el comptador ha arribat al maxim (100) encenem el LED vermell i tornem el comptador a 0
    if (cnt == CNT_MAX){
        P1OUT |= LED_V_BIT;
        cnt = 0;
    }
    /* Si el comptador val el mateix que el pwm_duty, vol dir que hem d'apagar el LED vermell i seguir
     * comptant. */
    else if(cnt == pwm_duty){
        P1OUT &= ~LED_V_BIT;
        cnt++;
    }
    // Altrament seguim comptant
    else{
        cnt++;
    }
}

// Interrupcio al timer A1 (rutina d'atencio a la interrupcio directa)
void TA1_0_IRQHandler(void)
{
    TA1CCTL0 &= ~TIMER_A_CCTLN_CCIFG; //Clear interrupt flag

    /* Variable de tipus color_t (struct) on anirem guardan els diferents vectors que es troben dins l'array
     * color_sequence, on a dins de cada vector es troba la informacio per tal de generar el patro de colors
     * demanat. */
    color_t iter = color_sequence[index_TA1];

    /* Per cada color comprovem si la seva variable es true o false, en cas de que sigui true encenem el LED,
     * sino l'apaguem. */
    if (iter.r){
        P2OUT |= BIT6;
    }else{
        P2OUT &= ~(BIT6);
    }
    if(iter.g){
        P2OUT |= BIT4;
    }else{
        P2OUT &= ~(BIT4);
    }
    if(iter.b){
        P5OUT |= BIT6;
    }else{
        P5OUT &= ~(BIT6);
    }

    /* Si el time del vector es diferent al comptador pel time que hem declarat, voldra dir que encara hem de
     * seguir amb el present color en el patro, per tant nomes augmentem la nostra variable auxiliar i continuem
     * amb el programa. */
    if(iter.time!=aux_TA1){
        aux_TA1++;
    }
    /* En cas de que ja s'hagi complert el temps pel present color en el patro, tornem a situar la variable auxiliar
     * al seu valor inicial. */
    else{
        aux_TA1 = 1;

        /* Si hem arribat al final de la sequencia, tornem a situar l'index a 0 per tal de començar un altre cop. */
        if (index_TA1 == (sizeof(color_sequence)/sizeof(color_sequence[0]))){
            index_TA1 = 0;
        }
        // Si encara no ens trobem al final de la sequencia, augmentem l'index per tal de seguir amb el seguent color del patro
        else{
            index_TA1++;
        }
    }
}

/**************************************************************************
 * RUTINES DE GESTIO DELS BOTONS:
 * Mitjançant aquestes rutines detectem quin boto s'ha polsat
 *
 * Sin Datos de entrada
 *
 * Sin datos de salida
 **************************************************************************/

// ISR per les interrupcions del port 4:
void PORT4_IRQHandler(void)
{
    uint8_t flag = P4IV; // Guardem el vector d'interrupcions. A mes, a l'accedir a aquest vector, es neteja automaticament
    P4IE &= ~(BIT5 + BIT7); // Interrupcions dels joysticks centre, dreta i esquerra desactivades

    switch (flag) // El joystick centre no s'ha utilitzat en aquesta practica
    {
    /* Joystick dreta -> Incrementa la variable step en 5 */
    case JSTK5_INT:
        step += 5;
        break;

    /* Joystick esquerra -> Decrementa la variable step en 5 */
    case JSTK7_INT:
        step -= 5;
        break;
    }

    // Interrupcions activades un altre cop
    P4IE |= (BIT5 + BIT7);
}

// ISR per les interrupcions del port 5:
void PORT5_IRQHandler(void)
{
    uint8_t flag = P5IV; // Guardem el vector d'interrupcions. A mes, a l'accedir a aquest vector, es neteja automaticament
    P5IE &= ~(BIT4 + BIT5); // Interrupcions dels joysticks amunt i avall desactivades

    switch (flag)
    {
    /* Joystick amunt -> pwm_duty es veu incrementat una quantitat donada per la varible step */
    case JSTK4_INT:
        pwm_duty += step;

        /* Hem de controlar que pwm_duty no sigui mes gran que el maxim (100)*/
        if (pwm_duty > CNT_MAX){
            pwm_duty = CNT_MAX;
        }
        break;

    /* Joystick avall -> pwm_duty es veu decrementat una quantitat donada per la varible step */
    case JSTK5_INT:
        pwm_duty -= step;

        /* Hem de controlar que pwm_duty no sigui mes petita que el minim (0)*/
        if (pwm_duty < CNT_MIN){
            pwm_duty = CNT_MIN;
        }
        break;
    }

    // Interrupcions activades un altre cop
    P5IE |= (BIT4 + BIT5);
}
