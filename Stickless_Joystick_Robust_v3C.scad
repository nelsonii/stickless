include <BOSL/constants.scad>
use <BOSL/shapes.scad>

fileVersion = "3C";

fingerSize = 20; // how wide is your finger?

caseDiameterXY = fingerSize*2.5; // cap sensors
//caseDiameterXY = fingerSize*4; // switches
caseHeightZ = 30;
caseLidHeight = 4; 
wallThickness = 3;

//MIC = microswitch
//CAP = capacitive touch
//MAG = magnetic standoffs
switchType = "CAP"; //MIC, CAP, MAG

overlap = 1; // overlap ensures that subtractions go beyond the edges
$fn=60; //circle smoothness

sliceDesign = true; // must be true to render & export the top & bottom for assembly


//designFull();
// OR
designPrint();
// OR
//designPrintInsert(); // only for MIC or MAG


module designFull(){
  difference(){
    union(){
      base();
      if (switchType!="CAP") {contactRing(2.5);}
      if (switchType=="CAP") {contactRing(1.5);}  
      if (switchType=="MIC") {contactSwitch();}
      if (switchType=="CAP") {contactSensor();}
      if (switchType=="MAG") {contactSliderMagnets();}
      if (switchType!="CAP") {contactSlider();}
    }//union
   fingerHole();
   if (sliceDesign) {slice();}
  }//difference
}//designFull


module designPrint(){
  difference(){
    union(){
      base();
      if (switchType!="CAP") {contactRing(2.5);}
      if (switchType=="CAP") {contactRing(1.5);}  
    }//union
    if (switchType=="MIC") {contactSwitch();}
    if (switchType=="CAP") {contactSensor();}
    if (switchType=="MAG") {contactSliderMagnets();}
   fingerHole();
   if (sliceDesign) {slice();}
  }//difference
}//designPrint


module designPrintInsert() {
  difference(){  
    if (switchType!="CAP") {contactSlider();}
    if (switchType=="MAG") {contactSliderMagnets();}
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


module contactRing(multiplier) {
  contactHeightZ = caseHeightZ-caseLidHeight-overlap;
  idWallIn=fingerSize * multiplier;
  color("skyblue") tube(h=contactHeightZ, id=idWallIn-3, wall=5);
}//contactRing


module contactSwitch(){
     //MIC
  
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


module contactSensor() {
     //CAP

  //Make cutouts in the contact ring for four Cap sensor boards. Resizing and adjustments will be necessary!
  
  cutoutWidthX = 10.8-2;
  cutoutDepthY = 1+5;
  cutoutHeightZ = 14.2; 
  shift = (fingerSize/2) + ((fingerSize*0.75)/2);
  
  color("orange") translate([-18.5, -cutoutWidthX/2, 7.5]) cube([cutoutDepthY, cutoutWidthX, cutoutHeightZ+3.5]); //-X
  color("orange") translate([+12.5, -cutoutWidthX/2, 7.5]) cube([cutoutDepthY, cutoutWidthX, cutoutHeightZ+3.5]); //+X
  color("orange") translate([-(cutoutWidthX/2), +12.5, 7.5]) cube([cutoutWidthX, cutoutDepthY, cutoutHeightZ+3.5]); //+Y
  color("orange") translate([-(cutoutWidthX/2), -18.5, 7.5]) cube([cutoutWidthX, cutoutDepthY, cutoutHeightZ+3.5]); //+Y

  //slots for boards
  color("orangered") translate([-14, -(cutoutWidthX+2)/2, 7.5]) cube([1.1, cutoutWidthX+2, cutoutHeightZ+3.5]); //-X
  color("orangered") translate([+13, -(cutoutWidthX+2)/2, 7.5]) cube([1.1, cutoutWidthX+2, cutoutHeightZ+3.5]); //+X
  color("orangered") translate([-((cutoutWidthX+2)/2), +13, 7.5]) cube([cutoutWidthX+2, 1.1, cutoutHeightZ+3.5]); //+Y
  color("orangered") translate([-((cutoutWidthX+2)/2), -14, 7.5]) cube([cutoutWidthX+2, 1.1, cutoutHeightZ+3.5]); //+Y
  
  
}//contactSensor



module contactSlider() {

  contactHeightZ = caseHeightZ-caseLidHeight-overlap;
  wallThickness = 3.5;

  color("lime") tube(h=contactHeightZ, id=fingerSize, wall=wallThickness);
  color("limegreen") cylinder(h=3.5, d=fingerSize+(wallThickness*2));
  
}//contactslider


module contactSliderMagnets() {

  contactHeightZ = caseHeightZ-caseLidHeight-overlap;
  wallThickness = 3.5;

  //magnet inserts (optional -- used for mag version only)  
  magHeight = 3;
  magDiameter = 6.1;
  cMagZ = (caseHeightZ-caseLidHeight) / 2;
  shift = (fingerSize/2)+wallThickness;
  color("purple") translate([-shift, 0, cMagZ]) rotate([0,90,0]) cylinder(h=magHeight, d=magDiameter);
  color("purple") translate([+shift-magHeight, 0, cMagZ]) rotate([0,90,0]) cylinder(h=magHeight, d=magDiameter);
  color("purple") translate([0, -shift+magHeight, cMagZ]) rotate([90,90,0]) cylinder(h=magHeight, d=magDiameter);
  color("purple") translate([0, +shift, cMagZ]) rotate([90,90,0]) cylinder(h=magHeight, d=magDiameter);
  
}//contactSliderMagnets


module fingerHole() {

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