//toshiba air duct reducer

/* Measurements:
ring at end of toshiba provided ducting:
(measured from adapter ring to sqaure duct piece)
height: 13.40mm - 13?
outer diameter > 153mm.... caliper too small
diameter by ruler - 156ish so 155mm?

ring on louverd flap:

wall cutout:


*/

/* TODO
x- add cutout so cosmetic upper half of ring (for ducting receiver) can be slid on top after inserting ducting?
x- screw holes
- make upper half slide-in retaining ring

- MEASURE STUFFFFFF!!!!!
*/


draftingFNs = 36;
renderFNs = 180;
$fn = draftingFNs;


ductRingHeight = 13;
ductRingOuterDiameter = 155;
ductRingInnerDiameter = 150;
ductRingWidth = (ductRingOuterDiameter - ductRingInnerDiameter)/2;
ductRingCouplerWallThickness = 3;
clipVerticalGap = 1;

arbitraryDuctReceiverHeightPadding = 20;
arbitraryWallPlateThickness = 3;

//reducerHeight = 0; // 48.01m filament, 15h14m print time
//reducerHeight = 10; // 56.27m filament, 17h02m print time
reducerHeight = 30; // 71.58m filament, 19h20m print time
//reducerHeight = 100; // 123.23m filament, 28h16m print time
reducerWallThickness = 7;
reducerInsideWallHeight = 30;
reducerInsideWallThickness = 4;

ventRingOuterDiameter = 100; //TODO measure!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

wallPlateWidth = 180;
screwHoleDiameter = 3;
screwHoleInset = 10;


difference(){
    //outer body of accepting ring for duct
    cylinder(ductRingHeight*2,ductRingOuterDiameter/2 + ductRingCouplerWallThickness,ductRingOuterDiameter/2 + ductRingCouplerWallThickness);
//    //TODO shift everything up so bottom of reducer is fat and more supporting
//    cylinder(reducerHeight + ductRingHeight*2,ductRingOuterDiameter/2 + ductRingCouplerWallThickness,ductRingOuterDiameter/2 + ductRingCouplerWallThickness);
    
    //remove area for ring at end of ducting
    cylinder(ductRingHeight,ductRingOuterDiameter/2,ductRingOuterDiameter/2);
    
    //remove area down-duct from outer ring of ducting
    translate([0,0,ductRingHeight]){
        cylinder(ductRingHeight,ductRingInnerDiameter/2,ductRingInnerDiameter/2);
    }
    
    //remove top half of ring so duct can slid in
    translate([-(ductRingOuterDiameter/2 + ductRingCouplerWallThickness),0,0]){
        cube([ductRingOuterDiameter+ductRingCouplerWallThickness*2,ductRingOuterDiameter/2 + ductRingCouplerWallThickness,reducerHeight + ductRingHeight*2]);
    }
}


//add cubes to extend up receving ring (for ducting)
//+x side
translate([(ductRingOuterDiameter/2),0,0]){
    difference(){
        union(){
            //lower wall
            cube([ductRingCouplerWallThickness,arbitraryDuctReceiverHeightPadding,ductRingHeight]);
            
            //clip bump
            translate([0,arbitraryDuctReceiverHeightPadding-ductRingWidth,0]){
                cylinder(ductRingHeight,ductRingWidth,ductRingWidth);
            }
            
            //upper wall
            translate([-ductRingWidth,0,ductRingHeight]){
                cube([ductRingCouplerWallThickness+ductRingWidth,arbitraryDuctReceiverHeightPadding,ductRingHeight]);
            }
        }//end union
        
        //top clip gap
        translate([-ductRingWidth,0,ductRingHeight-clipVerticalGap]){
            cube([ductRingCouplerWallThickness+ductRingWidth,arbitraryDuctReceiverHeightPadding,clipVerticalGap]);
        }
        
        //bottom clip gap
        translate([-ductRingWidth,0,0]){
            cube([ductRingCouplerWallThickness+ductRingWidth,arbitraryDuctReceiverHeightPadding,clipVerticalGap]);
        }
    }//end diff
}

