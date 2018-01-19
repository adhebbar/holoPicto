/*-----------------------------------
Library: ComputationalGeometry
By: Mark Collins & Toru Hasegawa
Example: IsoSkeleton

Creates a 3D skeleton with adjustable 
thickness and node size, based on an
edge pairing of points.
------------------------------------*/

import ComputationalGeometry.*;
IsoSkeleton skeleton;

import javax.script.*;
import java.util.*;
  


void setup() {
  size(600,600, P3D);

  // Create iso-skeleton
  skeleton = new IsoSkeleton(this);
  PVector prev1,curr,prev2,prev;
  prev1= new PVector(X,Y,Z);
  prev2=new PVector(X,Y,Z);
  prev=new PVector(X,Y,Z);
  // Create points to make the network
  PVector[] pts = new PVector[1000];

  int radius = 10;
  int xBound1 = -11;
  int xBound2 = 11; 
  int yBound1 = -11;
  int yBound2 = 11; 
  int zBound1 = -11;
  int zBound2 = 11;

  //for(int X = xBound1; X <= xBound2; X++ )
  //      for(int Y = yBound1; Y <= yBound2; Y++ )
  //          for(int Z = zBound1; Z <= zBound2; Z++ ){
  //              //if(Math.sqrt((X * X) + (Y * Y) + (Z * Z)) == radius)  
  //              if( isValidPoint( X,Y,Z  )  )  
  //                {curr= new PVector(X,Y,Z);
  //                    skeleton.addEdge(prev, curr);
  //                     prev = curr;
  //                    print("Here"); println(X*100+Y*10+Z);
  //                }}

int l=0;
 for(int X = xBound1; X <= xBound2; X++ )
        for(int Y = yBound1; Y <= yBound2; Y++ )
            for(int Z = zBound1; Z <= zBound2; Z++ ){
                //if(Math.sqrt((X * X) + (Y * Y) + (Z * Z)) == radius)  
                if( isValidPoint( X,Y,Z  )  )  
                  {
                    
                    curr= new PVector(X,Y,Z);
                       print("Here   "); println(X*100+Y*10+Z);

                  if(l==0){
                    prev2= curr;
                  }
                  else if(l==1){
                    prev1= curr;
                  
                  }
                  else 
                  {if( prev1.dist(prev2)< prev1.dist(curr)) skeleton.addEdge(prev1,prev2);
                  else skeleton.addEdge(prev1,curr);
                  prev2 = prev1;
                  prev1 = curr;
                  }
                l++;

                  }
              }

      print("DONEE l is");
      println(l);
}

boolean isValidPoint(int x, int y, int z){

  
        ScriptEngine engine = new ScriptEngineManager().getEngineByName("JavaScript");
        Map<String, Object> vars = new HashMap<String, Object>();
        vars.put("x", x);
        
        vars.put("y", y);
        vars.put("z", z);
        //"x*x+ y*y+ z*z "
        try
        {
           Integer wee = Math.round(Float.parseFloat(engine.eval("x*x+ y*y+ z*z ", new SimpleBindings(vars)).toString() ) );
          return wee == 10;
        }
  catch (ScriptException sed) {
      System.out.println("Problem in eval");
      return false;
  }        

}
  


void draw() {

  background(220);
  lights();  
  float zm = 150;
  float sp = 0.001 * frameCount;
  camera(zm * cos(sp), zm * sin(sp), zm, 0, 0, 0, 0, 0, -1);
  
  
  noStroke();
  skeleton.plot(10.f * float(mouseX) / (2.0f*width), float(mouseY) / (2.0*height));  // Thickness as parameter
  
  
  Integer x,y,z;
  x=1; y=2; z=3;
  
  

}