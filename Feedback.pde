void print_compound() {
   // Start Printing Feedback
 String[] element_name = {"H","He","Li","Be","B","C","N","O","F","Ne","Na","Mg","Al","Si","P","S","Cl","Ar","K","Ca"};
 String [][] metal = new String[6][2];
 String [][] nonmetal = new String[6][2];
 int full = 0;
 
 for (int i = 0; i < 6; i++) {
   //println ("i entered");
   if (electrons[i][0] != -1) {
     //println ("i entered 1");
     if (electrons[i][3] == 0) {
       for (int j = 0; j < 6; j++) {
         if ((electrons[i][2]-1) < 20) {
           if (metal[j][0] == element_name[(electrons[i][2]-1)]) {
             metal[j][1] = str(int(metal[j][1]) + 1);
             j = 6;
           } else if (metal[j][0] == null) {
             metal[j][0] = element_name[(electrons[i][2]-1)];
             metal[j][1] = "1";
             //println ("metal "+j+" "+metal[0][0]+" "+metal[0][1]);
             j = 6;
           }
         }
       }
     } else if (electrons[i][3] == 8) {
       for (int j = 0; j < 6; j++) {
         if ((electrons[i][2]-1) < 20) {
           if (nonmetal[j][0] == element_name[(electrons[i][2]-1)]) {
             //println ("i entered here too1!");
             nonmetal[j][1] = str(int(nonmetal[j][1]) + 1);
             j = 6;
           } else if (nonmetal[j][0] == null) {
             //println ("i entered here too2!");
             nonmetal[j][0] = element_name[(electrons[i][2]-1)];
             nonmetal[j][1] = "1";
             //println ("nonmetal "+j+" "+nonmetal[j][0]+" "+nonmetal[j][1]);
             j = 6;
           }
         }
       }
       // println ("nonmetal "+nonmetal[1][0]+" "+nonmetal[1][1]);
     } else {
       full = -1;
       i = 6;
     }
   }
 }
 
 String printing_compounds;
 printing_compounds = "";
 if (full == 0) {
   //pushMatrix();
   //translate(100,100);
   //textSize(45);
    
   
   for (int i = 0; i < 6; i++) {
     if ( metal[i][0] != null) {
       //print (metal[i][0]);
       printing_compounds = printing_compounds + metal[i][0];
       if ( metal[i][1] != "1") {
         //print (metal[i][1]);
         printing_compounds = printing_compounds + metal[i][1];
       }
     }
   }
   for (int i = 0; i < 6; i++) {
     if ( nonmetal[i][0] != null) {
       //print (nonmetal[i][0]);
       printing_compounds = printing_compounds + nonmetal[i][0];
       if ( nonmetal[i][1] != "1") {
         //print (nonmetal[i][1]);
         printing_compounds = printing_compounds + nonmetal[i][1];
       }
     }
   }
   
   if ( printing_compounds != "" ) {
     fill(150,250,0);
     noStroke();
     rect(0,0,1280,100);
     //success_sound();
   } else {
     fill(250,205,7);
     noStroke();
     rect(0,0,1280,100);
   }
   
   //translate(width/2,height/10);
   textSize(42);
  
   textAlign(CENTER);
   fill(0, 0, 0);
   
   text(printing_compounds, width/2, height/10); 

   //println (" ");
   //println (printing_compounds);
   //popMatrix();
 }
 // End Printing Feedback
}


void stop()
{
  player.close();
  minim.stop();
  super.stop();
}

void add_sound()
{
  player.close();
  player = minim.loadFile("transfer_in.mp3",2048);
  player.play();
}

void remove_sound()
{
  player.close();
  player = minim.loadFile("transfer_out.mp3",2048);
  player.play();
}

void success_sound()
{
  //player.close();
  player = minim.loadFile("transfer_out.mp3",2048);
  player.play();
}

void mydelay() {
  {
     try
    {    
      Thread.sleep(500);
    }
    catch(Exception e){}
  }
}
