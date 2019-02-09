class Triangle{
  
  PVector location;
  PVector newLocation;
  PVector pointA;
  PVector pointB;
  PVector pointC;
  PVector centre;
  
  int col;
  int row;
  int id;
    
  float size;
  float newSize;
  
  float h;
  
  float thickness;
  
  float innerOpacity;
  
  float hue;
  float hueChange;
  float hueOffset;
  float newHueOffset;
  
  float xSpin;
  float ySpin;
  float zSpin;
  float xSpinChange;
  float ySpinChange;
  float zSpinChange;
  float spinOffset;
  float newSpinOffset;
  
  Triangle(int col_, int row_, int id_){
    
    col = col_;
    row = row_;
    id = id_;
    size =30;
    newSize = 30;
    location = new PVector((col*widthgap) + widthgap, (row * heightgap) + heightgap);
    newLocation = new PVector((col*widthgap) + widthgap, (row * heightgap) + heightgap);
 
    
    // Each triangle has a location and then its points are calculated from that one point.    
    calcSize();
       
    hue = id/10;
    hueChange = 0.1;
    hueOffset = 0;
    newHueOffset = 0;
    innerOpacity = 30;
    
    xSpin = 0;
    ySpin = 0;
    zSpin = 0;    
    xSpinChange = 0.01;
    ySpinChange = 0.01;
    zSpinChange = 0.01;
    spinOffset = 0;
    newSpinOffset = 0;
    
    thickness = 2;
  }
  
  void update(){
    
    // Spin and update hue
    xSpin+= xSpinChange;
    ySpin+= ySpinChange;
    zSpin+= zSpinChange;
    hue+= hueChange;
    
     // Animate towards new location when the x and y value change due to number of cols/rows changing    
    PVector direction = PVector.sub(newLocation, location);
    direction = direction.div(animationSpeed);
    location = location.add(direction);

    // Animate towards new size
    float sizeGap = newSize - size;
    sizeGap = sizeGap / animationSpeed;
    size += sizeGap;
    
    // Animate towards new spin offset
    float spinGap = newSpinOffset - spinOffset;
    spinGap = spinGap / animationSpeed;
    spinOffset += spinGap;
    
    // Animate towards new hue offset
    float hueGap = newHueOffset - hueOffset;
    hueGap = hueGap / animationSpeed;
    hueOffset += hueGap;
    
    // Recalc the trigonometry that finds the points, since the size of the triangle might have changed
    calcSize();
    
  }
  
  void display(){
    fill((hue+hueOffset)%100,80,100,innerOpacity);
    stroke((hue+hueOffset)%100, 100,100);
    strokeWeight(thickness);
    
    pushMatrix();
      translate(centre.x+100,centre.y,id*3);
      rotateZ(zSpin + spinOffset);
      rotateX(xSpin + spinOffset);
      rotateY(ySpin + spinOffset);
      triangle(pointA.x, pointA.y, pointB.x, pointB.y, pointC.x, pointC.y);      
    popMatrix();
  }
  
  
  // Trigonomentry. 
  void calcSize(){
    h = sin(1.0472)*size;
    float ch = sin(0.523599) * (h/2);    
    
    if(id%2==0){
      centre = new PVector (location.x-size/2, location.y-ch);      
      pointA = new PVector(-(size/2), ch);
      pointB = new PVector(size/2, ch);
      pointC = new PVector(0, ch-h);
    }
    
    else{
      centre = new PVector (location.x, location.y-h+ch);
      pointA = new PVector(-(size/2), -ch);
      pointB = new PVector(0, h-ch);
      pointC = new PVector(size/2, -ch);
 
    }
  }
  
  // figure out new locations when the number of cols or rows changes
  void reCalcX(){
    newLocation.x = (col * widthgap) + widthgap;
  }
  
  void reCalcY(){        
    newLocation.y = (row * heightgap) + heightgap;
  }
 
  
}
  
    
