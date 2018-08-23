
import processing.io.*;
boolean ledOn = false;

int SPEED_OF_SOUND = 34300; //IN CM/Sec

void setup() {
  GPIO.pinMode(23, GPIO.OUTPUT);
  GPIO.pinMode(24, GPIO.INPUT);
  //Ensure pin is set to low
  GPIO.digitalWrite(23, GPIO.LOW);
}

int startTime, endTime;
void draw() {
  readDistance();
}

void readDistance() {
  GPIO.digitalWrite(23, GPIO.HIGH);
  try {
    Thread.sleep(0,1); //wait one nano second
  } 
  catch(InterruptedException ex) {
    Thread.currentThread().interrupt();
  }
  GPIO.digitalWrite(23, GPIO.LOW);
  //Sending......
  println("Pulse");
  while (GPIO.digitalRead(24) == GPIO.LOW) {
  }
  startTime = millis()*60;
  println("Recive");
  //Bounce back....
  while (GPIO.digitalRead(24) == GPIO.HIGH) {
  }
  endTime = millis()*60;
  int pulseDuration = startTime - endTime;

  //We measure the time there and back so divide by 2
  double distance = pulseDuration*SPEED_OF_SOUND/2;
  println("Distance:" + distance);
}

// cleanup on keypress
// this function, the pin will remain in the current state even after the sketch has been closed.
void keyPressed() {
  GPIO.releasePin(23);
  GPIO.releasePin(24);
  exit();
}