/*Cops que s'ha descobert que un jugador ha passat
per sota la linea*/
int cops_descobert = 0;

/* Cops en què el jugador passa per sota la linea
sense ser descobert*/
int cops_no_descobert = 0;

//variable on guardem la lectura analògica en a A0
float lectura;

/*variable on es farà la conversió de la variable de lectura
(medició en A0) per obtenir el voltatge en A0*/
float Vo;

/*valor umbral per sobre el qual estarà el jugador (linea que ha de
travessar)*/
float Vn = 3.4;

//pin on estarà connectat el botó
const int buttonPin = 2; 

//variable que pot ser HIGH o LOW segons l'estat del botó
int buttonState = 0;

/*variable que guardarà l'últim cop que el jugador 1 passa per sota 
la linea*/
unsigned long previousMillis = 0;

/* variable que guardarà el temps màxim que té el jugador 1 per passar
per sota de la linea, si el supera, ha perdut el joc*/
const long interval = 2000;

void setup() {
  Serial.begin(9600);

  //diem a Arduino que consideri el pin A0 com a INPUT
  pinMode(A0,INPUT);

  //diem a Arduino que consideri el buttonPin com a INPUT
  pinMode(buttonPin, INPUT);
}

void loop() {
  //variable que guardarà el temps actual
  unsigned long currentMillis;
  
  /* Si el primer jugador no ha estat descobert per 5 intents,
  guanya el joc*/
  if(cops_no_descobert == 5){
    exit(0);
  }

  /* Si el segon jugador ha descobert 3 cops al primer jugador,
  guanya el joc*/
  if(cops_descobert == 3){
    exit(0);
  }

  
  //analogRead ens permet fer la lectura analògica del voltatge en un punt
  lectura = analogRead(A0);
  Vo = lectura * (5.0 / 1023.0);
  Serial.println(Vo);
  Serial.print(",");
  Serial.println(Vn);

  //lectura de l'estat del botó assignada a una variable
  buttonState = digitalRead(buttonPin);

  //si el botó està polsat
  if (buttonState == HIGH) {
    delay(10);
    //si la lectura del voltatge està per sota de la linea
    if (Vn>Vo){
      //incrementem els cops que s'ha descobert al jugador 1
      cops_descobert += 1;
    }
  } 
  //si el botó no està polsat
  else {
    delay(10);
    //si la lectura del voltatge està per sota de la linea
     if (Vn>Vo){
       //incrementem els cops que el jugador 1 no ha estat descobert
       cops_no_descobert += 1;
     } else{
      currentMillis = millis();
     }
  }
  delay(10);
}
