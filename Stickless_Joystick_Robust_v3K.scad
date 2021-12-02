include <BOSL/constants.scad>
use <BOSL/shapes.scad>

fileVersion = "3K";

fingerSize = 20; // how wide is your finger?

//caseDiameterXY = fingerSize*2.5; // cap sensors -- DANGER: will currently mess up mounting holes etc!!!
caseDiameterXY = fingerSize*4; // switches
caseHeightZ = 28;
caseLidHeight = 4; 
wallThickness = 3;

//MIC = microswitch
//CAP = capacitive touch
//MAG = magnetic standoffs
switchType = "MIC"; //MIC, CAP, MAG -- focused on MICroswitches right now

jackDiameter = 6.35;
jackLength = 23;

mountingScrewDiameter = 2.0; // M2 Screw
mountingScrewHeadDiameter = 3.5; // M2 Phillips Head Screw
mountingScrewHeadHeight = 1.7; // M2 Phillips Head Screw

overlap = 1; // overlap ensures that subtractions go beyond the edges
$fn=60; //circle smoothness

sliceDesign = true; // must be true to render & export the top & bottom for assembly


designFull();
// OR
//designPrint();
// OR
//designPrintInsert(); // only for MIC or MAG
// OR
//designPrintTools(); // only for switches, helps alignment during gluing

module designFull(){
  difference(){
    union(){
      base();
      caseClosureStandoffs();
      caseClosureScrews();
      if (switchType!="CAP") {contactRing(2.5);}
      if (switchType=="CAP") {contactRing(1.2);}  
      if (switchType=="MIC") {contactSwitch();}
      if (switchType=="CAP") {contactSensor();}
      if (switchType=="MAG") {contactSliderMagnets();}
      if (switchType!="CAP") {contactSlider();}
      jacks();
      tool_switchHolderOutside();
      tool_switchHolderInside();
      }//union
   fingerHole();
   if (sliceDesign) {slice();}
  }//difference
}//designFull


module designPrint(){
  difference(){
    union(){
      base();
      caseClosureStandoffs();
      if (switchType!="CAP") {contactRing(2.5);}
      if (switchType=="CAP") {contactRing(1.2);}  
    }//union
    if (switchType=="MIC") {contactSwitch();}
    if (switchType=="CAP") {contactSensor();}
    if (switchType=="MAG") {contactSliderMagnets();}

   fingerHole();
   jacks();
   caseClosureScrews();
   if (sliceDesign) {slice();}
  }//difference
}//designPrint


module designPrintInsert() {
  difference(){  
    if (switchType!="CAP") {contactSlider();}
    if (switchType=="MAG") {contactSliderMagnets();}
  }
}//designPrintInsert

module designPrintTools() {

  tool_switchHolderInside();

  //OR
  /*
  difference() {
    tool_switchHolderOutside();
    contactSwitch();
  }
  */
}//designPrintTools


module base(){
  difference(){
    
    union(){
      //base shape
      color("skyblue") cyl(l=caseHeightZ, d=caseDiameterXY, fillet=3, center=false);
      //sidecar for jacks
      color("palegreen")  cuboid([(caseDiameterXY/2)+10,25,caseHeightZ], fillet=4, p1=[-(caseDiameterXY/4)-(10/2), (caseDiameterXY/2)-(25/2), 0]);
    }//union
    
    //hollow out base shape
    translate([0,0,wallThickness/2]) cyl(l=caseHeightZ-wallThickness, d=caseDiameterXY-wallThickness, fillet=3, center=false);
    //hollow out the sidecar
    cuboid([(caseDiameterXY/2)-wallThickness+10,25-wallThickness,caseHeightZ-wallThickness], fillet=4, p1=[-(caseDiameterXY/4)+(wallThickness/2)-(10/2), ((caseDiameterXY/2)-(25/2)+(wallThickness/2)), (wallThickness/2)]);
    
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
  
  color("orange") translate([-32.5, -switchWidthX/2, 1.5]) cube([switchDepthY, switchWidthX, switchHeightZ+3.5]); //-X
  color("orange") translate([+15.0, -switchWidthX/2, 1.5]) cube([switchDepthY, switchWidthX, switchHeightZ+3.5]); //+X
  color("orange") translate([-(switchWidthX/2), +15.0, 1.5]) cube([switchWidthX, switchDepthY, switchHeightZ+3.5]); //+Y
  color("orange") translate([-(switchWidthX/2), -32.5, 1.5]) cube([switchWidthX, switchDepthY, switchHeightZ+3.5]); //+Y

}//contactswitch


module contactSensor() {
     //CAP

