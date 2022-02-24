

import org.firmata.*;
import cc.arduino.*;
import processing.serial.*;
import java.awt.event.KeyEvent;
import java.io.IOException;
import processing.opengl.*;


Serial myPort;

String data="";

float Pitch;     // replaces roll and pitch 
float Bank; 
float Azimuth; 

float Phi;    //Dimensional axis
float Theta;
float Psi;

float radius = 250.0;      
float rho = radius;
float factor = TWO_PI / 40.0;    // detail is 40
float x, y, z;
 
PVector[] sphereVertexPoints;

////////////////////////////////////////////////////////////////////////

void setup() {
  
   size(400, 400, P3D);
   smooth();
    
myPort = new Serial(this, "COM6", 9600); // starts the serial communication myPort.bufferUntil('\n');

        }
     
 ////////////////////////////////////////////////////////////////////
 
void draw() {
  
background(0); 
  
  stroke(100);
  strokeWeight(4); 
  fill(200);
  rect(130, 10, 150, 50, 7);  // (x,y,w,h, round corner dia)
  fill(CLOSE); 
  
  fill(0); 
  rect(150, 30, 70, 25, 7); 
  fill(CLOSE); 
  
  strokeWeight(CLOSE); // very useful 
  fill(CLOSE); 
  stroke(CLOSE); 
  
  fill(0);
  textSize(14);
  text("Altitude: ", 150, 50, 50); 
  fill(CLOSE);
  float y1 = y++;
  float Alt = abs(Pitch/25+y1*10);
  
  fill(0,255,255); 
  text(Alt, 160,70,50);  // alt, x,y,z
  fill(CLOSE); 
  
  
  fill(0, 0, 255); 
  textSize(12); 
  text(" m/s", 220, 70, 50 );
  fill(CLOSE); 
  
   
  translate(width/2, height/2, -250);  // camera placement
  lights();
  
  textLayer(); 
  MakeAnglesDependentOnMPU6050(); 
  
  
   fill(100);
   circle(0,0,700);  // dark gray circle 
   fill(CLOSE);      
   
   fill(150);
   circle(0,0,670);   // light grey circle 
   fill(CLOSE); 
  
  beginShape(); 

  fill(255,255,0); 
    vertex(-14, -10, 300);
    vertex(14, -10, 300);       // yellow triangle, each vertex is x and y coords
    vertex(0, -20, 300);
    vertex(0, -20, 300);
   stroke(0); 
   strokeWeight(2); 
   stroke(CLOSE);
   
   
  endShape(CLOSE); 
  
   beginShape(); 
    fill(255,255,0); 
    stroke(0); 
    strokeWeight(2); 
    stroke(CLOSE); 
    vertex(-50, -5, 300);
    vertex( 50, -5, 300);       // yellow  line
    vertex( 50, -10, 300);
    vertex(-50, -10, 300);
    fill(CLOSE); 
  endShape(CLOSE); 
  
 
  fill(210);
  arc(-120, 0, 380, 525, PI/2, 3*PI/2);   // left gauge fill
  arc(120, 0, -380, -525, PI/2, 3*PI/2);  // right gauge fill
  fill(CLOSE); 
  
 //////////////////////////////////////////////////////////////

  pushMatrix();  

   
   
     rotateX(radians(Bank)); 
     rotateZ(radians(Pitch));    // comment out to change to mouse
     rotateY(radians(Azimuth)); 
 
  

 // rotateX(radians(mouseY));  // comment in, to change to mouse. 
 // rotateY(radians(mouseX));
 
  for(float PHI = 0.0; PHI < HALF_PI; PHI += factor) {
    
    beginShape(QUAD_STRIP);
    stroke(240); 
    strokeWeight(1);
   
    for(float THETA = 0.0; THETA < TWO_PI + factor; THETA += factor) {
     
      x = rho * sin(PHI) * cos(THETA);
      z = rho * sin(PHI) * sin(THETA);
      y = -rho * cos(PHI);
 
      vertex(x, y, z);
 
      x = rho * sin(PHI + factor) * cos(THETA);
      z = rho * sin(PHI + factor) * sin(THETA);
      y = -rho * cos(PHI + factor);
 
      vertex(x, y, z);
      fill(100, 100,255); 
    
   }
 
    endShape(CLOSE);
  }
  
  



for(float phi = 0.0; phi < HALF_PI; phi += factor) {
    
    beginShape(QUAD_STRIP);
    
    for(float theta = 0.0; theta < TWO_PI + factor; theta += factor) {
      
      x = rho * sin(phi) * cos(theta);
      z = rho * sin(phi) * sin(theta);
      y = -rho * cos(phi);
 
      vertex(-x, -y, -z);
 
      x = rho * sin(phi + factor) * cos(theta);
      z = rho * sin(phi + factor) * sin(theta);
      y = -rho * cos(phi + factor);
 
      vertex(-x, -y, -z);
      fill(255,128,0);
      
      
  }
    
    
    endShape(CLOSE);
 
}

   popMatrix(); 
            
 /////////////////////////////////////////////////////////////////////          

    } // void draw
  
  

