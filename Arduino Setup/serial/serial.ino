//Sample Serial Comunication Code.
//Note: Some of this code is imperfect. See Comments

#include <string.h>

//Try to find a device to communicate with
//Send out a signal until we get an expected response.
//Right now this continues indefinatly. 
void establishConnection() {
  while (Serial.available() <= 0) {
    Serial.println("Marco");
    delay(300);
  }
}

//Left and right motors (lights)
int left = 2;
int right = 3;

void setup() {
  //setp pins
  pinMode(left,OUTPUT);
  pinMode(right,OUTPUT);
  Serial.begin(9600);
  establishConnection();
}

String command = "";
bool connected = false;
void loop() {
  String temp1;
  String temp2;
  char inByte;

  // Input serial information:
  if (Serial.available() > 0) {
    inByte = Serial.read();
    // only input if a letter, number, =,?,+ are typed!
    if ((inByte >= 65 && inByte <= 90) || (inByte >= 97 && inByte <= 122) || (inByte >= 48 &&   inByte <= 57) || inByte == 43 || inByte == 61 || inByte == 63) {
      command.concat(inByte);
    }
  }// end serial.available
  //Process command when NL/CR are entered:
  if (inByte == 10 || inByte == 13) {

    inByte = 0;
    // Respond to a command:
    //Note all the if/ if else statemnets here. Peharps in would be clearer to use a switch statement?
    if (command.equalsIgnoreCase("polo")) {
      Serial.println("Connected");
      connected = true;
    }
    //If we have not recived a polo. Do nothing. The device does not know how to communicate with us.
    else if(!connected){
      continue;
    }
    else if (command.equalsIgnoreCase("hey")) {
      Serial.println("hello there!");
    }
    //It is a 2 Part Command
    else if (command.indexOf('=') > 0) {
      char carray[6];
      String direction = command.substring(0, command.indexOf('='));
      String value = command.substring(command.indexOf('=') + 1);
      value.toCharArray(carray, 6);
      int turn = atoi(carray);
      
      if (direction.equals("left")) {
        steerLeft(turn);
      }
      else if (direction.equals("right")) {
        steerRight(turn);
      }
      else if(direction.equals("forward")){
        forwards(turn);
      }
      Stop();
    }

    else if (command.startsWith("mynameis")) {

      temp1 = command.substring(8);
      Serial.print("Hello, ");
      Serial.println(temp1);

    }
    else if (command.equalsIgnoreCase("stop")){
      Serial.println("Waiting....");
      Stop();
    }
    else {

      if (!command.equalsIgnoreCase("")) {

        Serial.println("Invalid argument.");

      }
    }
    command = "";
  }
}


void steerLeft(int amount) {
  Serial.println("Turning Left ");
  digitalWrite(right, LOW);
  digitalWrite(left, HIGH);
  delay(amount);
}

void steerRight(int amount) {
  Serial.println("Turning Right ");
  digitalWrite(left, LOW);
  digitalWrite(right, HIGH);
  delay(amount);
}

void forwards(int amount) {
  Serial.println("Forwards");
  digitalWrite(left, HIGH);
  digitalWrite(right, HIGH);
  delay(amount);
}

//Example of bad practice not all the other functions start with lowercase
// we want to be consistant when defining functions to avoid errors.
// typically that meaning using standerds that have been set by the community/group
void Stop(){
  digitalWrite(left, LOW);
  digitalWrite(right, LOW); 
}


