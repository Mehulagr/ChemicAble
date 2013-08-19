// TUIO 
// Ashok, Mehul, Minal, Vikas
// http://www.embeddedinteractions.com/

// An array of 8 planet objects
import TUIO.*;
import ddf.minim.*;

PImage bg;

Minim minim;
AudioPlayer player;
TuioProcessing tuioClient;

// these are some helper variables which are used
// to create scalable graphical feedback
float cursor_size = 15;
float object_size = 100;
float table_size = 720;
float scale_factor = 1;
PFont font;

int excess = 0;
Planet[] planets = new Planet[19];
int b;
int [][] electrons = new int[6][4];

void setup() {
  size(1280,720);
  smooth();
  scale_factor = height/table_size;
  
  bg = loadImage("4.jpg");
  
  minim = new Minim(this);
  player = minim.loadFile("add.mp3", 2048);
   
  tuioClient  = new TuioProcessing(this);
  for (int i = 0; i < 6; i++) {
    for (int j = 0; j <4; j++) {
      electrons[i][j] = -1;
    }
  }

  for (int i = 0; i < planets.length; i++ ) {
    planets[i] = new Planet(object_size, 30, -1, -1, -1);
  }
  // The planet objects are initialized using the counter variable
  
}

void draw() {
  background(bg);
  noStroke();
  
  fill(250,205,7);
  rect(0,0,1280,100);
     
  float obj_size = object_size*scale_factor; 
   
  Vector tuioObjectList = tuioClient.getTuioObjects();        //For Fiducial Marker
  for (int i=0;i<tuioObjectList.size();i++) {
     TuioObject tobj = (TuioObject)tuioObjectList.elementAt(i);
     stroke(0);
     fill(255);
     
     pushMatrix();
     translate(tobj.getScreenX(width),tobj.getScreenY(height));
     
     pushMatrix();
     for (int j=0; j<6; j++){ 
       if (tobj.getSessionID()==electrons[j][1]){ 
         if (electrons[j][3]==0 || electrons[j][3] == 8) {
           strokeWeight(8);
           stroke(150,250,0);
         } else {
           strokeWeight(8);
           stroke(0,255,255);
         }
         // Stroke Weight here
         ellipseMode(CORNER);
         ellipse(-obj_size,-obj_size,2*obj_size,2*obj_size);
       }
     }
     popMatrix();
     
     pushMatrix();
     textSize(26);
     for (int j=0; j<6; j++){ 
       if (tobj.getSessionID()==electrons[j][1]){ 
         int calc_va = (( electrons[j][2] - 2 ) % 8);
         if (electrons[j][3] != calc_va ) {
           if ( calc_va != 0 ) {
             int charge = calc_va - electrons[j][3];
             fill(125,125,125);
             translate(object_size,-object_size);
             text(str(charge), 0, 0);
           }
         }
       }
     }
     popMatrix();
     
     ellipseMode(CENTER);
     fill(255);
     
     //planets[1].update();
     //planets[1].display();
     for (int m =0; m < 6; m++) {  
       if (electrons[m][1] == tobj.getSessionID()) {
       m = int(electrons[m][0]);
       planets[m].update();
       planets[m].display();
       }
     }
     popMatrix();
  }
  
print_compound();
}

