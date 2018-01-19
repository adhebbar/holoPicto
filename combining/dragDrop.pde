PShape pyramid;
boolean prevPinch;

int cubeX = scrnSize/15;
int cubeY = -scrnSize/5;
int sphereX = scrnSize/15;
int sphereY = 0;
int pyrX = scrnSize/15;
int pyrY = scrnSize/5;
int margin = scrnSize/50;
public enum shapeType{CUBE,SPHER ,PYRAMID};
boolean canGoThrough = false;

class ShapeStuff {
 public PVector place;
 public PVector rotation;
 public float angleCreated;
 public shapeType shape;
 public  ShapeStuff(PVector place, PVector rotation, float angle, shapeType shape) {
   this.place = place;
   this.rotation = rotation;
   angleCreated = angle;
   this.shape = shape;
 }
}

int currentIndex = -1;

ArrayList<ShapeStuff> shapes = new ArrayList<ShapeStuff>();

void drawDragDrop()
{
  if(!(openColorMenu || openMainMenu)){
    if(currGesture == allGesture.PINCH) pinch();
    else prevPinch = false;
  }
  drawHolo();
}

void drawImageDragDrop(PGraphics pg){
  pg.pushMatrix();
  pg.fill(255);
  drawMenu(pg);
  for (ShapeStuff s  : shapes)
  {
    PVector pos = s.place;
    PVector rot = s.rotation;
    float angle = s.angleCreated;
    shapeType shape = s.shape;
    pg.rotateX(angle);
    pg.translate(pos.x, pos.y,pos.z);
    pg.rotateX(rot.x);
    pg.rotateY(rot.y);
    pg.rotateZ(rot.z);
    if(shape == shapeType.CUBE) {
      pg.rotateY(0.1);
      pg.rotateZ(0.2);
      pg.box(scrnSize*3/50);
      pg.rotateZ(-0.1);
      pg.rotateY(-0.2);
    }
    else if (shape == shapeType.SPHER) {
      pg.sphere(scrnSize/25);
    }
    else if (shape == shapeType.PYRAMID) {
      pg.rotateY(1);
      pg.shape(pyramid);  
      pg.rotateY(-1);
    }
    pg.rotateZ(-rot.z);
    pg.rotateY(-rot.y);
    pg.rotateX(-rot.x);
    pg.translate(-pos.x, -pos.y,-pos.z);
    pg.rotateX(-angle);
  }
  pg.popMatrix();
  
}

void pyrSet() //create pyramid shape type
{
     pyramid = createShape();
    pyramid.beginShape(TRIANGLES);
    pyramid.rotateY(PI*3/2);
    pyramid.noStroke();
   
    pyramid.fill(255);     // pink side
    pyramid.vertex(scrnSize/25,scrnSize/25,-scrnSize/25);
    pyramid.vertex(-scrnSize/25,scrnSize/25,-scrnSize/25);
    pyramid.vertex(-scrnSize/25,-scrnSize/25,-scrnSize/25);

    pyramid.fill(255);        // cyan side
    pyramid.vertex(-scrnSize/25,scrnSize/25,-scrnSize/25);
    pyramid.vertex(-scrnSize/25,scrnSize/25,scrnSize/25);
    pyramid.vertex(-scrnSize/25,-scrnSize/25,-scrnSize/25);

    pyramid.fill(255);         // rainbow
    pyramid.vertex(-scrnSize/25,-scrnSize/25,-scrnSize/25);
    pyramid.vertex(-scrnSize/25,scrnSize/25,scrnSize/25);
    pyramid.vertex(scrnSize/25,scrnSize/25,-scrnSize/25);
    pyramid.endShape(); 
}

boolean checkBounds(int shapeX, int shapeY)
{
   return 2*margin*margin >= (x-shapeX)*(x-shapeX) + (y-shapeY)*(y-shapeY);
}

boolean checkShapeBounds(int indexOfShape) {
  float bounds = 30;
  return (-bounds<shapes.get(indexOfShape).place.x-x && bounds>shapes.get(indexOfShape).place.x-x) &&
         (-bounds<shapes.get(indexOfShape).place.y-y && bounds>shapes.get(indexOfShape).place.y-y); //&&
         //(-bounds<shapes.get(indexOfShape).place.z-getPosition().z && bounds>shapes.get(indexOfShape).place.z-getPosition().z);
}

void pinch()
{
    if(!prevPinch)
    {
       prevPinch = true;
       if(checkBounds(cubeX+scrnSize/10, cubeY-scrnSize/10)) {
          shapes.add(new ShapeStuff(temp, new PVector(0,0,0), 0.0, shapeType.CUBE));
          currentIndex = shapes.size()-1;
       }
       else if(checkBounds(sphereX+scrnSize/25, sphereY-scrnSize/10)) {
          shapes.add(new ShapeStuff(temp, new PVector(0,0,0), 0.0, shapeType.SPHER));
          currentIndex = shapes.size()-1;
       }
       else if (checkBounds(pyrX-scrnSize*3/100, pyrY-scrnSize/10)) {
         shapes.add(new ShapeStuff(temp, new PVector(0,0,0), 0.0, shapeType.PYRAMID));
         currentIndex = shapes.size()-1;
       }
       else
       {
         for(int i = 0; i< shapes.size(); i++) {
           if (checkShapeBounds(i)) {
             currentIndex = i;
             println("grabbed", i);
             return; 
           }
         }
         println("here");
         prevPinch = false;
       }
    }
    else {
      if(shapes.size()>0)
      {
        if(canGoThrough) 
        {
          shapes.get(currentIndex).place = temp;
        }
        else
        {
          for(int i = 0; i<shapes.size();i++){
            if(i!=currentIndex && checkShapeBounds(i)) {
              return;
            }
          }
          shapes.get(currentIndex).place = temp;
        }
      }
    }
}

void drawMenu(PGraphics pg)
{
  pg.background(127,0,0);
  pg.fill(255);
  pg.lights();
  pg.noStroke();
  pg.pushMatrix();
  pg.translate(scrnSize/15, -scrnSize/5, -scrnSize/25);
  pg.rotateY(0.1);
  pg.rotateZ(0.2);
  pg.box(scrnSize*3/50);  
  pg.popMatrix();
  
  pg.pushMatrix();
  pg.translate(scrnSize/15, 0, -scrnSize/25);
  pg.sphere(scrnSize/25);
  pg.popMatrix();
  
  pg.pushMatrix();
  pg.translate(scrnSize/15, scrnSize/5, -scrnSize/25);
  pg.rotateY(1);
  pg.shape(pyramid);  
  pg.popMatrix();
}