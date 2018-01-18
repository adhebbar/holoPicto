//import de.voidplus.leapmotion.*;

import com.leapmotion.leap.*;
Controller controller = new Controller();

boolean openMenu = false;
boolean notSet = true;

//To make it a smoother line
int circleCount =0;
int menuCounter = 0;
int cornerThreshold = -800;
int maxMenuCount = 50;
int holdTime = 250;

int col1=150;
int col2=150;
int col3=150;

ArrayList<PVector> points = new ArrayList<PVector>(); //current stroke
ArrayList<ArrayList> strokes = new ArrayList<ArrayList>(); //array of all strokes
ArrayList<Float> angles = new ArrayList<Float>();
PVector temp;
boolean currDrawModeOn = false;
boolean prevDrawModeOn = false;
boolean eraseCommand = false;
Frame frame = controller.frame(); //This current frame

//To make it a smoother line
int jump = 20;
int x = 0;
int y = 0;
int z = 0;
int prevX = 0;
int prevY = 0;
int prevZ = 0;

PGraphics pg[];
int winSize = 400;
int scrnSize = 3*winSize/4;
int screenCoords[] = {0,0};

float angleRotated = 0;

void setup(){
  pg = new PGraphics[4];
  size(400,400,P3D);
  for(int i = 0; i < 4; i++){
      pg[i] = createGraphics(scrnSize, scrnSize, P3D);
  }
}

void draw(){
  ///////SET UP FRAME AND HAND/////////
  background(0);//clear screen
  frame = controller.frame(); 
  if (checkPinch(frame)) currDrawModeOn = true;
  else currDrawModeOn = false;

  //Check for erase command  
  if (checkCircle(frame)) circleCount++;
  if(circleCount%30==0)
  {
    eraseCommand = true;
    circleCount =0;
  }
  
  // erase if required
  if(eraseCommand && (strokes.size()>0)) //delete current stroke
  {
     currDrawModeOn = false;
     //points = strokes.get(strokes.size()-1); //make current stroke last stroke
     strokes.remove(strokes.size()-1); //remove last stroke from history
     points = new ArrayList<PVector>();
  }
  
  ///////////CHECKING SWIPE/////////
  int swipe = checkSwipe(frame); 
  //println("SWIPE PRINT" + swipe);
  
  
  /////////DRAWING///////////
  //issue is that closed fist is pinching but like lol
  //Checking if it is actually swiping or one finger extended first
  //Check everything else first before checking pinching because a lot of things are pinching
  if(numExtended(frame) >= 1) currDrawModeOn = false;
  if(swipe != 0) currDrawModeOn = false;
  
  
  ////Get the position
  Hand hand = frame.hands().frontmost(); //frontmost hand
  Vector pos = hand.palmPosition();
  y = -2*int(pos.getX());
  x = -2*int(pos.getY())+150;
  z = 2*int(pos.getZ());
  temp = new PVector(x,y,z);
  println("x : "+ x + 
  " y : "+ y +" z : "+ z);
  
  
  
  
  if (openMenu)
    createMenu();
  else
  {
  checkForMenu();
  
  //DRAW 
  //If it's a new Stroke
  //end of stroke, must add current stroke to list of all strokes
  // and create new stroke
  //// So I changed the foll line here but not sure about angle
  if(prevDrawModeOn && !currDrawModeOn && !eraseCommand)
  {
     strokes.add(points); //add to all strokes
     angles.add(-mouseX/float(width) * 2 * PI);
     points = new ArrayList<PVector>(); //new stroke
  }
  
  //points.add(temp); //add current point to current stroke
  if(currDrawModeOn)
  {
    int totalDiff = 0;
    if(points.size()>1){
      totalDiff = x-prevX;
      totalDiff += y-prevY;
      totalDiff += z-prevZ;
    }
    if(totalDiff < jump)
    {
      points.add(temp); //add current point to current stroke
    }
  }
  
  
  
  drawHolo();
  
  //for checking against the previous frame
  prevDrawModeOn = currDrawModeOn;
  eraseCommand= false;

  prevX = x;
  prevY = y;
  prevZ = z;
  } 
}
/* this is the first part of a two method series required for hologram, in between
 the actual objects will be drawn using drawSphere.
 */
