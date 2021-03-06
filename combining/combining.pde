//Setup
import com.leapmotion.leap.*;
Controller controller = new Controller();
Frame frame = controller.frame(); //This current frame


//Split screen
PGraphics pg[];
PGraphics menu;
int winSize = 1000;
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
int minX = -500;
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
int numModes = 3;
public enum mode{DRAWING3D, DRAGDROP, GRAPH};
mode currMode = mode.DRAGDROP;
PImage[] modeImgs = new PImage[numModes];
PImage[] drawImgs = new PImage[2];
void setup(){
  pyrSet();
  pg = new PGraphics[4];
  menu = createGraphics(scrnSize, scrnSize, P3D);
  size(1000,1000,P3D);//displayWidth,displayHeight,P3D);
  for(int i = 0; i < 4; i++){
      pg[i] = createGraphics(scrnSize, scrnSize, P3D);
  }
  controller.enableGesture(Gesture.Type.TYPE_CIRCLE);
  modeImgs[0] = loadImage("draw.png");
  modeImgs[1] = loadImage("graph.png");
  modeImgs[2] = loadImage("dragdrop.png");
  
  drawImgs[0] = loadImage("color.png");
  drawImgs[1] = loadImage("linethick.png");
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
  //println("x : "+ x + 
  //" y : "+ y +" z : "+ z);
  
  ////DRAWING//////
  switch (currMode) {
    case DRAWING3D:
      drawDrawing3d();
      break;
    case DRAGDROP:
      drawDragDrop();
      break;
    case GRAPH:
      drawDrawing3d();
      //UNCOMMENT THIS LATER WHEN PRATYUSHA COMES
      //drawGraph();
      break;
  }
  
  prevX = x;
  prevY = y;
  prevZ = z;
  prevGesture = currGesture;
  println("MODEEE");
  println(currMode);
}