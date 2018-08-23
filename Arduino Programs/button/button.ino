#define LEDPIN 13
#define INPIN 2

int state = LOW;

void setup() {
  Serial.begin(9600); //For Serial Monitor
  pinMode(LEDPIN, OUTPUT);
  pinMode(INPIN, INPUT);
}

void loop() {
  delay(10); // debounces switch
  int sensorValue = digitalRead(INPIN);
  
  //When the button is pressed turn the light on/off
  //This can be used to:
  // Start serial communication
  //Start/Stop the robot (in the case of a line follower)
  if(state != sensorValue) {
    state = sensorValue; 
    digitalWrite(LEDPIN, sensorValue);
    Serial.println(sensorValue, DEC); //For Serial Monitor
  }
}
