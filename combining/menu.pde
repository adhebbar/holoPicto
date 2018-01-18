void createMenu()  
  {
     fill(150,150,100); 

     background(0,0,0); //black
     //Draw the rectangle
     //Draw 7 boxes:
     int xStart = int(winSize*0.33) ;
     int yStart = int(winSize*0.25);
     int yIncr = int((winSize*0.5)/7 );
       textSize(15);
      text("Hover over color to choose new color and wait!", winSize*0.08, winSize*0.05); 
     
     for(int i=0; i<7; i++)
     {

       if(i==0) fill(148, 0, 211 );
        if(i==1) fill(0, 0, 255);
        if(i==2) fill(0, 255, 0  );
        if(i==3) fill(255, 255, 0  );
        if(i==4) fill(255, 127, 0);
        if(i==5) fill(255, 0, 0);
        if(i==6) fill(255,255,255);

       rect(xStart,yStart+i*yIncr, scrnSize*0.33 ,yIncr,1 );     
     
     }   
    if(menuCounter==holdTime)
    {
      //Chose the color based on the xy coordinates at this time
       int col = int((y - yStart)/yIncr);
       setColors(col);
      openMenu=false;
    }
    else
      menuCounter+=1 ;
 
   //add cursor only if not all the fingers are extended or you're pinching
  if(numExtended(frame) < 5 || currDrawModeOn)
  {
    strokeWeight(1); 
    fill(127,0,0); //red
    if (currDrawModeOn) 
    {
      fill(0,127,0); //green
    }
    noStroke();
    lights();
    pushMatrix();
    translate(x, y, z);
    sphere(10);
    popMatrix();
  }
}


void checkForMenu()
{
      //Check if this point is a corner point
  if(x<cornerThreshold && menuCounter<maxMenuCount)
  {
    menuCounter++;
  }
  else
  {
    menuCounter=0;
  }
  
  if(menuCounter>=maxMenuCount) 
    {
      openMenu=true;
      //reset maxCounter and wait for 3 seconds
      menuCounter=0;
    } 
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