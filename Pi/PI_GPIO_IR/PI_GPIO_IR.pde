port processing.io.*;


void setup() {
  GPIO.pinMode(18, GPIO.INPUT);
}

void draw() {
  int reading = 0;
  while (GPIO.digitalRead(18) == GPIO.LOW) {
   //we are good
  }
  println("Obstacle Detected!");
}


void keyPressed() {
  GPIO.releasePin(18);
  exit();
}