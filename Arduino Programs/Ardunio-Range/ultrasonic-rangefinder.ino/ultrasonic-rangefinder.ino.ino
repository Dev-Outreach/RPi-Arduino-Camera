#define trigPin 10
#define echoPin 13

void setup() {
  Serial.begin (9600);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
}

void loop() {
  float duration, distance;

  //Make sure the pin is off
  //ensures a clean signal
  digitalWrite(trigPin, LOW); 
  delayMicroseconds(2);

 //Send out a pulse
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  //stop the pulse
  digitalWrite(trigPin, LOW);

  //A timing function. When the echo pin goes into high, start timing
  //when it goes in to low, stop.
  //Returms time in microseconds
  duration = pulseIn(echoPin, HIGH);

  //Duration includes time to get there and back. So divide by 2
  // speed of sound is 340m/s or 1cm/29 microseconds
  distance = (duration / 2)/29;  //cm away
  
  if (distance >= 400 || distance <= 2){
    Serial.print("Distance = ");
    Serial.println("Out of range");
  }
  else {
    Serial.print("Distance = ");
    Serial.print(distance);
    Serial.println(" cm");
    delay(500);
  }
  delay(500);
}


