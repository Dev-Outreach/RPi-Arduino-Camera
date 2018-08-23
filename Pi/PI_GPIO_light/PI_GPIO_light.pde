port processing.io.*;


void setup() {
  GPIO.pinMode(18, GPIO.INPUT);
}

void draw() {
  int reading = 0;
  while (GPIO.digitalRead(18) == GPIO.LOW) {
    reading += 1;
  }
  println(reading);
}


void keyPressed() {
  GPIO.releasePin(18);
  exit();
}