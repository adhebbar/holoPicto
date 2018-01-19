<<<<<<< HEAD
//Setup
import com.leapmotion.leap.*;
Controller controller = new Controller();
Frame frame = controller.frame(); //This current frame


//Split screen
PGraphics pg[];
PGraphics menu;
int winSize = 600;
int scrnSize = 3*winSize/4;
int screenCoords[] = {0,0};
float angleRotated = 0;
boolean notSet = true;


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
PImage img;

void setup(){
  pg = new PGraphics[4];
  menu = createGraphics(scrnSize, scrnSize, P3D);
  size(600,600,P3D);
  for(int i = 0; i < 4; i++){
      pg[i] = createGraphics(scrnSize, scrnSize, P3D);
  }
  controller.enableGesture(Gesture.Type.TYPE_CIRCLE);
  img = loadImage("color.png");
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
=======
//Setup
import com.leapmotion.leap.*;
Controller controller = new Controller();
Frame frame = controller.frame(); //This current frame


//Split screen
PGraphics pg[];
PGraphics menu;
int winSize = 400;
int scrnSize = 3*winSize/4;
int screenCoords[] = {0,0};
float angleRotated = 0;
boolean notSet = true;


//Position
int x = 0;
int y = 0;
int z = 0;
int prevX = 0;
int prevY = 0;
int prevZ = 0;
int minX = -800;
int maxX = 150;
int minY = -300;
int maxY = 300;
int minZ = -scrnSize;
int maxZ = scrnSize;



//Gesture
public enum allGesture{SWIPE, POINTING, HANDOUT, PINCH, CIRCLE};
allGesture currGesture = allGesture.HANDOUT;
allGesture prevGesture = allGesture.HANDOUT;



//Mode
public enum mode{DRAWING3D, DRAGDROP, GRAPH};
mode currMode = mode.DRAWING3D;
PImage img;

void setup(){
  pg = new PGraphics[4];
  menu = createGraphics(scrnSize, scrnSize, P3D);
  size(400,400,P3D);
  for(int i = 0; i < 4; i++){
      pg[i] = createGraphics(scrnSize, scrnSize, P3D);
  }
  controller.enableGesture(Gesture.Type.TYPE_CIRCLE);
  img = loadImage("color.png");
}

void draw(){
  ///////SET UP FRAME AND HAND/////////
  background(0);//clear screen
  frame = controller.frame();
  Hand hand = frame.hands().frontmost(); //frontmost hand

  ////GET THE GESTURE
  getGesture();
  
  
  ////GET THE POSITION
  com.leapmotion.leap.Vector pos = hand.palmPosition();
  y = -2*int(pos.getX());
  x = -2*int(pos.getY())+150;
  z = 2*int(pos.getZ());
  temp = new PVector(x,y,z);
  println("x : "+ x + 
  " y : "+ y +" z : "+ z);
  
  ////DRAWING//////
  switch (currMode) {
    case DRAWING3D:
      drawDrawing3d();
      break;
    case DRAGDROP:
      drawDrawing3d();
      break;
    case GRAPH:
      drawGraph();
      break;
  }
  
  prevX = x;
  prevY = y;
  prevZ = z;
  prevGesture = currGesture;
>>>>>>> f75363feb2651e9399d9c8ba1a2b8ac503d40770
}