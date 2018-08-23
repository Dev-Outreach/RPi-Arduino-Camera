import processing.io.*;
boolean ledOn = false;

int SPEED_OF_SOUND = 34300; //IN CM/Sec

void setup() {
  GPIO.pinMode(23, GPIO.INPUT);
  GPIO.pinMode(24, GPIO.INPUT);
}

void draw() {
  if(GPIO.digitalRead(23) == GPIO.HIGH)
    avoidLeft();
   else
     avoidRight();
}

void avoidLeft(){
  println("LEFT");
}

void avoidRight(){
  println("RIGHT");
}

// cleanup on keypress
// this function, the pin will remain in the current state even after the sketch has been closed.
void keyPressed() {
  GPIO.releasePin(23);
  GPIO.releasePin(24);
  exit();
}