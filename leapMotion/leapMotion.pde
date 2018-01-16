//interfaces with leapMotion
mport com.leapmotion.leap.*;
Controller controller = new Controller();
float pinchThresh = 0.4;

void setup(){
  size( 400, 400 ,P3D);
  background(0);
}

void draw(){
  Frame frame = controller.frame();
  GestureList gesturesInFrame = frame.gestures();
  Hand hand = frame.hands().frontmost(); //frontmost hand
  int grab = int(hand.grabStrength());
  float pinch = hand.pinchStrength();
  String thing = "no";
  if(pinch>pinchThresh) thing = "yes";
  Vector pos = hand.palmPosition();
  //Uncomment to print parameters for debugging:
  //text( frame.hands().count() + " Hands", 50, 50 );
  //text( frame.fingers().count() + " Fingers", 50, 100 );
  //text(grab + " grabStrength", 50, 130 );
  //text(thing, 50, 150 );
  //text("x : "+ int(pos.getX()) + 
  //" y : "+ int(pos.getY()) +" z : "+ int(pos.getZ()), 50, 170 );
  if(pinch>pinchThresh)
  {
    pushMatrix();
    translate(pos.getX()+100,400-pos.getY(),pos.getZ());
    stroke(pos.getZ());
    sphere(10);
    popMatrix();
  }  
}