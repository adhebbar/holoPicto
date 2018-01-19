//Variables for the menu
boolean openMainMenu = false;
int menuCounter = 0;
int cornerThreshold = 10;//-800;
int maxMenuCount = 50;
int holdTime = 250;

int col1=150;
int col2=150;
int col3=150;

int menuWidth = winSize /3;
int menuHeight = winSize/10;
int imageX = (winSize - menuWidth)/2;
int imageWidth = 40;

void createMainMenu(){

   //println("dafuq");
   //menu screen
   pushMatrix();
   //translate(40,100,0);
   
   fill(255,255,255);
   tint(255, 100);
   //box(40);
   
   rect((winSize - menuWidth)/2 , winSize - menuHeight ,menuWidth, menuHeight, 20);
   //tint(0, 0, 0);
   
   image(img, winSize/2 - imageWidth/2, winSize - menuHeight, imageWidth, imageWidth);
   image(img, winSize/2 - imageWidth * 3/2, winSize - menuHeight, imageWidth, imageWidth);
   image(img, winSize/2 + imageWidth/2, winSize - menuHeight, imageWidth, imageWidth);
   //selectModeMenu(mode.DRAGDROP);//temp
   popMatrix();
   //tint(255,255);
    if(mouseY < 300){
       openMainMenu=false;
     }
}

void selectModeMenu(mode newMode){
  tint(255,255);
  switch(newMode){
   case DRAWING3D:
     image(img, winSize/2 - imageWidth/2, winSize - menuHeight, imageWidth, imageWidth);
     break;
   case DRAGDROP:
     image(img, winSize/2 - imageWidth * 3/2, winSize - menuHeight, imageWidth, imageWidth);
     break;
   case GRAPH:
     image(img, winSize/2 + imageWidth/2, winSize - menuHeight, imageWidth, imageWidth);
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
   
   image(img, winSize/2 - imageWidth/2, winSize - menuHeight, imageWidth, imageWidth);
   image(img, winSize/2 - imageWidth * 3/2, winSize - menuHeight, imageWidth, imageWidth);
   image(img, winSize/2 + imageWidth/2, winSize - menuHeight, imageWidth, imageWidth);
   //selectModeMenu(mode.DRAGDROP);//temp
   popMatrix();
   //tint(255,255);
    if(mouseY < 300){
       openMainMenu=false;
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
   
   rect((winSize - menuWidth)/2 , (winSize)/2 + menuHeight ,menuWidth, menuHeight, 20);
   //tint(0, 0, 0);
   
   image(img, winSize/2 - imageWidth/2, winSize - menuHeight, imageWidth, imageWidth);
   image(img, winSize/2 - imageWidth * 3/2, winSize - menuHeight, imageWidth, imageWidth);
   image(img, winSize/2 + imageWidth/2, winSize - menuHeight, imageWidth, imageWidth);
   //selectModeMenu(mode.DRAGDROP);//temp
   popMatrix();
   //tint(255,255);
    if(mouseY < 300){
       openMainMenu=false;
     }
}
/*
void createDrawingMenu(PGraphics pg2)  
  {
    
     fill(150,150,100); 

     background(0,0,0); //black
     //Draw the rectangle
     //Draw 7 boxes:
     int xStart = int(0);//winSize*0.33) ;
     int yStart = int(0);//winSize*0.25);
     int yIncr = int((winSize*0.5)/7 );
       textSize(15);
      text("Hover over color to choose new color and wait!", winSize*0.08, winSize*0.05); 
     
     for(int i=0; i<7; i++)
     {

        if(i==0) pg2.fill(148, 0, 211 );
        if(i==1) pg2.fill(0, 0, 255);
        if(i==2) pg2.fill(0, 255, 0  );
        if(i==3) pg2.fill(255, 255, 0  );
        if(i==4) pg2.fill(255, 127, 0);
        if(i==5) pg2.fill(255, 0, 0);
        if(i==6) pg2.fill(255,255,255);

       pg2.rect(xStart,yStart+i*yIncr, scrnSize*0.33 ,yIncr,1 );     
     
     }
     if(mouseX < 300){
       openMainMenu=false;
     }
    //if(menuCounter==holdTime)
    //{
    //  //Chose the color based on the xy coordinates at this time
    //   int col = int((y - yStart)/yIncr);
    //   setColors(col);
    //  openMenu=false;
    //}
    //else
    //  menuCounter+=1 ;
 
   //add cursor only if not all the fingers are extended or you're pinching
  //if(numExtended(frame) < 5 || currDrawModeOn)
  //{
  //  strokeWeight(1); 
  //  fill(127,0,0); //red
  //  if (currDrawModeOn) 
  //  {
  //    fill(0,127,0); //green
  //  }
  //  noStroke();
  //  lights();
  //  pushMatrix();
  //  translate(x, y, z);
  //  sphere(10);
  //  popMatrix();
  //}
}
*/

void checkForMainMenu()
{
  //print("checking main menu...");
  //Check if this point is a corner point
  if(mouseY> 300 /*cornerThreshold && menuCounter<maxMenuCount*/)//x<cornerThreshold && menuCounter<maxMenuCount) !!!test
  {
    openMainMenu = true;
    //println("less than cornerThreshold");
    //menuCounter++;
  }
  else
  {
    openMainMenu = false;
    //menuCounter=0;
  }
  
  /*if(menuCounter>=maxMenuCount) 
    {
      openMainMenu=true;
      //reset maxCounter and wait for 3 seconds
      menuCounter=0;
    } 
  //openMainMenu = true;*/
}

/* sets menu colours */
void setColors( int col)
{
 if (col==0)
       {
         col1= 148;
         col2=0;
         col3=211;
       }
       if (col==1)
       {
         col1= 0;
         col2=0;
         col3=255;
       }   
       if (col==2)
       {
         col1= 0;
         col2=255;
         col3=0;
       }   
      if (col==3)
       {
         col1= 255;
         col2=255;
         col3=0;
       }   

       if (col==4)
       {
         col1= 255;
         col2=127;
         col3=0;
       }  
       if (col==5)
       {
         col1= 255;
         col2=0;
         col3=0;
       }   
       if (col==6)
       {
         col1= 255;
         col2=255;
         col3=255;
       }         
    notSet= false;
}