//toshiba air duct reducer

/* Measurements:
ring at end of toshiba provided ducting:
(measured from adapter ring to sqaure duct piece)
height: 13.40mm - 13?
outer diameter > 153mm.... caliper too small
diameter by ruler - 156ish so 155mm?
closer diameter by ruler - outer 154. maybe 155 or 153.. ugh test print fit

ring on louverd flap:

wall cutout:


*/

/* TODO
- add cutout so cosmetic upper half of ring (for ducting receiver) can be slid on top after inserting ducting?
- screw holes

*/

//30.58m filament, 6h44m print time

ductRingHeight = 13;
ductRingOuterDiameter = 154;
ductRingInnerDiameter = 140;
ductRingWidth = (ductRingOuterDiameter - ductRingInnerDiameter)/2;
ductRingCouplerWallThickness = 3;
clipVerticalGap = 1;

arbitraryDuctReceiverHeightPadding = 20;
arbitraryWallPlateThickness = 3;

ventRingOuterDiameter = 100; //TODO measure!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! thi sis the hole in the wall p.ate

wallPlateWidth = 180;
screwHoleDiameter = 3;
screwHoleInset = 10;

difference(){
    //outer body of accepting ring for duct
    cylinder(ductRingHeight*2,ductRingOuterDiameter/2 + ductRingCouplerWallThickness,ductRingOuterDiameter/2 + ductRingCouplerWallThickness);
    
    //remove area for ring at end of ducting
    cylinder(ductRingHeight,ductRingOuterDiameter/2,ductRingOuterDiameter/2);
    
    //remove area down-duct from outer ring of ducting
    translate([0,0,ductRingHeight]){
        cylinder(ductRingHeight,ductRingInnerDiameter/2,ductRingInnerDiameter/2);
    }
    
    //remove top half of ring so duct can slid in
    translate([-(ductRingOuterDiameter/2 + ductRingCouplerWallThickness),0,0]){
        cube([ductRingOuterDiameter+ductRingCouplerWallThickness*2,ductRingOuterDiameter/2 + ductRingCouplerWallThickness,ductRingHeight*2]);
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


////add cubes to extend up receving ring (for ducting)
////+x side
//translate([(ductRingOuterDiameter/2),0,0]){
//cube([ductRingCouplerWallThickness,arbitraryDuctReceiverHeightPadding,ductRingHeight]);
//    
//    translate([-ductRingWidth,0,ductRingHeight]){
//        cube([ductRingCouplerWallThickness+ductRingWidth,arbitraryDuctReceiverHeightPadding,ductRingHeight]);
//    }
//}
//
////-x side
//translate([-(ductRingOuterDiameter/2) - ductRingCouplerWallThickness,0,0]){
//cube([ductRingCouplerWallThickness,arbitraryDuctReceiverHeightPadding,ductRingHeight]);
//    
//    translate([-0,0,ductRingHeight]){
//        cube([ductRingCouplerWallThickness+ductRingWidth,arbitraryDuctReceiverHeightPadding,ductRingHeight]);
//    }
//}


//wall plate
difference(){
    translate([-wallPlateWidth/2,-wallPlateWidth/2,-arbitraryWallPlateThickness]){
        cube([wallPlateWidth,wallPlateWidth,arbitraryWallPlateThickness]);
    }

    translate([0,0,-arbitraryWallPlateThickness]){
    //remove hole for venting
        //todo change to flap diameter
    cylinder(arbitraryWallPlateThickness,ventRingOuterDiameter/2,ventRingOuterDiameter/2);
    }
    
    translate([wallPlateWidth/2-screwHoleInset,wallPlateWidth/2-screwHoleInset,-arbitraryWallPlateThickness]){
        cylinder(arbitraryWallPlateThickness,screwHoleDiameter/2,screwHoleDiameter/2);
    }
    
    translate([wallPlateWidth/2-screwHoleInset,-(wallPlateWidth/2-screwHoleInset),-arbitraryWallPlateThickness]){
        cylinder(arbitraryWallPlateThickness,screwHoleDiameter/2,screwHoleDiameter/2);
    }
    
    translate([-(wallPlateWidth/2-screwHoleInset),-(wallPlateWidth/2-screwHoleInset),-arbitraryWallPlateThickness]){
        cylinder(arbitraryWallPlateThickness,screwHoleDiameter/2,screwHoleDiameter/2);
    }
    
    translate([-(wallPlateWidth/2-screwHoleInset),wallPlateWidth/2-screwHoleInset,-arbitraryWallPlateThickness]){
        cylinder(arbitraryWallPlateThickness,screwHoleDiameter/2,screwHoleDiameter/2);
    }
}


////wall plate
//difference(){
//    translate([-wallPlateWidth/2,-wallPlateWidth/2,-arbitraryWallPlateThickness]){
//        cube([wallPlateWidth,wallPlateWidth,arbitraryWallPlateThickness]);
//    }
//
//    translate([0,0,-arbitraryWallPlateThickness]){
//    //remove hole for venting
//        //todo change to flap diameter
//    cylinder(arbitraryWallPlateThickness,ductRingInnerDiameter/2,ductRingInnerDiameter/2);
//    }
//}