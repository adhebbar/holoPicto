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
  translate(width/2,height/2,10);
  rotateZ(PI/4);
  background(0);
  
  for(int i = 0; i< 4; i++){
   
   pg[i].beginDraw();
   
   
   pg[i].background(100);
   pg[i].stroke(255);
   pg[i].pushMatrix();
   pg[i].rotateZ(PI/4);
   pg[i].translate(width/4, 0, -200);
   pg[i].rotateX(mouseX/float(width) * PI);
   //pg[i].box(50);
   pg[i].translate(0,40,40);
   PShape shp = pg[i].createShape();
   shp.beginShape();
   shp.vertex(0,0,0);
   shp.vertex(0,400,100);
   shp.vertex(10,100,0);
   shp.vertex(100,10,10);
   shp.endShape();
   pg[i].noFill();
   pg[i].popMatrix();
   //pg[i]
   
   //pg[i].camera(mouseX,mouseY,height/2,width/2,height/2,0,0,1,0);
   //pg[i].stroke(0);
   
   pg[i].endDraw();
   image(pg[i],screenCoords[0],screenCoords[1]);
   rotateZ(PI/2);
  }
  text(mouseX, 0,0);
}

void drawShape(PGraphics tmp){
   PShape shp = tmp.createShape();
   shp.beginShape();
   shp.vertex(0,0,0);
   shp.vertex(0,400,100);
   shp.vertex(10,100,0);
   shp.vertex(100,10,10);
   shp.endShape();
}