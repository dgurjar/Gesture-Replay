import processing.serial.*;
import ddf.minim.*;

/* Audio player */
Minim minim;
AudioPlayer player;

/* Time start */
int startMinute, startSecond;
int start;

/* Buffer of last gesture sent */
char lastGesture;
String lastSub;

/* Hash of actions that need to be performed */
HashMap actions;

/* File reading */
BufferedReader reader;

/* Serial */
Serial port;

void setup(){
  //size(displayWidth, displayHeight);
  size(600, 100);
  
  /* Serial Port for Arduino */
  println(Serial.list());
  port = new Serial(this, Serial.list()[4], 9600); 
  
  /* Load hash table with gestures from file */
  reader = createReader("slapchop.csv");
  actions = new HashMap();
  String line = "";
  
  while(line != null){
    try {
      line = reader.readLine();
    } catch (IOException e) {
      e.printStackTrace();
      line = null;
    }
    
    /* Get action from the file */
    if(line != null){
      
      String[] parts = line.split(",");
      
      int time = Integer.parseInt(parts[0]);
      Character gesture;
      String sub;
            
      if(parts[1].length() > 0)
        gesture = parts[1].charAt(0);
      else
        gesture = 'x';
      
      /*
      if(!parts[2].equals(" "))
        sub = parts[2];
      else
        sub = null;
      
      */
      
      HandAction action = new HandAction(time, gesture, null);
      actions.put(time, action);
    }
  }
  
  background(0);
  stroke(255);

  /* Set the audio player */
  minim = new Minim(this);
  player = minim.loadFile("slapchop.mp3");
  player.play();
 
  startSecond = second();
  startMinute = minute();
  start = startSecond + 60*startMinute;
}

void draw(){ 
  /* Check hash table with time, perform action if there is a matching time */
   HandAction currentAction = (HandAction)actions.get(elapsedSeconds());
   if(currentAction != null){
     currentAction.perform();
   }
}


void keyPressed(){
  if(key == ' '){
    int seconds = elapsedSeconds()+1;
    //Reset isPerformed
    for(int i=0; i<seconds; i++){
     HandAction currentAction = (HandAction)actions.get(i);
     if(currentAction != null){
       currentAction.reset();
     }    
    }
    
    //Restart the player
    player.rewind();
    player.play();
    
    //Reset the time
    startSecond = second();
    startMinute = minute();
    start = startSecond + 60*startMinute;
  }
}

/* Returns the elapsed time from the start of the program in seconds */
int elapsedSeconds(){
  return second() + 60*minute() - start;
}


class HandAction {
  private boolean isComplete;
  private int time;
  private String sub;
  private Character gesture;
  
  HandAction(int time, char gesture, String sub){
    this.time = time;
    this.sub = sub;
    this.gesture = gesture;
    isComplete = false;
  }
  
  public void perform(){
    if(isComplete)
      return;
      
    /* If appropriate, draws subtitle to screen */
    if(sub != null){
      background(0);
      textAlign(CENTER);
      textSize(35); 
      text(sub, width/2, height/2);
    }
    
    /* If appropriate, sends gesture byte to the hand */
    if(gesture != 'x'){
      println("Writing gesture: " + (char)gesture);
      port.write((char)gesture);
    }
    
    isComplete = true;
  }
  
  public void reset(){
    isComplete = false;
  }
  
  /* For Debuggging */
  public String toString(){
    return "Time: " + time + "\nSub:" + sub + "\nGesture:" + gesture + "\n";
  }
}
