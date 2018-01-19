//import de.voidplus.leapmotion.*;

//Setup
import com.leapmotion.leap.*;
Controller controller = new Controller();
Frame frame = controller.frame(); //This current frame


//Split screen
PGraphics pg[];
int winSize = 400;
int scrnSize = 3*winSize/4;
int screenCoords[] = {0,0};
float angleRotated = 0;
boolean notSet = true;

//Variables for the menu
boolean openMenu = false;
int menuCounter = 0;
int cornerThreshold = -800;
int maxMenuCount = 50;
int holdTime = 250;

int col1=150;
int col2=150;
int col3=150;

//Position
int x = 0;
int y = 0;
int z = 0;
int prevX = 0;
int prevY = 0;
int prevZ = 0;


//Gesture
public enum allGesture{SWIPE, POINTING, HANDOUT, PINCH, CIRCLE};
allGesture currGesture = allGesture.HANDOUT;
allGesture prevGesture = allGesture.HANDOUT;



//Mode
public enum mode{DRAWING3D, DRAGDROP, GRAPH};
mode currMode = mode.DRAWING3D;

void setup(){
  pg = new PGraphics[4];
  size(400,400,P3D);
  for(int i = 0; i < 4; i++){
      pg[i] = createGraphics(scrnSize, scrnSize, P3D);
  }
  controller.enableGesture(Gesture.Type.TYPE_CIRCLE);
}

void draw(){
  ///////SET UP FRAME AND HAND/////////
  background(0);//clear screen
  frame = controller.frame();
  Hand hand = frame.hands().frontmost(); //frontmost hand

  ////GET THE GESTURE
  if(checkPinch()) currGesture = allGesture.PINCH;
  if(checkPoint()) currGesture = allGesture.POINTING;
  if(checkCircle()) currGesture = allGesture.CIRCLE;
  if(checkHandout()) currGesture = allGesture.HANDOUT;
  if(checkSwipe() != 0) currGesture = allGesture.SWIPE;
  
  
  ////GET THE POSITION
  Vector pos = hand.palmPosition();
  y = -2*int(pos.getX());
  x = -2*int(pos.getY())+150;
  z = 2*int(pos.getZ());
  temp = new PVector(x,y,z);
  //println("x : "+ x + 
  //" y : "+ y +" z : "+ z);
  
  ////DRAWING//////
  switch (currMode) {
    case DRAWING3D:
      drawDrawing3d();
      break;
    case DRAGDROP:
      drawDrawing3d();
      break;
    case GRAPH:
      drawDrawing3d();
      break;
  }
  
  prevX = x;
  prevY = y;
  prevZ = z;
  prevGesture = currGesture;
}