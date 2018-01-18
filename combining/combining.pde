//import de.voidplus.leapmotion.*;

import com.leapmotion.leap.*;
Controller controller = new Controller();

float pinchThresh = 0.4;
ArrayList<PVector> points = new ArrayList<PVector>(); //current stroke
ArrayList<ArrayList> strokes = new ArrayList<ArrayList>(); //array of all strokes
PVector temp;
boolean currDrawModeOn = false;
boolean prevDrawModeOn = false;
boolean eraseCommand = false;

PGraphics pg[];
int winSize = 690;
int scrnSize = 2*winSize/4;
int screenCoords[] = {0,0};

void setup(){
  pg = new PGraphics[4];
  size(690,690,P3D);
  for(int i = 0; i < 4; i++){
      pg[i] = createGraphics(scrnSize, scrnSize, P3D);
  }
}

void draw(){
  background(111, 191, 255);//clear screen
  Frame frame = controller.frame(); 
  Hand hand = frame.hands().frontmost(); //frontmost hand
  float pinch = hand.pinchStrength();

  //calculate x,y,z coords
  Vector pos = hand.palmPosition();
  int x = int(pos.getX()+100);
  int y = 400-int(pos.getY());
  int z = int(pos.getZ());
  temp = new PVector(x,y,z);

  //prints to console for debugging and check if pinch is detected:
  String pinchDetected = "pinch not detected";
  if(pinch>pinchThresh) 
  {
    pinchDetected = "pinch detected";
    currDrawModeOn = true;
  }
  else currDrawModeOn = false;
  println(pinchDetected);
  println("x : "+ x + 
  " y : "+ y +" z : "+ z);
  
  //end of stroke, must add current stroke to list of all strokes
  // and create new stroke
  if(prevDrawModeOn && !currDrawModeOn)
  {
     strokes.add(points); //add to all strokes
     points = new ArrayList<PVector>(); //new stroke
  }
  
  if(currDrawModeOn) points.add(temp); //add current location to stroke
  
  drawHolo();
  //add cursor
  strokeWeight(1); 
  fill(127,0,0);
  if (currDrawModeOn) fill(0,127,0);
  ellipse(x,y,20,20);
  prevDrawModeOn = currDrawModeOn;
}
// this is the first part of a two method series required for hologram, in between
// the actual objects will be drawn using drawSphere. 
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
   pg[i].background(111,191,255);
   pg[i].stroke(255);
   // maintains the rotations already produced for when these are poped
   pg[i].pushMatrix();
   // so that the start of each image is started away from the left edge of the 
   //split screen
   pg[i].rotateZ(PI/4);
   // this is so that the objects are not in the middle and so they are far enough away
   // to be used this way
   pg[i].translate(width/4, 0, -200);
   executesideRotation(pg[i], i);
   pg[i].rotateX(mouseX/float(width) * 2 * PI);
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
  for (ArrayList<PVector> stroke : strokes)
  {
    pg.beginShape();
    for (PVector p: stroke)
    {
      pg.stroke(p.z);
      pg.vertex(p.x,p.y,p.z);
    }
    pg.endShape();
  }
  //drawing current stroke
  pg.beginShape();
  for (PVector p: points)
  {
      pg.stroke(p.z);
      pg.vertex(p.x,p.y,p.z);
  }
  pg.endShape();
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