void addTuioObject(TuioObject tobj) {
  println("add object "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle());
  
  player.close();
  player = minim.loadFile("add.mp3",2048);
  player.play();
  
  int t;
  int p;
  int c;
  t = 0;
  c = tobj.getSymbolID();
  
  pushMatrix();
  int abc = 0;
  int bcd = 0;
   for (int i = 0; i < 6; i++ ){                                //Updating entry
     if (electrons[i][0] == -1) {
       electrons[i][0] = i;
       electrons[i][1] = int(tobj.getSessionID());
       electrons[i][2] = tobj.getSymbolID();
       electrons[i][3] = ((tobj.getSymbolID() - 2) % 8);
       abc = i;
       i = 6;
       println(abc);
       //planets[tobj.getSymbolID()] = new Planet(object_size, 8, c, 0);
     }
   }
   
   Vector tuioObjectList4 = tuioClient.getTuioObjects();        
      for (int i=0;i<tuioObjectList4.size();i++) {                 //Getting the sessionID of the objects on table
        TuioObject tobj4 = (TuioObject)tuioObjectList4.elementAt(i);
        for (int j=0;j<tuioObjectList4.size();j++) {                //Loop to get the corresponding value in the 2D elctron array.
          if (tobj4.getSessionID() == electrons[j][1]) {
            planets[electrons[j][0]] = new Planet(object_size, 8, electrons[j][1], electrons[j][2], ((electrons[j][2] - 2) % 8));
            //println("assignment details "+tobj3.getSessionID()+", "+tobj3.getSymbolID()+", "+electrons[j][3]);
            j = tuioObjectList4.size();
          }
        }
      }
      
   mydelay();
   
   println("I came here");
   
   for (int i = 0; i < 6; i++ ){                                //Updating entry
     if (electrons[i][0] == abc) {
       electrons[abc][0] = -1;
       electrons[abc][1] = -1;
       electrons[abc][2] = -1;
       electrons[abc][3] = -1;
       i = 6;
       println(abc);
       //planets[tobj.getSymbolID()] = new Planet(object_size, 8, c, 0);
     }
   }      
   popMatrix();
   
  if ( c > 2) {
    c = (c-2) % 8;
    if ( c == 0 ) {
      c = 8;
    }
   
    if ( c < 4 ) {                                                    //When Metals are being added
      //println("c is "+c);
      Vector tuioObjectList = tuioClient.getTuioObjects();        
      for (int i=0; i<tuioObjectList.size(); i++) {                 //Getting the sessionID of the objects on table
        TuioObject tobj2 = (TuioObject)tuioObjectList.elementAt(i);
        for (int j=0; j<tuioObjectList.size(); j++) {                //Loop to get the corresponding value in the 2D elctron array.
          if (tobj2.getSessionID() == electrons[j][1]) {
            t = j;
            j = tuioObjectList.size();
          }
        }
        if (electrons[t][3] > 3 && electrons[t][3] < 8 ) {        //Transfer Possibility
          p = 8 - electrons[t][3];
          if (p >= c) {
            electrons[t][3] = electrons[t][3] + c;
            c = 0;
            i = tuioObjectList.size();
            add_sound();
          } else {
            c = c - p;
            electrons[t][3] = electrons[t][3] + p;
            add_sound();
          }
        }
      }
    } else {                                                    //When Non Metals are being added
      //excess = excess + c;
      Vector tuioObjectList = tuioClient.getTuioObjects();        
      for (int i=0;i<tuioObjectList.size();i++) {                 //Getting the sessionID of the objects on table
        TuioObject tobj2 = (TuioObject)tuioObjectList.elementAt(i);
        for (int j=0;j<tuioObjectList.size();j++) {                //Loop to get the corresponding value in the 2D elctron array.
          if (tobj2.getSessionID() == electrons[j][0]) {
            t = j;
            j = tuioObjectList.size();
          }
        }
        if (electrons[t][3] > 0 && electrons[t][3] < 4 ) {        //Transfer Possibility
          p = electrons[t][3];
          if (p >= (8-c)) {
            electrons[t][3] = p-8+c;
            c = 8;
            i = tuioObjectList.size();
            add_sound();
          } else {
            c = c + p;
            electrons[t][3] = 0;
            add_sound();
          }
        }
      }
    }
   
   for (int i = 0; i < 6; i++ ){                                //Updating entry
     if (electrons[i][0] == -1) {
       electrons[i][0] = i;
       electrons[i][1] = int(tobj.getSessionID());
       electrons[i][2] = tobj.getSymbolID();
       electrons[i][3] = c;
       i = 6;
       //planets[tobj.getSymbolID()] = new Planet(object_size, 8, c, 0);
     }
   }
   
   Vector tuioObjectList = tuioClient.getTuioObjects();        
      for (int i=0;i<tuioObjectList.size();i++) {                 //Getting the sessionID of the objects on table
        TuioObject tobj3 = (TuioObject)tuioObjectList.elementAt(i);
        for (int j=0;j<tuioObjectList.size();j++) {                //Loop to get the corresponding value in the 2D elctron array.
          if (tobj3.getSessionID() == electrons[j][1]) {
            planets[electrons[j][0]] = new Planet(object_size, 8, electrons[j][1], electrons[j][2], electrons[j][3]);
            //println("assignment details "+tobj3.getSessionID()+", "+tobj3.getSymbolID()+", "+electrons[j][3]);
            j = tuioObjectList.size();
          }
        }
      }
 }
 
 for (int i = 0; i < 6; i++) { 
   println("Atom details "+electrons[i][0]+" "+electrons[i][1]+" "+electrons[i][2]+" "+electrons[i][3]);
 }
}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {                                            //Remove Start
  println("remove object "+tobj.getSymbolID()+" ("+tobj.getSessionID()+")");
  
  int c;  // variable Decleration area
  int t;
  int c1;
  t = 0;
  c1 = 0;
  c=tobj.getSymbolID();
  
  for (int i=0; i<6 ; i++) {                              //Figuring out which atom has been removed and what had the atom shared with other atoms.
    if (electrons[i][1] == tobj.getSessionID()) {
      
      if (tobj.getSymbolID() > 2) {
         c = (c-2) % 8;
      }
      t = c - electrons[i][3];
      electrons[i][0] = -1;
      electrons[i][1] = -1;
      electrons[i][2] = -1;
      electrons[i][3] = -1;
      println ("you removed object with "+c+" octet electrons and electrons left= "+electrons[i][3]+" and the difference is "+t);
      i = 6;
    }
  }
  
  if ( t > 0) {                                                                        //On removing Metal
    for (int i=0; i<6; i++) {
      if (electrons[i][3] >0 && electrons[i][3] < 4 && electrons[i][3] >= t) {
        //println("t is now = "+t);
        electrons[i][3] = electrons[i][3]-t;
        t=0;
        i = 6;
        remove_sound();
      } else if (electrons[i][3] >0 && electrons[i][3] < 4 && electrons[i][3] < t) {
        int bm = t - electrons[i][3];
        electrons[i][3] = 0;
        t = bm;
        remove_sound();
      }
    }
    
    println("1t is now = "+t);
    if ( t > 0) {
      for (int i=0; i<6; i++) {
        
        if (electrons[i][2] > 2) {
          c1 = (electrons[i][2]-2) % 8;
        }
        //println("c1 = "+ c1);
        //println("electrons[i][3] = "+ electrons[i][3]);
        if (electrons[i][3] >3 && electrons[i][3] <= 8 && (electrons[i][3]-c1) >= t) {
          electrons[i][3] = electrons[i][3]-t;
          t=0;
          i = 6;
          remove_sound();    
        } else if (electrons[i][3] >3 && electrons[i][3] <= 8 && (electrons[i][3]-c1) < t && (electrons[i][3]-c1) > 0) {
          int bm = t - (electrons[i][3]-c1);
          electrons[i][3] = c1;
          t = bm;
          remove_sound();
        }
      }
    }
    println("t is now = "+t);
  }
  
  if ( t < 0) {                                                                      //On removing Non-metal
  for (int i=0; i<6; i++) {
    if (electrons[i][2] > 2) {
      c1 = (electrons[i][2]-2) % 8;
    }
    //println("c1 = "+ c1);
    //println("electrons[i][3] = "+ electrons[i][3]);
    if (electrons[i][3] >3 && electrons[i][3] <= 8 && (8-electrons[i][3]) >= abs(t)) {
      electrons[i][3] = electrons[i][3]-t;
      t=0;
      i = 6;
      remove_sound();   
    } else if (electrons[i][3] >3 && electrons[i][3] <= 8 && (8-electrons[i][3]) < abs(t) && (8-electrons[i][3]) > 0) {
      int bm = abs(t) - (8-electrons[i][3]);
      electrons[i][3] = 8;
      t = -1*bm;
      remove_sound();
    }
  }

  if ( t < 0) {
    for (int i=0; i<6; i++) {
      if (electrons[i][2] > 2) {
        c1 = (electrons[i][2]-2) % 8;
      }
      if (electrons[i][3] >=0 && electrons[i][3] < 4 && (c1-electrons[i][3]) >= abs(t)) {
        //println("I came here1");
        //println("t is now = "+t);
        electrons[i][3] = electrons[i][3]-t;
        t=0;
        i = 6;
        remove_sound();
      } else if (electrons[i][3] >=0 && electrons[i][3] < 4 && (c1-electrons[i][3]) < abs(t)) {
        //println("I came here2");
        int bm = abs(t) - electrons[i][3];
        t = t-(c1-electrons[i][3]);
        electrons[i][3] = c1;
        remove_sound();
      }
    }
  }
  }

  
  Vector tuioObjectList = tuioClient.getTuioObjects();        
     for (int i=0;i<tuioObjectList.size();i++) {                 //Getting the sessionID of the objects on table
       TuioObject tobj3 = (TuioObject)tuioObjectList.elementAt(i);
       for (int j=0;j<tuioObjectList.size();j++) {                //Loop to get the corresponding value in the 2D elctron array.
         if (tobj3.getSessionID() == electrons[j][1]) {
           planets[electrons[j][0]] = new Planet(object_size, 8, electrons[j][1], electrons[j][2], electrons[j][3]);
           //println("assignment details "+tobj3.getSessionID()+", "+tobj3.getSymbolID()+", "+electrons[j][3]);
           j = tuioObjectList.size();
         }
       }
     }
}                                                                                        //Remove End

// called when an object is moved
void updateTuioObject (TuioObject tobj) {
  //println("update object "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle() +" "+tobj.getMotionSpeed()+" "+tobj.getRotationSpeed()+" "+tobj.getMotionAccel()+" "+tobj.getRotationAccel());
}

// called when a cursor is added to the scene
void addTuioCursor(TuioCursor tcur) {
  println("add cursor "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY());
}

// called when a cursor is moved
void updateTuioCursor (TuioCursor tcur) {
  //println("update cursor "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY() +" "+tcur.getMotionSpeed()+" "+tcur.getMotionAccel());
}

// called when a cursor is removed from the scene
void removeTuioCursor(TuioCursor tcur) {
  println("remove cursor "+tcur.getCursorID()+" ("+tcur.getSessionID()+")");
}

// called after each message bundle
// representing the end of an image frame
void refresh(TuioTime bundleTime) { 
  redraw();
}
