ArrayList<PVector> points = new ArrayList<PVector>(); //current stroke
ArrayList<ArrayList> strokes = new ArrayList<ArrayList>(); //array of all strokes
ArrayList<Float> angles = new ArrayList<Float>();
PVector temp;
boolean currDrawModeOn = false;
boolean prevDrawModeOn = false;


//To make it a smoother line
int jump = 20;

void drawDrawing3d(){
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
      break;
  }
  
  //DRAW 
  //If it's a new Stroke
  //end of stroke, must add current stroke to list of all strokes
  // and create new stroke
  //// So I changed the foll line here but not sure about angle
  if(prevGesture == allGesture.PINCH && currGesture != allGesture.PINCH && currGesture != allGesture.CIRCLE && strokes.size()>=1)
  {
     strokes.add(points); //add to all strokes
     angles.add(-mouseX/float(width) * 2 * PI);
     points = new ArrayList<PVector>(); //new stroke
  }
  drawHolo();
}