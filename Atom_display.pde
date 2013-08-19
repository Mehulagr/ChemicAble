// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com

// Example 14-18: Object-oriented solar system

class Planet {
  // Each planet object keeps track of its own angle of rotation.
  float theta;      // Rotation around sun
  float diameter;   // Size of planet
  float distance;   // Distance from sun
  float orbitspeed; // Orbit speed
  int session;      // Session Id
  int symbol;       // Symbol id to know what actual atom is
  int electrons;  // to know the no. of electrons actually present
  int a;
  
  Planet(float distance_, float diameter_, int session_, int symbol_, int electrons_) {
    distance = distance_;
    diameter = diameter_;
    electrons = electrons_;
    symbol = symbol_;
    theta = 0;
    orbitspeed = 0.02;
    // planets[0].orbitspeed = 0.01;
  }
  
  void update() {
    // Increment the angle to rotate
    theta += orbitspeed;
    //println ("electrons are " + electrons);
  }
  
  void display() {
    
    a = ((symbol-2) % 8);
    
    //println ("electrons are " + electrons);
    for (int m = 0; m < electrons; m++) {
    // Before rotation and translation, the state of the matrix is saved with pushMatrix().
    pushMatrix(); 
    // Rotate orbit
    rotate(theta); 
    // translate out distance
    translate(distance,0); 
    noStroke();
    //println ("m =" + a+" a =" + a);
    if ( electrons < 4 ) {
      fill(255,125,0);
    } else if (m <= (a-1) ) {
      fill (0,0,255);
    } else {
      fill(255,125,0);
    }
    
    strokeWeight(6);
    stroke(255,255,255);
    
    ellipse(0,0,diameter*3,diameter*3);                                                                          //Electrons Diameter
    // Once the planet is drawn, the matrix is restored with popMatrix() so that the next planet is not affected.
    popMatrix(); 
    
    if (m % 2 == 1) {
      rotate(1.2); 
    } else {
      rotate(0.4);
    }
  }
  
  }
}
