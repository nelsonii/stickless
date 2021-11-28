include <BOSL/constants.scad>
use <BOSL/shapes.scad>

fileVersion = "1.1";

fingerSize = 20; // how wide is your finger?

caseDiameterXY = fingerSize*3.5;
caseHeightZ = 30;
caseLidHeight = 4; 
wallThickness = 3;


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
      contactswitchslider();
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
   finger();
   if (sliceDesign) {slice();}
  }//difference
}//designPrint


module designPrintInsert() {
  difference(){  
    contactswitchslider();
    contactswitch();
  }//difference
}//designPrintInsert



module base(){
  difference(){
    //base shape
    color("skyblue") cyl(l=caseHeightZ, d=caseDiameterXY, fillet=3, center=false);
    //hollow out base shape
    translate([0,0,wallThickness/2]) cyl(l=caseHeightZ-wallThickness, d=caseDiameterXY-wallThickness, fillet=3, center=false);
  }//difference
}//base


module contact() {

  //shift = (fingerSize/2) + ((fingerSize*0.75)/2);
  wall = fingerSize + (fingerSize*0.75);
  contactHeightZ = caseHeightZ-caseLidHeight-overlap;
  color("skyblue") tube(h=contactHeightZ, id=wall-8, wall=8);

}//contact


module contactscrew() {
  
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
  
  switchWidthX = 6.4;
  switchDepthY = 10.5+overlap+7; // actual switch is 10.5. the 7 is point where switch contacts
  switchHeightZ = 20.2; 
  shift = (fingerSize/2) + ((fingerSize*0.75)/2);
  
  color("orange") translate([-30, -switchWidthX/2, wallThickness]) cube([switchDepthY, switchWidthX, switchHeightZ+2]); //-X
  color("orange") translate([+11, -switchWidthX/2, wallThickness]) cube([switchDepthY, switchWidthX, switchHeightZ+2]); //+X
  color("orange") translate([-(switchWidthX/2), +11, wallThickness]) cube([switchWidthX, switchDepthY, switchHeightZ+2]); //+Y
  color("orange") translate([-(switchWidthX/2), -30, wallThickness]) cube([switchWidthX, switchDepthY, switchHeightZ+2]); //+Y


}//contactswitch


module contactswitchslider() {

  contactHeightZ = caseHeightZ-caseLidHeight-overlap;
  color("lime") tube(h=contactHeightZ, id=fingerSize, wall=3);
  
}//contactswitchslider


module finger() {

  //center hole
  translate([0,0,caseHeightZ-wallThickness-overlap]) cylinder(h=wallThickness+(overlap*2), d=fingerSize, center=false);

  //four directional guides
  translate([-fingerSize*0.25, 0, caseHeightZ-wallThickness-overlap]) cylinder(h=wallThickness+(overlap*2), d=fingerSize*.75, center=false);
  translate([+fingerSize*0.25, 0, caseHeightZ-wallThickness-overlap]) cylinder(h=wallThickness+(overlap*2), d=fingerSize*.75, center=false);
  translate([0, -fingerSize*0.25, caseHeightZ-wallThickness-overlap]) cylinder(h=wallThickness+(overlap*2), d=fingerSize*.75, center=false);
  translate([0, +fingerSize*0.25, caseHeightZ-wallThickness-overlap]) cylinder(h=wallThickness+(overlap*2), d=fingerSize*.75, center=false);

}//finger


module db9(){
  
  
}//db9

module slice(){
  
   splitAtZ=caseHeightZ-caseLidHeight;
  
  //remove the top for split
  color("crimson")  translate([-((caseDiameterXY+overlap)/2),-((caseDiameterXY+overlap)/2),splitAtZ])  cube([caseDiameterXY+overlap, caseDiameterXY+overlap, caseHeightZ+overlap]);
  // ******* OR ******
  //Remove everything but the top
  //color("crimson") translate([-((caseDiameterXY+overlap)/2),-((caseDiameterXY+overlap)/2),splitAtZ-caseHeightZ])  cube([caseDiameterXY+overlap, caseDiameterXY+overlap, caseHeightZ+overlap]);
  
}//slice