/*
returns -1 left; 0 nothing; 1 right
*/
import com.leapmotion.leap.*;

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

//Finds number of fingers extended
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

/* Checks for circle gesture, returns 1 if found in current frame, 
  0 otherwise*/
int checkCircle(Frame frame)
{
  for(Gesture gesture : frame.gestures())
  {
      if(gesture.type() == Gesture.Type.TYPE_CIRCLE) return 1;
  }
  return 0;
}