//-x side
translate([-(ductRingOuterDiameter/2) - ductRingCouplerWallThickness,0,0]){
    difference(){
        union(){
            //lower wall
            cube([ductRingCouplerWallThickness,arbitraryDuctReceiverHeightPadding,ductRingHeight]);
    
    //clip bump
    translate([ductRingWidth,arbitraryDuctReceiverHeightPadding-ductRingWidth,0]){
        cylinder(ductRingHeight,ductRingWidth,ductRingWidth);
    }
    
    //uppper wall
    translate([-0,0,ductRingHeight]){
        cube([ductRingCouplerWallThickness+ductRingWidth,arbitraryDuctReceiverHeightPadding,ductRingHeight]);
    }
        }//end union
        
        //top clip gap
        translate([0,0,ductRingHeight-clipVerticalGap]){
            cube([ductRingCouplerWallThickness+ductRingWidth,arbitraryDuctReceiverHeightPadding,clipVerticalGap]);
        }
        
        //bottom clip gap
        translate([0,0,0]){
            cube([ductRingCouplerWallThickness+ductRingWidth,arbitraryDuctReceiverHeightPadding,clipVerticalGap]);
        }
    }//end diff
}


//reducer cone
translate([0,0,-reducerHeight]){
    //reducer cone - outside wall
    difference(){
    //    cylinder(reducerHeight,ventRingOuterDiameter/2 + reducerWallThickness,ductRingOuterDiameter/2 + ductRingCouplerWallThickness);
        cylinder(reducerHeight,ductRingOuterDiameter/2 + ductRingCouplerWallThickness,ductRingOuterDiameter/2 + ductRingCouplerWallThickness);
        cylinder(reducerHeight,ventRingOuterDiameter/2,ductRingInnerDiameter/2);
        
    }
}

//wall plate
difference(){
    translate([-wallPlateWidth/2,-wallPlateWidth/2,-arbitraryWallPlateThickness-reducerHeight]){
        cube([wallPlateWidth,wallPlateWidth,arbitraryWallPlateThickness]);
    }

    translate([0,0,-arbitraryWallPlateThickness-reducerHeight]){
    //remove hole for venting
        //todo change to flap diameter
    cylinder(arbitraryWallPlateThickness,ventRingOuterDiameter/2,ventRingOuterDiameter/2);
    }
    
    translate([wallPlateWidth/2-screwHoleInset,wallPlateWidth/2-screwHoleInset,-arbitraryWallPlateThickness-reducerHeight]){
        cylinder(arbitraryWallPlateThickness,screwHoleDiameter/2,screwHoleDiameter/2);
    }
    
    translate([wallPlateWidth/2-screwHoleInset,-(wallPlateWidth/2-screwHoleInset),-arbitraryWallPlateThickness-reducerHeight]){
        cylinder(arbitraryWallPlateThickness,screwHoleDiameter/2,screwHoleDiameter/2);
    }
    
    translate([-(wallPlateWidth/2-screwHoleInset),-(wallPlateWidth/2-screwHoleInset),-arbitraryWallPlateThickness-reducerHeight]){
        cylinder(arbitraryWallPlateThickness,screwHoleDiameter/2,screwHoleDiameter/2);
    }
    
    translate([-(wallPlateWidth/2-screwHoleInset),wallPlateWidth/2-screwHoleInset,-arbitraryWallPlateThickness-reducerHeight]){
        cylinder(arbitraryWallPlateThickness,screwHoleDiameter/2,screwHoleDiameter/2);
    }
}

//cylinder to inside of wall to mate to the vent ring
translate([0,0,-(arbitraryWallPlateThickness+reducerHeight+reducerInsideWallHeight)]){
    difference(){
        //outer wall
        
        cylinder(reducerInsideWallHeight,ventRingOuterDiameter/2 + reducerInsideWallThickness,ventRingOuterDiameter/2 + reducerInsideWallThickness);
        cylinder(reducerInsideWallHeight,ventRingOuterDiameter/2,ventRingOuterDiameter/2);
    }
}