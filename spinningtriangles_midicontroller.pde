/*
/
/ Triangle shape visuals
/ Control variables using a nanoKontrol2 midicontroller. 
/ You could use any midicontroller, just update the numbers.
/
/ Amy Goodchild Feb 2019
/ www.amygoodchild.com
/
*/

// Midi Library
import themidibus.*;
import javax.sound.midi.MidiMessage; 
import javax.sound.midi.SysexMessage;
import javax.sound.midi.ShortMessage;

MidiBus myBus; 

// Setting up the triangles
float widthgap;
float heightgap;
int cols = 23;
int rows = 11;
int numOfTriangles;
Triangle[] triangles;

// How many frames from old variable to the next, higher is smoother but less responsive. 
int animationSpeed = 50;

// Lowering this leads to fadeytrails.
float backgroundOpacity = 100;

void setup(){
  size(1920,1080,P3D);
  //fullScreen(P3D);
  colorMode(HSB, 100);
  background(0);
  smooth();
  
  // Set up gap to lay out spacing between the triangles
  widthgap = 100;
  heightgap = 100;
  
  numOfTriangles = cols*rows;
  
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this, 0, 0); // Create a new MidiBus object

  // Create an array of all the triangles
  triangles = new Triangle[numOfTriangles]; 
  for (int i=0; i<numOfTriangles; i++){
     int row = i/cols;
     int col = i%cols;        
     triangles[i] = new Triangle(col, row, i);     
  }
    
}


void draw(){
  
  // draw the background huge and far away - if it's at the regular position in the z axis, it cuts into the triangles as they rotate
  fill(0,0,0,backgroundOpacity);
  translate(-width*2, -height*2, -500); 
  rect(0,0,width*5,height*5);
  translate(width*2, height*2, 500);   

 
  // Update and draw all the triangles
  for (int i=0; i<numOfTriangles; i++){
    triangles[i].update();
    if (triangles[i].row < rows && triangles[i].col < cols){
      triangles[i].display();
    }
  }
  
  // Print the framerate - for troubleshooting
  // fill(100,0,100);
  // textSize(30);
  // text(frameRate, 10, 50);
  
}

void keyPressed(){
  
  // If you don't have a midicontroller, you can control variables in steps using a keyboard
  if (keyCode == UP){
    for (int i=0; i<numOfTriangles; i++){
      triangles[i].newSize+=10;
    }
  }
  
  if (keyCode == DOWN){
    for (int i=0; i<numOfTriangles; i++){
      triangles[i].newSize-=10;
    }
  }
  
   if (keyCode == LEFT){
    backgroundOpacity-=10;
  }
  
  if (keyCode == RIGHT){
    backgroundOpacity+=10;
  }
  
}


void midiMessage(MidiMessage message) { 
   // Print out some info on the midi message. 
   //println();
   //println("MidiMessage Data:");
   //println("--------");
   //println("Status Byte/MIDI Command:"+message.getStatus());
   //println("Param 0: "+(int)(message.getMessage()[0] & 0xFF));  
   //println("Param 1: "+(int)(message.getMessage()[1] & 0xFF));
   //println("Param 2: "+(int)(message.getMessage()[2] & 0xFF));
  
  
  // Knob 16: Triangle size
  if ((int)(message.getMessage()[1] & 0xFF) == 16){
     float size = map( (int)(message.getMessage()[2] & 0xFF), 0, 127, 150, 800);
     
     for (int i=0; i<numOfTriangles; i++){
      triangles[i].newSize=size;
    }
  }
  
  // Knob 17: Background Opacity
  if ((int)(message.getMessage()[1] & 0xFF) == 17){
    float input = (int)(message.getMessage()[2] & 0xFF);
      
      // mapped unevenly to give more control at lower opacities     
      if (input < 40){
        backgroundOpacity = map( input, 0, 49, 0.1, 2);
      }
      else if (input < 70){
         backgroundOpacity = map( input, 50, 69, 2.01, 5);       
      }
      else{
         backgroundOpacity = map( input, 70, 127, 5.01, 15);     
      }
  }
  
  
  // Knob 18: Inner Opacity of Triangles
  if ((int)(message.getMessage()[1] & 0xFF) == 18){
     float innerOpacity = map( (int)(message.getMessage()[2] & 0xFF), 0, 127, 3, 100);
     
     for (int i=0; i<numOfTriangles; i++){
      triangles[i].innerOpacity=innerOpacity;
    }
  }
  
  // Slider 0: Spin speed in the x-axis
  if ((int)(message.getMessage()[1] & 0xFF) == 0){
    float xSpinChange = map( (int)(message.getMessage()[2] & 0xFF), 0, 127, 0.0, 0.1);
     
     for (int i=0; i<numOfTriangles; i++){
      triangles[i].xSpinChange=xSpinChange;
    }
  }
  
  // Slider 1: Spin speed in the y-axis
  if ((int)(message.getMessage()[1] & 0xFF) == 1){
    float ySpinChange = map( (int)(message.getMessage()[2] & 0xFF), 0, 127, 0.0, 0.1);
    for (int i=0; i<numOfTriangles; i++){
      triangles[i].ySpinChange=ySpinChange;
    }
  }
  
  // Slider 2: Spin speed in the z-axis
  if ((int)(message.getMessage()[1] & 0xFF) == 2){
    float zSpinChange = map( (int)(message.getMessage()[2] & 0xFF), 0, 127, 0.0, 0.1);
    for (int i=0; i<numOfTriangles; i++){
      triangles[i].zSpinChange=zSpinChange;
    }
  }
  
  // Slider 3: Spin offset - i.e. triangles later in the array are more spun around
  if ((int)(message.getMessage()[1] & 0xFF) == 3){
    float totalSpinOffset = map( (int)(message.getMessage()[2] & 0xFF), 0, 127, 0.0, 0.1);
    for (int i=0; i<numOfTriangles; i++){
      triangles[i].newSpinOffset = i*totalSpinOffset;
    } 
   }
   
  // Slider 4: Hue offset - i.e. triangles later in the array have a higher hue. 
  // ("Higher" perhaps a little misleading, as it wraps around to 0 if it hits 100, but, basically higher)
  if ((int)(message.getMessage()[1] & 0xFF) == 4){
    float totalHueOffset = map( (int)(message.getMessage()[2] & 0xFF), 0, 127, 0.0, 4.5);  
    for (int i=0; i<numOfTriangles; i++){
      triangles[i].newHueOffset = i*totalHueOffset;
    } 
  }
  
  // Slider 6: Number of rows of triangles
  if ((int)(message.getMessage()[1] & 0xFF) == 6){
    float input = (int)(message.getMessage()[2] & 0xFF);
    int inputInt = (int)map(input,0,127, 1, 13);
     
    if (inputInt % 2 == 0){
       inputInt++;
    }
    
    rows = inputInt;
    heightgap = height/(rows+1);
    for (int i=0; i<numOfTriangles; i++){
      triangles[i].reCalcY();
    }
  }
  
  
  // Slider 7: Number of cols of triangles  
  if ((int)(message.getMessage()[1] & 0xFF) == 7){
    float input = (int)(message.getMessage()[2] & 0xFF);
    int inputInt = (int)map(input,0,127, 1, 29);
     
    if (inputInt % 2 == 0){
      inputInt++;
    }
     
    cols=inputInt;  
    widthgap = width/(cols+1);
    for (int i=0; i<numOfTriangles; i++){
      triangles[i].reCalcX();
    }
  }
}
