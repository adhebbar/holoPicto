//interfaces with leapMotion
import com.leapmotion.leap.*;
Controller controller = new Controller();


float pinchThresh = 0.4; //When it is considered pinching, ranges from 0-1
ArrayList<PVector> points = new ArrayList<PVector>(); //current stroke
ArrayList<ArrayList> strokes = new ArrayList<ArrayList>(); //array of all strokes
PVector temp; //holds the current position
boolean currDrawModeOn = false;
boolean prevDrawModeOn = false;
boolean eraseCommand = false;
boolean openMenu = false;
boolean notSet = true;

//To make it a smoother line
int windSize = 400;
int jump = 20;
int prevX = 0;
int prevY = 0;
int prevZ = 0;
int circleCount =0;
int menuCounter = 0;
int cornerThreshold =10;
int maxMenuCount = 50;
int holdTime = 250;

int col1=150;
int col2=150;
int col3=150;


void setup(){
  size( 400, 400, P3D);
  background(111, 191, 255); //light blue
  controller.enableGesture(Gesture.Type.TYPE_CIRCLE);
}

void draw(){
  ///////SET UP FRAME AND HAND/////////
  background(111, 191, 255);//clear screen
  Frame frame = controller.frame(); //This current moment
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
  int x = int(pos.getX()+100);
  int y = 400-int(pos.getY());
  int z = int(pos.getZ());
  temp = new PVector(x,y,z);
  //println("x : "+ x + 
  //" y : "+ y +" z : "+ z);
  
  
  
  //MENU CHECKING

  if (openMenu)
  {
     fill(150,150,100); 

     background(0,0,0); //black
     //Draw the rectangle
     //Draw 7 boxes:
     int xStart = int(windSize*0.33) ;
     int yStart = int(windSize*0.25);
     int yIncr = int((windSize*0.5)/7 );
       textSize(15);
      text("Hover over color to choose new color and wait!", windSize*0.08, windSize*0.05); 
     
     for(int i=0; i<7; i++)
     {

       if(i==0) fill(148, 0, 211 );
        if(i==1) fill(0, 0, 255);
        if(i==2) fill(0, 255, 0  );
        if(i==3) fill(255, 255, 0  );
        if(i==4) fill(255, 127, 0);
        if(i==5) fill(255, 0, 0);
        if(i==6) fill(255,255,255);

       rect(xStart,yStart+i*yIncr, windSize*0.33 ,yIncr,1 );
       
     
     }
     
     
     //rect(xStart,yStart, windSize*0.33 ,windSize*0.5 ,7);
     

    
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
  ///////TAKE NOTE OF THIS LUCY
  if(prevDrawModeOn && !currDrawModeOn && !eraseCommand)
  {
     strokes.add(points); //add to all strokes
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
  
  
  //Line attributes
  stroke(126); //color of the border
  strokeWeight(10); //width of the stroke
  noFill(); //??
  
  
  
  //drawing history of strokes
  for (ArrayList<PVector> stroke : strokes)
  {
    beginShape();
    for (PVector p: stroke)
    {
      if(notSet) stroke(p.z); //color is determined by z axis
      else  stroke(col1,col2,col3);
      vertex(p.x,p.y,p.z);
    }
    endShape();
  }
  
  
  
  
  //drawing current stroke
  beginShape();
  for (PVector p: points)
  {
    if(notSet) stroke(p.z); //color is determined by z axis
      else  stroke(col1,col2,col3);
      vertex(p.x,p.y,p.z);
  }
  endShape();
  
  
  
  
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
  
  //for checking against the previous frame and to reset booleans
  prevDrawModeOn = currDrawModeOn;
  prevX = x;
  prevY = y;
  prevZ = z;
  eraseCommand= false;
  }
  
}

int checkSwipe(Frame frame){
  //Checking how many are extended and the angle
  int countExtended = 0;
  int countAngle = 0;
  
  //Goes through each finger and checks how many of the extended fingers are facing the same way
  for (Pointable p: frame.pointables()){
    Finger finger = new Finger(p);
    if(finger.isExtended())
    {
      countExtended++;
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