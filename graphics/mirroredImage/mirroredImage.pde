import java.util.Vector;

PGraphics pg[];
int winSize = 690;
int scrnSize = winSize/3;
int screenCoords[] = {0,0};
int numElements = 0;
Vector<PVector> locations;
Vector<PVector> orientations;
Vector<Integer> sizes;
void setup(){
  pg = new PGraphics[4];
  size(690,690,P3D);
  for(int i = 0; i < 4; i++){
      pg[i] = createGraphics(scrnSize, scrnSize, P3D);
  }
  locations = new Vector<PVector>();
  orientations = new Vector<PVector>();
  sizes = new Vector<Integer>();
  createNewBox(50, width/2, height/2, 10, 0, 0, 0);
  createNewBox(50, width/2+50, height/2+50, 10, 0, 0, 0);
  createNewBox(50, width/2+150, height/2+20, 10, 2, .5, 2);
}

void draw() {
  translate(width/2,height/2,0);
  rotateZ(PI/4);
  background(0);
  for(int i = 0; i< 4; i++){
   pg[i].beginDraw();
   pg[i].background(0);
   pg[i].stroke(0);
   for (int j = 0; j<numElements; j++) {
     pg[i].pushMatrix();
     pg[i].translate(locations.elementAt(j).x, locations.elementAt(j).y,
                     locations.elementAt(j).z);
     pg[i].rotateX(orientations.elementAt(j).x);
     pg[i].rotateY(orientations.elementAt(j).y);
     pg[i].rotateZ(orientations.elementAt(j).z);
     pg[i].box(sizes.elementAt(j));
     pg[i].popMatrix();
   }
   pg[i].camera(0,0,height/2,width/2,height/2,0,0,1,0);
   pg[i].endDraw();
   image(pg[i],screenCoords[0],screenCoords[1]);
   rotateZ(PI/2);
  }
}

void createNewBox(int size, int xpos, int ypos, int zpos, float xrot, 
                  float yrot, float zrot){
  orientations.addElement(new PVector(xrot, yrot, zrot));
  locations.addElement(new PVector(xpos, ypos, zpos));
  sizes.addElement(new Integer(size));
  numElements++;
}