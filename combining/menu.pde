
//Variables for the menu
boolean openMainMenu = false;
boolean openColorMenu = false;
int topMenuCounter = 0;
int bottomMenuCounter = 0;
int cornerThreshold = 50;//-800;
int maxMenuCount = 50;
int holdTime = 250;
mode highlighted = mode.DRAWING3D;

int col1=150;
int col2=150;
int col3=150;

int menuWidth = winSize /3;
int menuHeight = winSize/10;
int imageX = (winSize - menuWidth)/2;
int imageWidth = menuHeight;

int drawMenuWidth = winSize/10;
enum drawSetting{COLOR, LINETHICK, NONE};

drawSetting currDraw = drawSetting.COLOR;
int[][] rgb = {{148, 0, 211 },{0, 0, 255},{0, 255, 0 },{255, 255, 0 },{255, 0, 0},{255, 255, 255}, {0,0,0} }; 

void createMainMenu(){

   //println("dafuq");
   //menu screen
   //pushMatrix();
   //translate(40,100,0);
   
   fill(255,255,255);
   tint(255, 100);
   //box(40);
   
   rect((winSize - menuWidth)/2 , winSize - menuHeight ,menuWidth, menuHeight, 20);
   //tint(0, 0, 0);
   
   /*image(img, winSize/2 - imageWidth/2, winSize - menuHeight, imageWidth, imageWidth);
   image(img, winSize/2 - imageWidth * 3/2, winSize - menuHeight, imageWidth, imageWidth);
   image(img, winSize/2 + imageWidth/2, winSize - menuHeight, imageWidth, imageWidth);
   //selectModeMenu(mode.DRAGDROP);//temp
   popMatrix();
   //tint(255,255);
    if(mouseY < 300){
       openMainMenu=false;
     }*/
}

void selectModeMenu(mode newMode){
  tint(255,255);
  switch(newMode){
   case DRAWING3D:
     image(modeImgs[0], winSize/2 - imageWidth/2, winSize - menuHeight, imageWidth, imageWidth);
     highlighted = mode.DRAWING3D;
     break;
   case DRAGDROP:
     image(modeImgs[1], winSize/2 - imageWidth * 3/2, winSize - menuHeight, imageWidth, imageWidth);
     highlighted = mode.DRAGDROP;
     break;
   case GRAPH:
     image(modeImgs[2], winSize/2 + imageWidth/2, winSize - menuHeight, imageWidth, imageWidth);
     highlighted = mode.GRAPH;
     break;
  }
   
}


void createDDBLocksMenu(){

   //println("dafuq");
   //menu screen
   pushMatrix();
   //translate(40,100,0);
   
   fill(255,255,255);
   tint(255, 100);
   //box(40);
   
   rect((winSize - menuWidth)/2 , winSize - menuHeight ,menuWidth, menuHeight, 20);
   //tint(0, 0, 0);
   
   image(modeImgs[0], winSize/2 - imageWidth/2, winSize - menuHeight, imageWidth, imageWidth);
   image(modeImgs[0], winSize/2 - imageWidth * 3/2, winSize - menuHeight, imageWidth, imageWidth);
   image(modeImgs[0], winSize/2 + imageWidth/2, winSize - menuHeight, imageWidth, imageWidth);
   //selectModeMenu(mode.DRAGDROP);//temp
   popMatrix();
    //HIGHLIGHTING WHAT IT IS HOVERED OVER
   if(y < minY+(maxY-minY)/3) selectModeMenu(mode.GRAPH);
   else if(y < minY+2*((maxY-minY)/3)) selectModeMenu(mode.DRAWING3D);
   else selectModeMenu(mode.DRAGDROP);
   
   println("MATH??"+(minY+2*((maxY-minY)/3)));
   
   if(currGesture == allGesture.PINCH){
       currMode = highlighted;
       openMainMenu = false;
       openColorMenu = false;
   }
}

