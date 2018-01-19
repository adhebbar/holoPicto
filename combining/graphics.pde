
/* this is the first part of a two method series required for hologram, in between
 the actual objects will be drawn using drawSphere.
 */
 
float currAngle = 0;

void drawHolo() {
  
  pushMatrix();
  ////////ALL THE ROTATION THINGS///////
  
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
   // split screen
   pg[i].rotateZ(PI/4);
   // this is so that the objects are not in the middle and so they are far enough away
   // to be used this way
   pg[i].translate(width/4, 0, -200);
   executesideRotation(pg[i], i);
   pg[i].rotateX(currAngle);
   //translate leapmotion coordinates and display coords
   pg[i].stroke(0,0,255);
   pg[i].line(100,0,0,0,0,0);
   pg[i].stroke(0,255,0);
   pg[i].line(0,0,100,0,0,0);
   
   //pg[i].rotateZ(PI/2);
   
   
   
   
   //////DRAWING THE LINES
   drawApplication(pg[i]);
   drawMouse(pg[i]);
  
   pg[i].noFill();
   pg[i].popMatrix();
   pg[i].endDraw();
   image(pg[i],screenCoords[0],screenCoords[1]);
   // moves the coordinate for the next split screen so that it is rotated 90 degrees
   rotateZ(PI/2);
  }
  
  text(mouseX, 0,0);
  popMatrix();
  // helps for centering and to tell us where the x coordinate is
  drawMenu(pg[0]);
}


void drawApplication(PGraphics pg) {
  switch (currMode){
  
  ////ERASING
  case DRAWING3D:
    drawImageDrawing3D(pg);
  case DRAGDROP:
    drawImageDrawing3D(pg);
  case GRAPH:
    drawImageDrawing3D(pg);
  }

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

void drawMouse(PGraphics pg){
  //add cursor only if not all the fingers are extended or you're pinching
  if(currGesture != allGesture.HANDOUT)
    {
      pg.rotateX(-currAngle);
      pg.strokeWeight(1); 
      //pg.fill(127,0,0); //red
      noFill();
      if(currGesture.equals(allGesture.PINCH))
      {
        pg.fill(0,127,0); //green
      }
      else pg.fill(127,0,0); //red
      pg.noStroke();
      pg.lights();
      pg.pushMatrix();
      pg.translate(x, y, z);
      pg.sphere(10);
      pg.rotateX(+currAngle);
      pg.popMatrix();
    }
} 

void drawMenu(PGraphics pg){
  
  if(openMenu)
    createMenu(pg);
  else
  {
    checkForMenu();
  }
}