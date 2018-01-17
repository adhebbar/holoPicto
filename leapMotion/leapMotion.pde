//interfaces with leapMotion
import com.leapmotion.leap.*;
Controller controller = new Controller();



float pinchThresh = 0.4;
ArrayList<PVector> points = new ArrayList<PVector>(); //current stroke
ArrayList<ArrayList> strokes = new ArrayList<ArrayList>(); //array of all strokes
PVector temp;
boolean currDrawModeOn = false;
boolean prevDrawModeOn = false;
boolean eraseCommand = false;

void setup(){
  size( 400, 400 ,P3D);
  background(111, 191, 255); //light blue
  controller.enableGesture(Gesture.Type.TYPE_CIRCLE);
  //controller.enableGesture(Gesture.Type.TYPE_SWIPE);
  //controller.enableGesture(Gesture.Type.TYPE_KEY_TAP);
}

void draw(){
  background(111, 191, 255);//clear screen
  Frame frame = controller.frame(); 
  Hand hand = frame.hands().frontmost(); //frontmost hand
  float pinch = hand.pinchStrength();
  
    //gesture stuff
      for(Gesture gesture : frame.gestures())
    {
        if(gesture.type()== Gesture.Type.TYPE_CIRCLE) 
        {
           println("CIRCLE");
           eraseCommand = true;
        }
    }
  
  //if(eraseCommand && (strokes.size()>0)) //delete current stroke
  //{
  //   currDrawModeOn = false;
  //   points = strokes.get(strokes.size()-1); //make current stroke last stroke
  //   strokes.remove(strokes.size()-1); //remove last stroke from history
  //}
  
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
  
  //add cursor
  strokeWeight(1); 
  fill(127,0,0);
  if (currDrawModeOn) fill(0,127,0);
  ellipse(x,y,20,20);
  
  //end of stroke, must add current stroke to list of all strokes
  // and create new stroke
  if(prevDrawModeOn && !currDrawModeOn)
  {
     strokes.add(points); //add to all strokes
     points = new ArrayList<PVector>(); //new stroke
  }
  
  if(currDrawModeOn) points.add(temp); //add current location to stroke
  
  //draw everything
  stroke(126);
  strokeWeight(10); 
  noFill();
  //drawing history of strokes
  for (ArrayList<PVector> stroke : strokes)
  {
    beginShape();
    for (PVector p: stroke)
    {
      stroke(p.z);
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
  prevDrawModeOn = currDrawModeOn;
}