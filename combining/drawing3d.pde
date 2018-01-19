ArrayList<PVector> points = new ArrayList<PVector>(); //current stroke
ArrayList<ArrayList> strokes = new ArrayList<ArrayList>(); //array of all strokes
ArrayList<Float> angles = new ArrayList<Float>();
ArrayList<Integer> thicks = new ArrayList<Integer>();
ArrayList<Integer> colors = new ArrayList<Integer>();

PVector temp;
boolean currDrawModeOn = false;
boolean prevDrawModeOn = false;


//To make it a smoother line
int jump = 20;

void drawDrawing3d(){
  println("DRAWING3D");
  if(!(openColorMenu || openMainMenu)){
  switch (currGesture){
    
    ////ERASING
    case CIRCLE:
        if(strokes.size()>0)
        {
          strokes.remove(strokes.size()-1); //remove last stroke from history
          points = new ArrayList<PVector>();
        }
        break;
        
        
        
    /////POINTING
    case PINCH:
        int totalDiff = 0;
        if(points.size()>1){
         
          totalDiff = x-prevX;
          totalDiff += y-prevY;
          totalDiff += z-prevZ;
        }
        if(totalDiff < jump)
        {
          points.add(temp); //add current point to current stroke
        }
        break;
        
    case HANDOUT:
      break;
    case POINTING:
      break;
    case SWIPE:
      if(checkSwipe() == -1){
        currAngle += -.1;
      }
      if(checkSwipe() == 1){
         currAngle += .1; 
      }
      break;
  }
  
  //DRAW 
  //If it's a new Stroke
  //end of stroke, must add current stroke to list of all strokes
  // and create new stroke
  //// So I changed the foll line here but not sure about angle
  if(prevGesture == allGesture.PINCH && currGesture != allGesture.PINCH)
  {
     strokes.add(points); //add to all strokes
     angles.add(new Float((-currAngle)));
     points = new ArrayList<PVector>(); //new stroke
  }
  }
  
  drawHolo();
  //drawMenu();
}

void drawImageDrawing3D(PGraphics pg){
    //Line attributes
    pg.stroke(126); //color of the border
    pg.strokeWeight(10); //width of the stroke
    pg.noFill(); //??
    //drawing history of strokes
    for (int i = 0; i< strokes.size(); i++)
    {
      ArrayList<PVector> stroke = strokes.get(i);
      Float angle = angles.get(i);
      pg.rotateX(angle);
      pg.beginShape();
      for (PVector p : stroke)
      {
        pg.stroke(p.z); //color is determined by z axis
        pg.vertex(p.x,p.y,p.z);
      }
      pg.endShape();
      pg.rotateX(-angle);
    }
    
    //drawing current stroke
    pg.rotateX(-currAngle);
    pg.beginShape();
    
    for (PVector p: points)
    {
        pg.stroke(p.z);
        pg.vertex(p.x,p.y,p.z);
    }
    
    pg.endShape();
    pg.rotateX(+currAngle);
}