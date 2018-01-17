PGraphics pg[];
int winSize = 690;
int scrnSize = winSize/3;
int screenCoords[] = {0,0};
void setup(){
  pg = new PGraphics[4];
  size(690,690,P3D);
  for(int i = 0; i < 4; i++){
      pg[i] = createGraphics(scrnSize, scrnSize, P3D);
  }
}

void draw() {
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
   //split screen
   pg[i].rotateZ(PI/4);
   // this is so that the objects are not in the middle and so they are far enough away
   // to be used this way
   pg[i].translate(width/4, 0, -200);
   executesideRotation(pg[i], i);
   pg[i].rotateX(mouseX/float(width) * 2 * PI);
   /* all of this is for inserting the boxes for testing
   pg[i].translate(0,40,40);
   pg[i].box(50);
   pg[i].translate(0,40,40);
   pg[i].box(30);
   pg[i].translate(0,40,40);
   pg[i].box(20);*/
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