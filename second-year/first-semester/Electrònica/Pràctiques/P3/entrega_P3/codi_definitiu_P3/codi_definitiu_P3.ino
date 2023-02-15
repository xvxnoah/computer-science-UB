/*variable on guardem la lectura analògica en a A0*/
float lectura;

/*variable on es farà la conversió de la variable de lectura
(medició en A0) per obtenir el voltatge en A0*/
float Vo;

/*valor umbral per separar zona alta i zona baixa*/
float Vn = 3.4;

/*variable que guardarà el tems que ha estat el jugador 1 a la zona baixa*/
unsigned long previousPlayer1 = 0;

/*variable que guardarà el tems que ha estat el jugador 2 a la zona alta*/
unsigned long previousPlayer2 = 0;

/*temps inicial que donarem per posicionar la mesura al centre de les dues zones*/
const long interval = 200;

/*temps a una zona pel qual un jugador guanya*/
const long victoria = 5000;

void setup() {
  Serial.begin(9600);

}

void loop() {
  //variable que guardarà el temps actual
  unsigned long currentMillis;

  /*temps inicial per posicionar la mesura*/
  delay(interval);
  
  /*analogRead ens permet fer la lectura analògica del voltatge en un punt*/
  lectura = analogRead(A0);
  Vo = lectura * (5.0 / 1023.0);
  Serial.print(Vo);
  Serial.print(",");
  Serial.println(Vn);

  /*mentre la mesura estigui a la zona baixa, calculem el temps */
  /*si sortim del while vol dir que hem pasat a la zona alta*/
  while(Vn > Vo){
    currentMillis = millis();
    
    /*anem sumant el temps que està acumulant el jugador a la zona baixa*/
    previousPlayer1 += currentMillis;
    
    /*si el jugador 1 ja ha estat el temps necessàri a la zona baixa*/
    if(previousPlayer1 >= victoria){
      Serial.print("Jugador 1 guanya");
    }
  } 


  /*mentre la mesura estigui a la zona alta, calculem el temps */
  /*si sortim del while vol dir que hem pasat a la zona baixa*/
  while(Vn < Vo){
    currentMillis = millis();

    /*anem sumant el temps que està acumulant el jugador a la zona alta*/
    previousPlayer2 += currentMillis;
    
    /*si el jugador 2 ja ha estat el temps necessàri a la zona alta*/
    if(previousPlayer2 >= victoria){
      Serial.print("Jugador 2 guanya");
    }
  }
  
  delay(100);
}
