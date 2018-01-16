PGraphics pg[];
int winSize = 690;
int scrnSize = winSize/3;
int screenCoords[] = {0,0};
int numElements = 0;

void setup(){
  pg = new PGraphics[4];
  size(690,690,P3D);
  for(int i = 0; i < 4; i++){
      pg[i] = createGraphics(scrnSize, scrnSize, P3D);
  }
}

void draw() {
  translate(width/2,height/2,0);
  rotateZ(PI/4);
  background(0);
  for(int i = 0; i< 4; i++){
   pg[i].beginDraw();
   pg[i].background(0);
   pg[i].stroke(255);
   pg[i].pushMatrix();
   pg[i].translate(width*.5, height/2, -200);
   pg[i].box(50);
   pg[i].popMatrix();
   pg[i].camera(mouseX,mouseY,height/2,width/2,height/2,0,0,1,0);
   pg[i].endDraw();
   image(pg[i],screenCoords[0],screenCoords[1]);
   rotateZ(PI/2);
  }
}