//////////////////////////////////////////////////////////////////////////

    void textLayer() { 
    
     
         MakeAnglesDependentOnMPU6050();
       
     /*pushMatrix();
           
         rotateX(Bank/10); 
         rotateY(-Pitch/10); 
         rotateZ(Azimuth/10); 
       
         fill(255);
    
              textSize(15);           
              text( "50", 0, 110, 230);          
              text( "90", 0, 180, 200);
   
           popMatrix(); */
           
      /////////////////////////////////////////////////////////        
           
           pushMatrix(); 
             
             float y1 = y++;   
             float alt = abs(Pitch/25+y1*10+90);
           
             
             beginShape(); 
             rotateZ(alt); 
             stroke(255,255,0);              // throttle measurement  yellow
             strokeWeight(8); 
             line(0,0,-310, 0);
             stroke(CLOSE); 
             endShape();
             strokeWeight(CLOSE); 
            
            popMatrix(); 
               
 /////////////////////////////////////////////////////////////////////////////  

    
    
    int radius = 300; 
    int lines = 5*17; 
    
  for (int a=120; a<240; a=a+360/lines) { 
     
    float x = radius * cos(radians(a));        // gauge lines yeah baby 
    float y = radius * sin(radians(a)); 
    
   
 
      stroke(50);
      line(0,0,x,y); 
      line(0,0,-x,-y);
      strokeWeight(3); 
      stroke(CLOSE); 
     
     }
    
///////////////////////////////////////////////////////////    
    
     
     for (int a=120; a<160; a=a+360/lines) { 
       
       float x = radius * cos(radians(a));        // red gauge lines yeah baby 
       float y = radius * sin(radians(a)); 
       
       stroke(255,0,0);
       line(0,0,-x,-y); 
       strokeWeight(3); 
       stroke(CLOSE); 
     }
       
  for (int a=160; a<190; a=a+360/lines) { 
       
       float x = radius * cos(radians(a));        // orange gauge lines yeah baby 
       float y = radius * sin(radians(a)); 
       
       stroke(255,128,0);
       line(0,0,-x,-y); 
         strokeWeight(3); 
       stroke(CLOSE); 
   
   
   }
       
       
      for (int a=220; a<240; a=a+360/lines) { 
       
       float x = radius * cos(radians(a));        // red gauge max throttle 
       float y = radius * sin(radians(a)); 
       
       stroke(255,0,0);
       strokeWeight(3); 
       line(0,0,x,y); 
       stroke(CLOSE); 
   
   
   }
       
       
////////////////////////////////////////////////////////////////
    
 
           
         }


///////////////////////////////////////////////////////////////////////

       void serialEvent(Serial myport)       {     //Reading the datas by Processing. 
  
          String input = myport.readStringUntil('\n');
          
            if   (input != null)      {
             
                input = trim(input);
               String[] values = split(input, " ");
             
             if  (values.length == 3)  {
                  
                 
                  float phi = float(values[0]);
                  float theta = float(values[1]); 
                  float psi = float(values[2]); 
                  
                  print(phi);    
                  print(theta);
                  println(psi);
                 
                  Phi = phi;
                  Theta = theta;
                  Psi = psi;
                    
                         
                         
                         
                          }
                      }
                   }
                   
///////////////////////////////////////////////////////////////////////


      void MakeAnglesDependentOnMPU6050()   { 
         
         Bank = round(-Theta);
         Pitch =round(-Phi-3);
         Azimuth = round(Psi/700);
         
         
     //   Bank =  -Phi/10; 
       // Pitch =  Theta/10;       // use these values for the ADXL345 
       // Azimuth = Psi/10;
        
        }   
        
 /////////////////////////////////////////////////////////////////////////
