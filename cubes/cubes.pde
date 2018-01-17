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
   if(i==2) {
     pg[i].rotateZ(PI);
     pg[i].rotateY(PI);
     
   }
   if(i==3){
     pg[i].rotateX(3*PI/2);
     /*pg[i].rotateY(PI);*/
     pg[i].line(0,0,0, 100, 0,0);
     pg[i].stroke(0,0,255);
     pg[i].line(0,0,0, 0, 100,0);
     
   }
   if(i==1){
     /*pg[i].rotateZ(PI);
     pg[i].rotateX(PI);*/
     pg[i].rotateX(PI/2);
     pg[i].line(0,0,0, 100, 0,0);
     pg[i].stroke(0,0,255);
     pg[i].line(0,0,0, 0, 100,0);
   }
   pg[i].rotateX(mouseX/float(width) * 2 * PI);
   //pg[i].box(50);
   pg[i].translate(0,40,40);
   pg[i].box(50);
   pg[i].translate(0,40,40);
   pg[i].box(30);
   pg[i].translate(0,40,40);
   pg[i].box(20);
   /*if(i==2){
     drawShape(pg[i],1);
   }
   else {
     drawShape(pg[i], 1);
   }*/
   /*pg[i].line(0,0,0, mouseX,mouseY,0);
   pg[i].box(30);*/
   pg[i].noFill();
   pg[i].popMatrix();
   pg[i].endDraw();
   image(pg[i],screenCoords[0],screenCoords[1]);
   rotateZ(PI/2);
  }
  text(mouseX, 0,0);
}

void drawShape(PGraphics shp, int z){
   shp.beginShape();
  // shp.fill(0,0,255);
   //shp.noStroke();
   shp.vertex(0,0,0*z);
   shp.vertex(0,0,100*z);
   shp.vertex(100,100,0*z);
   shp.vertex(10,100,100*z);
   shp.vertex(100,10,10*z);
   shp.vertex(0,0,0*z);
   shp.endShape();
}