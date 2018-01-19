/*
returns -1 left; 0 nothing; 1 right
*/

float pinchThresh = 0.4;
int circleCount = 0;
int circleNeeded = 40;

/* Checks for pinching, returns true if found in current frame, 
  false otherwise*/
Boolean checkPinch()
{
  Hand hand = frame.hands().frontmost(); //frontmost hand
  float pinch = hand.pinchStrength(); //ranges from 0 to 1
  //String pinchDetected = "pinch not detected";
  if(pinch>pinchThresh) 
  {
    //pinchDetected = "pinch detected";
    //debugging
    //println(pinchDetected);
    return true;
  }
  //debugging
  //println(pinchDetected);
  return false;

}



/* checks for swipe gesture */
int checkSwipe(){
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


/* Finds number of fingers extended */
int numExtended(Frame frame)
{
  //Checks the number of fingers extended
  int count = 0;
  for (Pointable p: frame.pointables())
  {
    Finger finger = new Finger(p);
    if(finger.isExtended()) count++;
  }
  return count;
}


/* Checks for circle gesture, returns true if found in current frame, 
  false otherwise*/
boolean checkCircle()
{
  for(Gesture gesture : frame.gestures())
  {
      if(gesture.type() == Gesture.Type.TYPE_CIRCLE){
        circleCount++;
      }
      
      if(circleCount%circleNeeded == 0){
        circleCount = 0;
        return true;
      }
  }
  println("CIRCLE"+circleCount);
  return false;
}

boolean checkHandout()
{
  if(numExtended(frame) == 5) return true;
  return false;
}

boolean checkPoint()
{
  if(numExtended(frame) >= 1) return true;
  return false;
}