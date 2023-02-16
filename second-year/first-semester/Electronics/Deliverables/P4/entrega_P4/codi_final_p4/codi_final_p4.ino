//*****************************
//***     P4 - Transistors  ***
//*** Joc llum verda, llum  ***
//*** vermella              ***
//***                       ***
//*****************************

//Fitxer que relaciona text amb les freqüències de notes musicals
#include "notes_frequencies.h"

// Marge de temps que té el jugador per despolsar el polsador
int tempsPerCanviar = 800;

// Cada quan generem una nota (indicant llum vermella / llum verda), serà aleatori (mínim 2000, màxim 3000 ms)
int tempsRandom = random(2000, 3000);

// Temps necessari que haurà d'haver polsat el jugador per guanyar
double tempsNecessari = 0;

// Temps actual
int tempsActual = 0;

// Temps total que ha polsat el jugador
int tempsPolsat = 0;

//Notes
//01
//Notes (): (C:Do, D:Re, E:Mi, F:Fa, G: Sol, A:La, B:Si)
unsigned int notes[] = {NA4,ND4,NF4,NG4,NA4,ND4,NF4,NG4,NE4,NG4,NC4,NF4,NE4,NG4,NC4,NF4,NE4,ND4,ND4};
//Duracio notes en millisegons
unsigned int duracio_notes[] = {6000,6000,1000,1000,4000,4000,1000,1000,12000,6000,6000,1000,1000,4000,6000,1000,1000,4000,6000};

// Número de notes que tenim (extret del vector)
unsigned numNotes = sizeof(notes)/sizeof(notes[0]);

// Pins on connectem el polsador i l'altaveu, respectivament
const int button = 8;
const int speaker = 5;

// Pin on tenim el LED a la placa Arduino
const int LEDPin = 2;

// Variable que guardarà el temps d'inici de la nota
int iniciNota = 0;

// Iniciem un button_state per veure si el botó es troba HIGH (apagat) o LOW (encès) ja que és PULLUP
int button_state = 0;

// Variable auxiliar que anirà guardant el temps que sona la nota mentre el jugador està polsant el
// polsador, si s'acaba la nota i no ha deixat de prèmer abans que s'acabi el temps de cortèsia indicat,
// no se li sumarà aquest temps
double tempsPolsantNota = 0;

void setup() {
  Serial.begin(9600);

  // Assignem el LED a LOW
  digitalWrite(LEDPin, LOW);
  
  // PinMode pel nostre polsador
  pinMode(button, INPUT_PULLUP);

  // PinMode pel nostre altaveu
  pinMode(speaker, OUTPUT);

  // Fem el càlcul del mínim temps que haurà d'estar el jugador polsant per tal de guanyar
  for(int i = 0; i < sizeof(notes); i++){
    tempsNecessari += duracio_notes[i]/2;
  }
}


void loop() {

  // For per anar iterant per totes les notes que es trobin dins de la llista de notes (nota x nota)
  for(int i = 0; i < numNotes; i++){
    
    // Reprodueix el to a la freqüència de la nota actual i es manté sonant fins que acabi el temps definit per aquesta nota
    tone(speaker, notes[i], duracio_notes[i]);

    // Guardem el temps en què comença la nota
    iniciNota = millis();

    // Guardem el temps actual (s'anirà actualitzant a continuació)
    tempsActual = millis();

    // Ara mentre duri la nota, comprovarem l'estat del polsador per sumar o no el temps al jugador
    while(millis() - iniciNota < duracio_notes[i]){
      button_state = digitalRead(button);

      // Si està polsat, anem guardant el temps a una variable auxiliar
      if(button_state == LOW){
        tempsPolsantNota += millis() - tempsActual;
      }

      // Actualitzem el temps actual
      tempsActual = millis();
    }

    // Deixem un temps (800ms) per tal de que el jugador deixi de prèmer
    delay(tempsPerCanviar);

    button_state = digitalRead(button);
    
    // Comprovem que efectivament ha deixat de polsar
    if(button_state == HIGH){
      tempsPolsat += tempsPolsantNota;
    }

    // Posem el comptador del temps que hem polsat una nota a 0
    tempsPolsantNota = 0;
    
    // Ens esperem un temps aleatori fins que soni la següent nota
    delay(tempsRandom);
  }

  // Quan acaba el for s'han acabat les notes, em de comprovar si el jugador ha guanyat
  // Ho indicarem amb un missatge i encenent el LED, per desprès sortir del programa
  if(tempsPolsat >= tempsNecessari){
    Serial.println("Has guanyat!");
    digitalWrite(LEDPin, HIGH);
    delay(100);
    exit(0);
  }

}
