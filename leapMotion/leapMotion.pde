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
boolean prevSwipeLeft = false;
boolean prevSwipeRight = false;
int countLeft = 0;
int countRight = 0;
int overallCount = 0;


void setup(){
  size( 400, 400, P3D);
  background(111, 191, 255); //light blue
  controller.enableGesture(Gesture.Type.TYPE_CIRCLE);
}

void draw(){
  background(111, 191, 255);//clear screen
  Frame frame = controller.frame(); //This current moment
  Hand hand = frame.hands().frontmost(); //frontmost hand
  
  ///////////PINCH DETECTION////////////////
  float pinch = hand.pinchStrength(); //ranges from 0 to 1
  
  ////calculate x,y,z coords
  //Vector pos = hand.palmPosition();
  //int x = int(pos.getX()+100);
  //int y = 400-int(pos.getY());
  //int z = int(pos.getZ());
  //temp = new PVector(x,y,z);
  
  String pinchDetected = "pinch not detected";
  if(pinch>pinchThresh) 
  {
    pinchDetected = "pinch detected";
    currDrawModeOn = true;
  }
  else currDrawModeOn = false;
  
  //debugging
  //println(pinchDetected);
  //println("x : "+ x + 
  //" y : "+ y +" z : "+ z);
  
  
  //////////CIRCLE GESTURES && ERASE///////////////
  for(Gesture gesture : frame.gestures())
  {
      if(gesture.type() == Gesture.Type.TYPE_CIRCLE) 
      {
         println("CIRCLE");
         eraseCommand = true;
      }
  }
  
  if(eraseCommand && (strokes.size()>0)) //delete current stroke
  {
     currDrawModeOn = false;
     //points = strokes.get(strokes.size()-1); //make current stroke last stroke
     strokes.remove(strokes.size()-1); //remove last stroke from history
     points = new ArrayList<PVector>();
  }
  
  /////////DRAWING///////////
  //New Stroke
  //end of stroke, must add current stroke to list of all strokes
  // and create new stroke
  ///////TAKE NOTE OF THIS LUCY
  Vector pos = hand.palmPosition();
  int x = int(pos.getX()+100);
  int y = 400-int(pos.getY());
  int z = int(pos.getZ());
  temp = new PVector(x,y,z);
  
  if(prevDrawModeOn && !currDrawModeOn)
  {
     strokes.add(points); //add to all strokes
     points = new ArrayList<PVector>(); //new stroke
  }
  

  if(currDrawModeOn) points.add(temp); //add current point to current stroke
  
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
      stroke(p.z); //color is determined by z axis
      vertex(p.x,p.y,p.z);
    }
    endShape();
  }
  
  //drawing current stroke
  beginShape();
  for (PVector p: points)
  {
      stroke(p.z);
      vertex(p.x,p.y,p.z);
  }
  endShape();
    
  //add cursor
  strokeWeight(1); 
  fill(127,0,0); //red
  if (currDrawModeOn) fill(0,127,0); //green
  noStroke();
  lights();
  pushMatrix();
  translate(x, y, z);
  sphere(10);
  popMatrix();
 
  prevDrawModeOn = currDrawModeOn;
  
  int countExtended = 0;
  int countAngle = 0;
  //println("POINTABLE NUM" + frame.pointables().count());
  //Pointable pointable = frame.pointables().frontmost();
  //inger finger = new Finger(pointable);
  //String fingerString = finger.toString();
  //println("finger"+fingerString);
  for (Pointable p: frame.pointables()){
    Finger finger = new Finger(p);
    if(finger.isExtended()) countExtended = countExtended+1;
    Vector pointingToward = p.direction();
    countAngle = countAngle + int(pointingToward.yaw());
    println("COUNTANGLE"+countAngle);
    //print(int(pointingToward.yaw()));
  }
  
  if(countAngle >= 3){
    if(prevSwipeRight != true){
      prevSwipeRight = true;
      //println("RIGHT");
      countRight = countRight +1;
    }
  }
  else
  {
    prevSwipeRight = false;
  }
  
  if(countAngle <= -3){
    if(prevSwipeLeft != true){
      prevSwipeLeft = true;
      //println("LEFT");
      countLeft = countLeft +1;
    }
  }
  else
  {
    prevSwipeLeft = false;
  }
  //println("COUNT"+countExtended);
  println("LEFT" + countLeft);
  println("RIGHT" + countRight);

}