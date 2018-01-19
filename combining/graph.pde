import javax.script.*;
import java.util.*;
  
  
ArrayList<PVector> graphPoints = new ArrayList<PVector>(); //current stroke
//ArrayList<ArrayList> strokes = new ArrayList<ArrayList>(); //array of all strokes
ArrayList<Float> graphAngles = new ArrayList<Float>();
//PVector circleTemp;
  
int radius = 10;

int xBound1 = -11;
int xBound2 = 11; 
int yBound1 = -11;
int yBound2 = 11; 
int zBound1 = -11;
int zBound2 = 11;
PVector curr;
boolean calculated = false;
String equation;

void drawGraph(){
  
    
  
  
  if(calculated == false) calculatePoints();
  
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
        break;
        
    case HANDOUT:
      break;
    case POINTING:
      break;
    case SWIPE:
      currAngle += .1;
      break;
    }
      
      
  //drawImageGraph();
  drawHolo();
}

//void calculatePoints(){
//  for(int X = xBound1; X <= xBound2; X++ )
//        for(int Y = yBound1; Y <= yBound2; Y++ )
//            for(int Z = zBound1; Z <= zBound2; Z++ )
//                if( isValidPoint( X,Y,Z  )  )  
//                  {
//                     curr= new PVector(X,Y,Z);
                  
//                       //Draw a sphere at this point
//                       graphPoints.add(curr);
//                       graphAngles.add(new Float((-currAngle)));
//                      print("Here"); println(X*100+Y*10+Z);
//                  }  
//  calculated = true;
//}




void calculatePoints(){
  
  Scanner reader = new Scanner(System.in);  // Reading from System.in
  System.out.println("Enter your equation \n z = ");
  //int n = reader.nextInt(); // Scans the next token of the input as an int.

    
  equation = reader.next( );
  
  
  //once finished
  reader.close();
  
  
  
  for(int X = xBound1; X <= xBound2; X++ )
        for(int Y = yBound1; Y <= yBound2; Y++ )
            {
              float Z = assignPoint( X,Y,equation )  ;  
                  
                     curr= new PVector(X,Y,Z);
                       
                       //Draw a sphere at this point
                       graphPoints.add(curr);
                       graphAngles.add(new Float((-currAngle)));
                      print("Here"); println(X*100+Y*10+Z);
                  }  
  calculated = true;
}






float assignPoint(int x, int y,String equation){

  
        ScriptEngine engine = new ScriptEngineManager().getEngineByName("JavaScript");
        Map<String, Object> vars = new HashMap<String, Object>();
        vars.put("x", x);
        
        vars.put("y", y);
        vars.put("z", z);
        //"x*x+ y*y+ z*z "
        //(-x*x-y*y)**0.5
       equation="y*y+ x*x";
        //"Math.sqrt(100 -x*x -y*y)"
        
        try
        {
           Float wee = Float.parseFloat(engine.eval(equation, new SimpleBindings(vars)).toString() );
          return wee ;
        }
  catch (ScriptException sed) {
      System.out.println("Problem in eval");
      return -999.9;
  }        

}


void drawImageGraph(PGraphics pg)
{
    //Line attributes
    pg.stroke(126); //color of the border
    pg.strokeWeight(10); //width of the stroke
    pg.noFill(); //??
    println("SIZE"+graphPoints.size());

    
    pg.beginShape(POINTS);

    
    for (int i = 0; i< graphPoints.size(); i++)
    {
       //Float angle = graphAngles.get(i);
        
       PVector temp=  graphPoints.get(i) ;
       float X=temp.x*10;
       float Y=temp.y*10;
       float Z=temp.z*10;
 
        pg.stroke(Z);
        pg.vertex(X,Y,Z);
        
      //pg.pushMatrix();
      //pg.fill(127,127,127);
      //pg.translate(30,30,30);
      //pg.sphere(1);
      //pg.popMatrix();
      
      //pg.rotateX(-angle);
      //pg.strokeWeight(1); 
      //pg.fill(0,127,0); //red      
      //pg.noStroke();
      //pg.lights();
      //pg.pushMatrix();
      //pg.translate(X,Y,Z);
      //pg.sphere(5);
      //pg.rotateX(+angle);
      //pg.popMatrix();
       
    }
      pg.endShape();

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
           Integer wee = Math.round(Float.parseFloat(engine.eval("x+y +z ", new SimpleBindings(vars)).toString() ) );
          return wee == radius;
        }
  catch (ScriptException sed) {
      System.out.println("Problem in eval");
      return false;
  }        

}