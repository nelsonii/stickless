include <BOSL/constants.scad>
use <BOSL/shapes.scad>

fileVersion = "2.6";

fingerSize = 20; // how wide is your finger?

caseDiameterXY = fingerSize*3.6;
caseHeightZ = 30;
caseLidHeight = 4; 
wallThickness = 3;


overlap = 1; // overlap ensures that subtractions go beyond the edges
$fn=60; //circle smoothness

sliceDesign = true; // must be true to render & export the top & bottom for assembly

//designFull();
// OR
designPrint();
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
      db9();
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
  color("skyblue") tube(h=contactHeightZ, id=wall-3, wall=10);

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
  switchHeightZ = 20.2+overlap; 
  shift = (fingerSize/2) + ((fingerSize*0.75)/2);
  
  color("orange") translate([-32, -switchWidthX/2, 3]) cube([switchDepthY, switchWidthX, switchHeightZ+overlap]); //-X
  color("orange") translate([+13.5, -switchWidthX/2, 3]) cube([switchDepthY, switchWidthX, switchHeightZ+overlap]); //+X
  color("orange") translate([-(switchWidthX/2), +13.5, 3]) cube([switchWidthX, switchDepthY, switchHeightZ+overlap]); //+Y
  color("orange") translate([-(switchWidthX/2), -32, 3]) cube([switchWidthX, switchDepthY, switchHeightZ+overlap]); //+Y


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
  
  color("violet")
  translate([52,-15.5,-1+5])
    cube([1.1, 31, 12.5]);
  
  color("magenta")
  rotate([0,90,0])
  translate([-5-5, -13, 51.5])
   cylinder(h=2, d=3);
  color("magenta")
  rotate([0,90,0])
  translate([-5-5, +13, 51.5])
   cylinder(h=2, d=3);

  
  color("darkviolet")
  translate([50, 0, 0+5]) 
   prismoid(size1=[14.75, 16.75], size2=[14.75, 19.25], h=10.75);
  
}//db9

module slice(){
  
   splitAtZ=caseHeightZ-caseLidHeight;
  
  //remove the top for split
  color("crimson")  translate([-((caseDiameterXY+overlap)/2),-((caseDiameterXY+overlap)/2),splitAtZ])  cube([caseDiameterXY+overlap, caseDiameterXY+overlap, caseHeightZ+overlap]);
  // ******* OR ******
  //Remove everything but the top
  //color("crimson") translate([-((caseDiameterXY+overlap)/2),-((caseDiameterXY+overlap)/2),splitAtZ-caseHeightZ])  cube([caseDiameterXY+overlap, caseDiameterXY+overlap, caseHeightZ+overlap]);
  
}//slice