  //Make cutouts in the contact ring for four Cap sensor boards. Resizing and adjustments will be necessary!
  
  cutoutWidthX = 10.8-2;
  cutoutDepthY = 1+5;
  cutoutHeightZ = 14.2; 
  shift = (fingerSize/2) + ((fingerSize*0.75)/2);
  
  color("orange") translate([-15.5, -cutoutWidthX/2, 7.5]) cube([cutoutDepthY, cutoutWidthX, cutoutHeightZ+3.5]); //-X
  color("orange") translate([+9.5, -cutoutWidthX/2, 7.5]) cube([cutoutDepthY, cutoutWidthX, cutoutHeightZ+3.5]); //+X
  color("orange") translate([-(cutoutWidthX/2), +9.5, 7.5]) cube([cutoutWidthX, cutoutDepthY, cutoutHeightZ+3.5]); //+Y
  color("orange") translate([-(cutoutWidthX/2), -15.5, 7.5]) cube([cutoutWidthX, cutoutDepthY, cutoutHeightZ+3.5]); //+Y

  //slots for boards
  color("orangered") translate([-11.5, -(cutoutWidthX+3.25)/2, 7.5]) cube([2, cutoutWidthX+3, cutoutHeightZ+3.5]); //-X
  color("orangered") translate([+9.50, -(cutoutWidthX+3.25)/2, 7.5]) cube([2, cutoutWidthX+3, cutoutHeightZ+3.5]); //+X
  color("orangered") translate([-((cutoutWidthX+3.25)/2), +9.50, 7.5]) cube([cutoutWidthX+3, 2, cutoutHeightZ+3.5]); //+Y
  color("orangered") translate([-((cutoutWidthX+3.25)/2), -11.5, 7.5]) cube([cutoutWidthX+3, 2, cutoutHeightZ+3.5]); //+Y
  
  
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


module jacks() {
  
    jackY = ((caseDiameterXY+wallThickness)/2)-(jackLength*0.40);
    jackZ = (caseHeightZ*0.65)-(wallThickness);

    //four switch joystick connection
    color("darkorange")
     translate([-17, jackY, jackZ]) 
      rotate([-90,0,0])
          cylinder(h=jackLength, d=jackDiameter); 
    color("darkorange")
     translate([+17, jackY, jackZ]) 
      rotate([-90,0,0])
          cylinder(h=jackLength, d=jackDiameter); 
    color("darkorange")
     translate([-5.75, jackY, jackZ]) 
      rotate([-90,0,0])
          cylinder(h=jackLength, d=jackDiameter); 
    color("darkorange")
     translate([+5.75, jackY, jackZ]) 
      rotate([-90,0,0])
          cylinder(h=jackLength, d=jackDiameter); 
}//jacks

module caseClosureStandoffs(){

