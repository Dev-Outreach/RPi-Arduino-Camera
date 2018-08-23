#define pResistor A0

#define ledPin 9

//Variables
int value;          // Store value from photoresistor (0-1023)

void setup(){
 pinMode(ledPin, OUTPUT); 
 pinMode(pResistor, INPUT);
 Serial.begin(9600);
}

void loop(){
  value = analogRead(pResistor);
  Serial.write(value);
  if (value > 25){
    digitalWrite(ledPin, LOW);
  }
  else{
    digitalWrite(ledPin, HIGH);
  }
}
