include <BOSL/constants.scad>
use <BOSL/shapes.scad>

fileVersion = "1.1";

fingerSize = 20; // how wide is your finger?

caseDiameterXY = fingerSize*3;
caseHeightZ = 30;
caseLidHeight = 4; 
wallThickness = 3;


overlap = 1; // overlap ensures that subtractions go beyond the edges
$fn=60; //circle smoothness

sliceDesign = true; // must be true to render & export the top & bottom for assembly

designFull();
// OR
//designPrint();


module designFull(){
  difference(){
    union(){
      base();
      contact();
      //contactscrew();
      contactswitch();
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


module base(){
  difference(){
    //base shape
    color("skyblue") cyl(l=caseHeightZ, d=caseDiameterXY, fillet=3, center=false);
    //hollow out base shape
    translate([0,0,wallThickness/2]) cyl(l=caseHeightZ-wallThickness, d=caseDiameterXY-wallThickness, fillet=3, center=false);
  }//difference
}//base


module contact() {

  shift = (fingerSize/2) + ((fingerSize*0.75)/2);
  contactHeightZ = caseHeightZ-caseLidHeight-overlap;

  color("steelblue")  cuboid([5,10,contactHeightZ], fillet=1, p1=[-shift, -5, 0]); //-X
  color("steelblue")  cuboid([5,10,contactHeightZ], fillet=1, p1=[+shift-5, -5, 0]); //+X
  color("steelblue")  cuboid([10,5,contactHeightZ], fillet=1, p1=[-5, -shift, 0]); //-Y
  color("steelblue")  cuboid([10,5,contactHeightZ], fillet=1, p1=[-5, +shift-5, 0]); //+Y

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
  
  switchWidthX = 6.5;
  switchDepthY = 9.5;
  switchHeightZ = 24 - wallThickness; // (20, but 24 with roller)
  shift = (fingerSize/2) + ((fingerSize*0.75)/2); 
  
  translate([-shift-(switchWidthX/2),-switchWidthX/2,wallThickness]) cube([switchDepthY, switchWidthX, switchHeightZ]);
  translate([+shift-(switchDepthY/2),-switchWidthX/2,wallThickness]) cube([switchDepthY, switchWidthX, switchHeightZ]);


}//contactswitch


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