  union() {
    color("gold")
     translate([-19.5, 17.5, 0])
      cylinder(h=caseHeightZ, d=4);
    color("gold")
     translate([+19.5, 17.5, 0])
      cylinder(h=caseHeightZ, d=4);
      color("gold")
     translate([-19.5,-17.25, 0])
      cylinder(h=caseHeightZ, d=4);
    color("gold")
     translate([+19.5,-17.25, 0])
      cylinder(h=caseHeightZ, d=4);
  }//union
 
}//caseClosureStandoffs


module caseClosureScrews(){
  //screw holes
  color("hotpink")
   translate([-19.50, 17.5, wallThickness+2])
    cylinder(h=caseHeightZ+overlap, d=mountingScrewDiameter);
  color("hotpink")
   translate([+19.50, 17.5, wallThickness+2])
    cylinder(h=caseHeightZ+overlap, d=mountingScrewDiameter);
  color("hotpink")
   translate([-19.50, -17.25, wallThickness+2])
    cylinder(h=caseHeightZ+overlap, d=mountingScrewDiameter);
  color("hotpink")
   translate([+19.50, -17.25, wallThickness+2])
    cylinder(h=caseHeightZ+overlap, d=mountingScrewDiameter);
  //countersinks
  color("pink")
   translate([-19.50, 17.5, caseHeightZ-(mountingScrewHeadHeight/2)])
    cylinder(h=mountingScrewHeadHeight+overlap, d=mountingScrewHeadDiameter);
  color("pink")
   translate([+19.50, 17.5, caseHeightZ-(mountingScrewHeadHeight/2)])
    cylinder(h=mountingScrewHeadHeight+overlap, d=mountingScrewHeadDiameter);
  color("pink")
   translate([-19.50, -17.5, caseHeightZ-(mountingScrewHeadHeight/2)])
    cylinder(h=mountingScrewHeadHeight+overlap, d=mountingScrewHeadDiameter);
  color("pink")
   translate([+19.50, -17.5, caseHeightZ-(mountingScrewHeadHeight/2)])
    cylinder(h=mountingScrewHeadHeight+overlap, d=mountingScrewHeadDiameter);
  
}//caseClosure


module fingerHole() {

    //center hole
  translate([0,0,caseHeightZ-wallThickness-overlap]) cylinder(h=wallThickness+(overlap*2), d=fingerSize+wallThickness, center=false);

  //four directional guides
  //I'm not happy with these, as they can lead to sharp edges. Instead, I'm expanding the size of the center hole
  //translate([-fingerSize*0.25, 0, caseHeightZ-wallThickness-overlap]) cylinder(h=wallThickness+(overlap*2), d=fingerSize*.75, center=false);
  //translate([+fingerSize*0.25, 0, caseHeightZ-wallThickness-overlap]) cylinder(h=wallThickness+(overlap*2), d=fingerSize*.75, center=false);
  //translate([0, -fingerSize*0.25, caseHeightZ-wallThickness-overlap]) cylinder(h=wallThickness+(overlap*2), d=fingerSize*.75, center=false);
  //translate([0, +fingerSize*0.25, caseHeightZ-wallThickness-overlap]) cylinder(h=wallThickness+(overlap*2), d=fingerSize*.75, center=false);

}//fingerHole


module tool_switchHolderOutside() {
  color("darkslategray") translate([0,0,caseHeightZ-caseLidHeight-5])  tube(h=3, id=64, wall=3);
}//tool_switchHolderOutside

module tool_switchHolderInside() {
  color("darkslategray") translate([0,0,wallThickness+5])  tube(h=3, od=42, wall=3);
}//tool_switchHolderInside


module slice(){
  
  splitAtZ=caseHeightZ-caseLidHeight;
  bigOverlap = overlap*30;
  
  //remove the top for split
  color("crimson")  translate([-((caseDiameterXY+bigOverlap)/2),-((caseDiameterXY+bigOverlap)/2),splitAtZ])  cube([caseDiameterXY+bigOverlap, caseDiameterXY+bigOverlap, caseHeightZ+bigOverlap]);
  // ******* OR ******
  //Remove everything but the top
  //color("crimson") translate([-((caseDiameterXY+bigOverlap)/2),-((caseDiameterXY+bigOverlap)/2),splitAtZ-caseHeightZ])  cube([caseDiameterXY+bigOverlap, caseDiameterXY+bigOverlap, caseHeightZ+overlap]);
  
}//slice