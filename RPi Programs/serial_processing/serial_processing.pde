import processing.serial.*; //import the Serial library
 Serial myPort;  //the Serial port object
 String val;
 boolean firstContact = false;

void setup() {
  size(200, 200);
  //Port the Ardurion is at can use serial.list() to find out
  myPort = new Serial(this, Serial.list()[4], 9600);
  myPort.bufferUntil('\n'); 
}


void serialEvent( Serial myPort) {
//the '\n' is our end delimiter indicating the end of a complete packet
val = myPort.readStringUntil('\n');
if (val != null) {
  //trim whitespace and formatting characters (like carriage return)
  val = trim(val);
  println(val);

  //look for our 'A' string to start the handshake
  //if it's there, clear the buffer, and send a request for data
  if (firstContact == false) {
    if (val.equals("Marco")) {
      myPort.clear();
      firstContact = true;
      myPort.write("Polo");
      println("contact");
    }
  }
  else { //if we've already established contact, keep getting and parsing data
    //process val here
    println(val);

    // Send Commands HERE
    myPort.write("hello");
    }
  }
}