void drawHolo() {
  translate(width/2,height/2,10);
  // so that each of the split screens will be rotated at 0 90 180 and 270 degrees 
  // so that the squares turn into rectangles and then diamonds to  be oriented correct
  rotateZ(PI/4);
  // so that we redraw the picture each time
  background(0);
  // this cycles through all of the split screens and draws each
  for(int i = 0; i< 4; i++){
   pg[i].beginDraw();
   // background of the split screens
   pg[i].background(0);
   pg[i].stroke(255);
   // maintains the rotations already produced for when these are poped
   pg[i].pushMatrix();
   // so that the start of each image is started away from the left edge of the 
   // split screen
   pg[i].rotateZ(PI/4);
   // this is so that the objects are not in the middle and so they are far enough away
   // to be used this way
   pg[i].translate(width/4, 0, -200);
   executesideRotation(pg[i], i);
   pg[i].rotateX(mouseX/float(width) * 2 * PI);
   //translate leapmotion coordinates and display coords
   pg[i].stroke(0,0,255);
   pg[i].line(100,0,0,0,0,0);
   pg[i].stroke(0,255,0);
   pg[i].line(0,0,100,0,0,0);
   
   //pg[i].rotateZ(PI/2);
   // all drawing here
   drawAllTraces(pg[i]);
   pg[i].noFill();
   pg[i].popMatrix();
   pg[i].endDraw();
   image(pg[i],screenCoords[0],screenCoords[1]);
   // moves the coordinate for the next split screen so that it is rotated 90 degrees
   rotateZ(PI/2);
  }
  // helps for centering and to tell us where the x coordinate is
  text(mouseX, 0,0);
}
void drawAllTraces(PGraphics pg) {
  //Line attributes
  pg.stroke(126); //color of the border
  pg.strokeWeight(10); //width of the stroke
  pg.noFill(); //??
  
  
  
  //drawing history of strokes
  for (int i = 0; i< strokes.size(); i++)
  {
    ArrayList<PVector> stroke = strokes.get(i);
    Float angle = angles.get(i);
    pg.rotateX(angle);
    pg.beginShape();
    for (PVector p : stroke)
    {
      pg.stroke(p.z); //color is determined by z axis
      pg.vertex(p.x,p.y,p.z);
    }
    pg.endShape();
    pg.rotateX(-angle);
  }
  
  
  
  
  //drawing current stroke
  pg.rotateX(-mouseX/float(width) * 2 * PI);
  pg.beginShape();
  
  for (PVector p: points)
  {
      pg.stroke(p.z);
      pg.vertex(p.x,p.y,p.z);
  }
  
  pg.endShape();
  pg.rotateX(+mouseX/float(width) * 2 * PI);
  
  
  
  
  //add cursor only if not all the fingers are extended or you're pinching
  if(numExtended(frame) < 5 || currDrawModeOn)
  {
    pg.rotateX(-mouseX/float(width) * 2 * PI);
    pg.strokeWeight(1); 
    pg.fill(127,0,0); //red
    if (currDrawModeOn) fill(0,127,0); //green
    pg.noStroke();
    pg.lights();
  //  pg.pushMatrix();
    pg.translate(x, y, z);
    pg.sphere(10);
    pg.rotateX(+mouseX/float(width) * 2 * PI);
    //pg.popMatrix();
  }
}

// rotates the coordinate system so that the system will be what is necessary for the 
// creation of the matrix
void executesideRotation(PGraphics pg, int side) {
  if(side==2) {
     pg.rotateZ(PI);
     pg.rotateY(PI);
   }
   else if(side==3){
     pg.rotateX(3*PI/2);
     
   }
   else if(side==1){
     pg.rotateX(PI/2);
   }
}

void drawShape(PGraphics shp, int z){
   shp.beginShape();
   shp.vertex(0,0,0*z);
   shp.vertex(0,0,100*z);
   shp.vertex(100,100,0*z);
   shp.vertex(10,100,100*z);
   shp.vertex(100,10,10*z);
   shp.vertex(0,0,0*z);
   shp.endShape();
}