void createDrawMenu(){
   
   //println("dafuq");
   //menu screen
   pushMatrix();
   //translate(40,100,0);
   
   fill(255,255,255);
   tint(255, 100);
   //box(40);
   
   rect((winSize - drawMenuWidth)/2 , (winSize)/2 + menuHeight ,drawMenuWidth, menuHeight, 20);
   rect((winSize - drawMenuWidth)/2 , (winSize)/2 + menuHeight*2.5 ,drawMenuWidth, menuHeight, 20);
   
   tint(255, 100);
   
   image(drawImgs[0], (winSize - drawMenuWidth)/2, (winSize)/2 + menuHeight, imageWidth, imageWidth);
   image(drawImgs[1], (winSize - drawMenuWidth)/2, (winSize)/2 + menuHeight*2.5, imageWidth, imageWidth);
   //selectModeMenu(mode.DRAGDROP);//temp
   createDrawSettings();
   popMatrix();
   //tint(255,255);
   
    if(mouseY < 300){
       openMainMenu=false;
     }
}
void createDrawSettings(){
    switch(currDraw){
      case COLOR:
        drawColor();
        break;
      case LINETHICK:
        drawLineThick();
        break;
      case NONE:
        break;
    }
}

int drawColorWidth = drawMenuWidth/2;
int middleDrawX = (winSize - drawMenuWidth)*17/32;
void drawColor(){
   int numColors = rgb.length;
   
   fill(100);
   noStroke();
   for(int i = 0; i < numColors; i++){
     fill(rgb[i][0],rgb[i][1],rgb[i][2]); 
     if(i==numColors-1){
        stroke(100);
        rect(middleDrawX+drawColorWidth*(i-3) , (winSize)/2 + menuHeight*10/8 ,drawColorWidth, menuHeight/2, 0,10,10,0);
      }
      else{
      if(i==0){
        rect(middleDrawX+drawColorWidth*(i-3) , (winSize)/2 + menuHeight*10/8 ,drawColorWidth, menuHeight/2, 10,0,0,10);
      }
      else{
        rect(middleDrawX+drawColorWidth*(i-3) , (winSize)/2 + menuHeight*10/8 ,drawColorWidth, menuHeight/2);
      }
      }
      
   }
   noStroke();

   //selectColorMenu(1);
   fill(255);
}
/*
  Select color based on number in the rgb array
*/
void selectColorMenu(int x){
  fill(rgb[x][0],rgb[x][1],rgb[x][2]);
  stroke(255);
  //tint(255,200);
  rect(middleDrawX+drawColorWidth*(x-3) , (winSize)/2 + menuHeight*10/8 ,drawColorWidth, menuHeight/2);
  noStroke();
   
}

void drawLineThick(){
   int numThick = 7;
   int drawColorWidth = drawMenuWidth/2;
   int middleDrawX = (winSize - drawMenuWidth)*17/32;
   fill(255);
   noStroke();
   //draw rectangle;
   rect(middleDrawX-drawColorWidth*3 , (winSize)/2 + menuHeight*22/8 ,drawColorWidth*7, menuHeight/2, 10, 10, 10, 10);

   fill(0);
   //draw circles;
   for(int i = 0; i < numThick; i++){
      ellipse(middleDrawX+drawColorWidth*(i-2.5),(winSize)/2 + menuHeight*24/8,2+i*3,2+i*3);
   }
   //selectLineMenu(5);
   fill(255);
}

void selectLineMenu(int x){
  stroke(200);
  fill(200);
  //tint(255,200);
  ellipse(middleDrawX+drawColorWidth*(x-2.5),(winSize)/2 + menuHeight*24/8,2+x*3,2+x*3);
  noStroke();
   
}

void checkForMainMenu()
{
  //Check if this point is a corner point
  if(x < minX+cornerThreshold && currGesture != allGesture.PINCH)/*cornerThreshold && menuCounter<maxMenuCount*///x<cornerThreshold && menuCounter<maxMenuCount) !!!test*/
  {
    //openMainMenu = true;
    println("less than cornerThreshold");
    bottomMenuCounter++;
  }
  else if(x>maxX-cornerThreshold && currGesture != allGesture.PINCH)
  {
    println("moreThanCornerThreshold");
    topMenuCounter++;
  }
  else
  {
    openMainMenu = false;
    //menuCounter=0;
  }
  
  if(topMenuCounter>=maxMenuCount) 
    {
      openColorMenu=true;
      //reset maxCounter and wait for 3 seconds
      topMenuCounter=0;
    } 
    else if(bottomMenuCounter>=maxMenuCount)
    {
      openMainMenu=true;
      //reset maxCounter and wait for 3 seconds
      bottomMenuCounter=0;
    }
  
 
}