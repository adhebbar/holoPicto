//import de.voidplus.leapmotion.*;

import com.leapmotion.leap.*;
Controller controller = new Controller();




boolean openMenu = false;
boolean notSet = true;

//To make it a smoother line
int circleCount =0;
int menuCounter = 0;
int cornerThreshold =10;
int maxMenuCount = 50;
int holdTime = 250;

int col1=150;
int col2=150;
int col3=150;

float pinchThresh = 0.4;
ArrayList<PVector> points = new ArrayList<PVector>(); //current stroke
ArrayList<ArrayList> strokes = new ArrayList<ArrayList>(); //array of all strokes
ArrayList<Float> angles = new ArrayList<Float>();
PVector temp;
boolean currDrawModeOn = false;
boolean prevDrawModeOn = false;
boolean eraseCommand = false;
Frame frame = controller.frame(); //This current moment

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
  Hand hand = frame.hands().frontmost(); //frontmost hand
  
  ///////////PINCH DETECTION////////////////
  float pinch = hand.pinchStrength(); //ranges from 0 to 1

  String pinchDetected = "pinch not detected";
  if(pinch>pinchThresh) 
  {
    pinchDetected = "pinch detected";
    currDrawModeOn = true;
  }
  else currDrawModeOn = false;
  
  //debugging
  println(pinchDetected);
  

//////////CIRCLE GESTURES && ERASE///////////////
  for(Gesture gesture : frame.gestures())
  {
      if(gesture.type() == Gesture.Type.TYPE_CIRCLE) 
      {
        circleCount++;
         println("CIRCLE");
         if(circleCount%30==0)
            {eraseCommand = true;
            circleCount =0;
            }
      }
  }
  
  if(eraseCommand && (strokes.size()>0)) //delete current stroke
  {
     currDrawModeOn = false;
     //points = strokes.get(strokes.size()-1); //make current stroke last stroke
     strokes.remove(strokes.size()-1); //remove last stroke from history
     points = new ArrayList<PVector>();
  }
  
  
  
  
  ///////////CHECKING SWIPE/////////
  int swipe = checkSwipe(frame); //0 is no swipe, -1 is left swipe, 1 is right swipe
  //println("SWIPE PRINT" + swipe);
  
  
  
  
  /////////DRAWING///////////
  //issue is that closed fist is pinching but like lol
  
  //Checking if it is actually swiping or one finger extended first
  //Check everything else first before checking pinching because a lot of things are pinching
  if(numExtended(frame) >= 1) currDrawModeOn = false;
  if(swipe != 0) currDrawModeOn = false;
  
  
  ////Get the position
  Vector pos = hand.palmPosition();
  y = -2*int(pos.getX());
  x = -2*int(pos.getY())+150;
  z = 2*int(pos.getZ());
  temp = new PVector(x,y,z);
  println("x : "+ x + 
  " y : "+ y +" z : "+ z);
  
  
  
  
  if (openMenu)
  {
     fill(150,150,100); 

     background(0,0,0); //black
     //Draw the rectangle
     //Draw 7 boxes:
     int xStart = int(winSize*0.33) ;
     int yStart = int(winSize*0.25);
     int yIncr = int((winSize*0.5)/7 );
       textSize(15);
      text("Hover over color to choose new color and wait!", winSize*0.08, winSize*0.05); 
     
     for(int i=0; i<7; i++)
     {

       if(i==0) fill(148, 0, 211 );
        if(i==1) fill(0, 0, 255);
        if(i==2) fill(0, 255, 0  );
        if(i==3) fill(255, 255, 0  );
        if(i==4) fill(255, 127, 0);
        if(i==5) fill(255, 0, 0);
        if(i==6) fill(255,255,255);

       rect(xStart,yStart+i*yIncr, scrnSize*0.33 ,yIncr,1 );
       
     
     }
     
     
     

    
    if(menuCounter==holdTime)
    {
      //Chose the color based on the xy coordinates at this time
       int col = int((y - yStart)/yIncr);
       setColors(col);
      openMenu=false;
    }
    else
      menuCounter+=1 ;
 
   //add cursor only if not all the fingers are extended or you're pinching
  if(numExtended(frame) < 5 || currDrawModeOn)
  {
    strokeWeight(1); 
    fill(127,0,0); //red
    if (currDrawModeOn) 
    {
      fill(0,127,0); //green
    }
    noStroke();
    lights();
    pushMatrix();
    translate(x, y, z);
    sphere(10);
    popMatrix();
  }
  
 

}

  
  else
  {
    
     //Check if this point is a corner point
  if(x<cornerThreshold && menuCounter<maxMenuCount)
  {
    menuCounter++;
  }
  else
  {
    menuCounter=0;
  }
  
  if(menuCounter>=maxMenuCount) 
    {openMenu=true;
      //reset maxCounter and wait for 3 seconds
      menuCounter=0;
    }

  
  
  
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
/*
returns -1 left; 0 nothing; 1 right
*/
int checkSwipe(Frame frame){
  //Checking how many are extended and the angle
  int countAngle = 0;
  
  //Goes through each finger and checks how many of the extended fingers are facing the same way
  for (Pointable p: frame.pointables()){
    Finger finger = new Finger(p);
    if(finger.isExtended())
    {
      Vector pointingToward = p.direction();
      countAngle = countAngle + int(pointingToward.yaw());
    }
  }
  
  
  if(countAngle == 2){
    println("RIGHT");
    return 1;
  }
  
  if(countAngle == -2)
  {
    println("LEFT");
    return -1;
  }
  return 0;
}

int numExtended(Frame frame)
{
  //Checks the number of fingers extended
  int count = 0;
  for (Pointable p: frame.pointables()){
    Finger finger = new Finger(p);
    if(finger.isExtended()) count++;
  }
  return count;
}




void setColors( int col)
{
 if (col==0)
       {
         col1= 148;
         col2=0;
         col3=211;
       }
       if (col==1)
       {
         col1= 0;
         col2=0;
         col3=255;
       }   
       if (col==2)
       {
         col1= 0;
         col2=255;
         col3=0;
       }   
      if (col==3)
       {
         col1= 255;
         col2=255;
         col3=0;
       }   

       if (col==4)
       {
         col1= 255;
         col2=127;
         col3=0;
       }  
       if (col==5)
       {
         col1= 255;
         col2=0;
         col3=0;
       }   
       if (col==6)
       {
         col1= 255;
         col2=255;
         col3=255;
       }         
    notSet= false;
}