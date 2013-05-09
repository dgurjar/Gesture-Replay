
// Giovanni
// Dev Gurjar (dgurjar)

#include <Servo.h>

//Positional 
#define LO 0
#define LOMID 45
#define MID 90
#define HI 150

Servo fingers[5];
char lastGesture = 'x';

void setup(){
  /* Setup the finger servos */
  fingers[0].attach(2);
  fingers[1].attach(3);
  fingers[2].attach(4);
  fingers[3].attach(5);
  fingers[4].attach(6);
  
  //inverse_point();
  
  
  fingers[0].write(LO);  
  fingers[1].write(LO);
  fingers[2].write(LO);
  fingers[3].write(LO);
  fingers[4].write(LO);
  
  
  Serial.begin(9600);
}

void loop(){
  if(Serial.available()){
    char inChar = (char)Serial.read();
    /* Depending on the incoming byte, perform the appropriate gesture */
    switch(inChar){
      case 'a':
        if(lastGesture != inChar)
          fist();
        break;
      case 'b':
        if(lastGesture != inChar)
          point();
        break;
      case 'c':
        if(lastGesture != inChar)
          weak_point(); 
        break;
      case 'd':
        if(lastGesture != inChar)
          open_fist(); 
        break;
      case 'e':
        if(lastGesture != inChar)
          slight_bend();
        break;
      case 'f':
        if(lastGesture != inChar)
          inverse_point();
      case 'g':
        if(lastGesture != inChar)
          pinch();
      default:
        break; 
    }
    delay(500);
  }
}



void fist(){
  // Move hand to starting position
  fingers[0].write(HI);  
  fingers[1].write(HI);
  fingers[2].write(HI);
  fingers[3].write(HI);
  fingers[4].write(HI);
  lastGesture = 'a';
}

void point(){
  // Move hand to starting position
  fingers[0].write(HI);  
  fingers[1].write(LO);
  fingers[2].write(HI);
  fingers[3].write(HI);
  fingers[4].write(HI);
  lastGesture = 'b';
}

void weak_point(){
  // Move hand to starting position
  fingers[0].write(HI);  
  fingers[1].write(MID);
  fingers[2].write(HI);
  fingers[3].write(HI);
  fingers[4].write(HI);
  lastGesture = 'c';
}

void open_fist(){
  // Move hand to starting position
  fingers[0].write(LO);  
  fingers[1].write(LO);
  fingers[2].write(LO);
  fingers[3].write(LO);
  fingers[4].write(LO);
  lastGesture = 'd';
}

void slight_bend(){
  // Move hand to starting position
  fingers[0].write(MID);  
  fingers[1].write(MID);
  fingers[2].write(MID);
  fingers[3].write(MID);
  fingers[4].write(MID);
  lastGesture = 'e';
}

void very_slight_bend(){
  fingers[0].write(LOMID);
  fingers[1].write(LOMID);
  fingers[2].write(LOMID);
  fingers[3].write(LOMID);
  fingers[4].write(LOMID);
}

void inverse_point(){
  fingers[0].write(LO);
  fingers[1].write(MID);
  fingers[2].write(LO);
  fingers[3].write(LO);
  fingers[4].write(LO);
  lastGesture = 'f';  
}

void pinch(){
  fingers[0].write(HI);
  fingers[1].write(HI);
  fingers[2].write(LOMID);
  fingers[3].write(LOMID);
  fingers[4].write(LOMID);
  lastGesture = 'g';
}


