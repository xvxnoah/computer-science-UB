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
const long interval = 2000;

/*temps a una zona pel qual un jugador guanya*/
const long victoria = 5000;

void setup() {
  Serial.begin(9600);

  /*diem a Arduino que consideri el pin A0 com a INPUT*/
  pinMode(A0,INPUT);

}

void loop() {
  //variable que guardarà el temps actual
  unsigned long currentMillis;

  /*temps inicial per posicionar la mesura*/
  delay(interval);

  /*si el jugador 1 ja ha estat el temps necessàri a la zona baixa*/
  if(previousPlayer1 >= victoria){
    exit(0);
  }

  /*si el jugador 2 ja ha estat el temps necessàri a la zona alta*/
  if(previousPlayer2 >= victoria){
    exit(1);
  }
  
  /*analogRead ens permet fer la lectura analògica del voltatge en un punt*/
  lectura = analogRead(A0);
  Vo = lectura * (5.0 / 1023.0);
  Serial.println(Vo);
  Serial.print(",");
  Serial.println(Vn);

  /*mentre la mesura estigui a la zona baixa, calculem el temps */
  /*si sortim del while vol dir que hem pasat a la zona alta*/
  while(Vn > Vo){
    currentMillis = millis();
    
    /*si el jugador 1 ja ha estat el temps necessàri a la zona baixa*/
    if(previousPlayer1 >= victoria){
      exit(1);
    }

    /*anem sumant el temps que està acumulant el jugador a la zona baixa*/
    previousPlayer1 += currentMillis;
  } 


  /*mentre la mesura estigui a la zona alta, calculem el temps */
  /*si sortim del while vol dir que hem pasat a la zona baixa*/
  while(Vn < Vo){
    currentMillis = millis();
    
    /*si el jugador 2 ja ha estat el temps necessàri a la zona alta*/
    if(previousPlayer2 >= victoria){
      exit(0);
    }

    /*anem sumant el temps que està acumulant el jugador a la zona alta*/
    previousPlayer2 += currentMillis;
  }
  
  delay(100);
}
