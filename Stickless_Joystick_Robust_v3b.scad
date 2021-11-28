include <BOSL/constants.scad>
use <BOSL/shapes.scad>

fileVersion = "3B";

fingerSize = 20; // how wide is your finger?

caseDiameterXY = fingerSize*4;
caseHeightZ = 30;
caseLidHeight = 4; 
wallThickness = 3;

//MIC = microswitch
//CAP = capacitive touch
//MAG = magnetic standoffs
switchType = "MIC"; //MIC, CAP, MAG

overlap = 1; // overlap ensures that subtractions go beyond the edges
$fn=60; //circle smoothness

sliceDesign = true; // must be true to render & export the top & bottom for assembly

designFull();
// OR
//designPrint();
// OR
//designPrintInsert();

module designFull(){
  difference(){
    union(){
      base();
      contact();
      //contactscrew();
      contactswitch();
      contactslider();
      contactslidermagnets();
    }//union
   finger();
   if (sliceDesign) {slice();}
  }//difference
}//designFull


module designPrint(){
  difference(){
    union(){
      base();
      contact();
    }//union
    //contactscrew();
    contactswitch();
    contactslidermagnets();
   finger();
   if (sliceDesign) {slice();}
  }//difference
}//designPrint


module designPrintInsert() {
  difference(){  
    contactslider();
    contactslidermagnets();
  }
}//designPrintInsert



module base(){
  difference(){
    //base shape
    color("skyblue") cyl(l=caseHeightZ, d=caseDiameterXY, fillet=3, center=false);
    //hollow out base shape
    translate([0,0,wallThickness/2]) cyl(l=caseHeightZ-wallThickness, d=caseDiameterXY-wallThickness, fillet=3, center=false);
    //emboss version on inside case (bottom)
     color("whitesmoke")
         translate([-4.5, -2.5, 1])
          linear_extrude(2)
           text(fileVersion, size=5);
  }//difference
}//base


module contact() {

  contactHeightZ = caseHeightZ-caseLidHeight-overlap;

  idWallIn = fingerSize * 2.5;
  color("skyblue") tube(h=contactHeightZ, id=idWallIn-3, wall=5);

  //idWallOut = fingerSize + (fingerSize*1.50);
  //color("deepskyblue") tube(h=contactHeightZ, id=idWallOut-3, wall=3);

}//contact


module contactscrew() {
  
  //WIP -- working on switches first.
  
  cScrewDiameter = 5.0; // M5 screw
  cScrewHeight = 10.75; // M5*8 screw, 8mm threads exposed
  cScrewHeadDiamater = 9.35; // M5 cap/mushroom head screw (smooth rounded)
  cScrewHeadHeight = 2.75; // M5 cap/mushroom head screw (smooth rounded) 

  shift = (fingerSize/2) + ((fingerSize*0.75)/2) + ((cScrewHeight - cScrewHeadHeight) / 2);
  cScrewZ = caseHeightZ-caseLidHeight-overlap-5;

  color("purple") translate([-shift, 0, cScrewZ]) rotate([0,90,0]) cylinder(h=cScrewHeight, d=cScrewDiameter); //-X
  color("purple") translate([+shift-cScrewHeight, 0, cScrewZ]) rotate([0,90,0]) cylinder(h=cScrewHeight, d=cScrewDiameter); //+X
  color("purple") translate([0, -shift+cScrewHeight, cScrewZ]) rotate([90,90,0]) cylinder(h=cScrewHeight, d=cScrewDiameter); //-Y
  color("purple") translate([0, +shift, cScrewZ]) rotate([90,90,0]) cylinder(h=cScrewHeight, d=cScrewDiameter); //+Y

  
}//contactscrew


module contactswitch(){
  
  //Make cutouts in the contact ring for four microswitches. Resizing and adjustments will be necessary!
  
  switchWidthX = 6.4;
  switchDepthY = 10.5+7; // actual switch is 10.5. the 7 is point where switch contacts
  switchHeightZ = 20.2; 
  shift = (fingerSize/2) + ((fingerSize*0.75)/2);
  
  color("orange") translate([-31, -switchWidthX/2, 1.5]) cube([switchDepthY, switchWidthX, switchHeightZ+3.5]); //-X
  color("orange") translate([+13.5, -switchWidthX/2, 1.5]) cube([switchDepthY, switchWidthX, switchHeightZ+3.5]); //+X
  color("orange") translate([-(switchWidthX/2), +13.5, 1.5]) cube([switchWidthX, switchDepthY, switchHeightZ+3.5]); //+Y
  color("orange") translate([-(switchWidthX/2), -31, 1.5]) cube([switchWidthX, switchDepthY, switchHeightZ+3.5]); //+Y

}//contactswitch




module contactslider() {

  contactHeightZ = caseHeightZ-caseLidHeight-overlap;
  wallThickness = 3.5;

  color("lime") tube(h=contactHeightZ, id=fingerSize, wall=wallThickness);
  color("limegreen") cylinder(h=3.5, d=fingerSize+(wallThickness*2));
  
}//contactslider


module contactslidermagnets() {

  contactHeightZ = caseHeightZ-caseLidHeight-overlap;
  wallThickness = 3.5;

  //magnet inserts (optional -- used for mag version only)  
  magHeight = 3;
  magDiameter = 6;
  cMagZ = (caseHeightZ-caseLidHeight) / 2;
  shift = (fingerSize/2)+wallThickness;
  color("purple") translate([-shift, 0, cMagZ]) rotate([0,90,0]) cylinder(h=magHeight, d=magDiameter);
  color("purple") translate([+shift-magHeight, 0, cMagZ]) rotate([0,90,0]) cylinder(h=magHeight, d=magDiameter);
  color("purple") translate([0, -shift+magHeight, cMagZ]) rotate([90,90,0]) cylinder(h=magHeight, d=magDiameter);
  color("purple") translate([0, +shift, cMagZ]) rotate([90,90,0]) cylinder(h=magHeight, d=magDiameter);
  
}//contactslidermagnets


module finger() {

  //center hole
  translate([0,0,caseHeightZ-wallThickness-overlap]) cylinder(h=wallThickness+(overlap*2), d=fingerSize, center=false);

  //four directional guides
  translate([-fingerSize*0.25, 0, caseHeightZ-wallThickness-overlap]) cylinder(h=wallThickness+(overlap*2), d=fingerSize*.75, center=false);
  translate([+fingerSize*0.25, 0, caseHeightZ-wallThickness-overlap]) cylinder(h=wallThickness+(overlap*2), d=fingerSize*.75, center=false);
  translate([0, -fingerSize*0.25, caseHeightZ-wallThickness-overlap]) cylinder(h=wallThickness+(overlap*2), d=fingerSize*.75, center=false);
  translate([0, +fingerSize*0.25, caseHeightZ-wallThickness-overlap]) cylinder(h=wallThickness+(overlap*2), d=fingerSize*.75, center=false);

}//finger


module slice(){
  
   splitAtZ=caseHeightZ-caseLidHeight;
  
  //remove the top for split
  color("crimson")  translate([-((caseDiameterXY+overlap)/2),-((caseDiameterXY+overlap)/2),splitAtZ])  cube([caseDiameterXY+overlap, caseDiameterXY+overlap, caseHeightZ+overlap]);
  // ******* OR ******
  //Remove everything but the top
  //color("crimson") translate([-((caseDiameterXY+overlap)/2),-((caseDiameterXY+overlap)/2),splitAtZ-caseHeightZ])  cube([caseDiameterXY+overlap, caseDiameterXY+overlap, caseHeightZ+overlap]);
  
}//slice