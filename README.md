# stickless
Stickless Joysticks -- These designs are mostly for digital switching, but I'm working on analog, too.

The Stickless_Joystick_Robust_Vxx.scad is the master file in OpenSCAD. Even if you don't use OpenSCAD, the code is human readable (at least, human programmer readable) and can be viewed in notepad.

******************************
Don't Rely On The STLs! Most of them are test renders I did. Often in-progress and incomplete! Re-render in OpenSCAD
******************************

*********************
IMPORTANT
*********************

Version 3x does NOT INCLUDE CASE SCREWS/CLOSURE. I'm still testing the base designs, and will add screws and countersinks in a later version.

Version 3x does NOT INCLUDE HOLES IN CASE FOR WIRES. Same deal as the case screws. I'll add access holes once I'm happy with the internals.

Version 3x has a number of hard-coded values for the switch and cap sensor locations. I will eventually be cleaning this up, but if your boards are different than mine, you'll need to tweak. Comments in code note this.


Depending on the setting in the code, I run, render, and output the various STLs. Changing settings is mostly done through constants or remarking/un-remarking routines.

Use these two select the type of stick-less stick you want:

//MIC = microswitch
//CAP = capacitive touch
//MAG = magnetic standoffs
switchType = "CAP"; //MIC, CAP, MAG

Unremark designFull if you want to see all objects (included subtracted objects) -- good for visualising and testing fit.
//designFull();

When ready to print, unremark designPrint. This handles all the Differences (subtractions) and only prints what's necessary.
// OR
designPrint();

For some versions of the joystick, there is a center insert to be printed. Unremark designPrintInsert to render the insert.
// OR
//designPrintInsert(); // only for MIC or MAG


if sliceDesign is true, then the model will be sliced for printing -- THIS IS REQUIRED FOR PRINTING
sliceDesign = true; // must be true to render & export the top & bottom for assembly

The module (subroutine) does the slice part. It's pretty simple right now. Just remark/unremark one line or the other. At the very bottom of the code.

module slice(){
  
   splitAtZ=caseHeightZ-caseLidHeight;
  
  //remove the top for split
  color("crimson")  translate([-((caseDiameterXY+overlap)/2),-((caseDiameterXY+overlap)/2),splitAtZ])  cube([caseDiameterXY+overlap, caseDiameterXY+overlap, caseHeightZ+overlap]);
  // ******* OR ******
  //Remove everything but the top
  //color("crimson") translate([-((caseDiameterXY+overlap)/2),-((caseDiameterXY+overlap)/2),splitAtZ-caseHeightZ])  cube([caseDiameterXY+overlap, caseDiameterXY+overlap, caseHeightZ+overlap]);
  
}//slice
