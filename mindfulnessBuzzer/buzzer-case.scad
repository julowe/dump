//case for mindfulness buzzer/feather
//contains disc buzzer, feather, battery, & button
//clip on back? unknown.

//TODO
//make battery tray module, with clip for around top edge of PCB, pass tolerance allotment (0 for printing, >0.1 etc for voiding use)
//make seperate 'board etc void' module. use in difference statement. use battery clip module here as well to include in void
//figure out how to hold case together - end wall by button that slides up on Z axis into slots/receiver?
    //pcb slides in from that side, rails on each side, top side only until JST connection, full length/Y on bottom
    //battery tray can serve as top side rail
//way to hit reset button. paperclip? ugh. captive button/cylinder with fingernail slot on outside of case? maybe.
    //make finger module from rotate extrude for finger pad and linear extrude for nail, then convoluted thing for curved front of nail. 2mm depression depth


draftingFNs = 36;
renderFNs = 180;
$fn = draftingFNs;

printTolerance = 0.2;





trayHeight = 4; //TODO do we want to make edge that goes into slot thinner?
trayY = 12;
trayX = 25;
trayBoardInsetY = 2;
trayBoardInsetZ = 2;
trayBoardInsetZOffset = 1;


trayBatterySupportFwdZOffset = 1.5;
trayBatterySupportRearZOffset = 3.5;
trayBatterySupportFwdX = 14;
trayBatterySupportRearX = trayX - trayBatterySupportFwdX;
trayBatterySupportZHeight = 4;
trayBatterySupportY = 20;
trayBatterySupportYOverlap = 5; //or set as (trayY-trayBoardInsetY)/2 ?
trayBatteryHolderZ = 4;
//X & Y & Z are somehwat arbitraty here, so called X the small side, Y the long side, Z the smallest/shortest side
trayBatteryHolderX = 11;
trayBatteryHolderY = 35; //with cables


trayBoardCableSlotX = 6;
trayBoardCableSlotXOffset = 10;
trayBoardCableSlotY = trayY - trayBatterySupportYOverlap;
trayBoardCableSlotYOffset = trayBatterySupportYOverlap;


//use 0 tolerance to create actual piece, use non-zero tolerance when using this module to difference from the receiving piece
//meh good idea but complicated to just use this in creating void in case - use output numbers/lolgic to create void in right shape
///meh ok how about some true/false and X extensions
module tray(modelVoid,trayTolerance,boardXAdd){ 
    //printer tolerance only needed for top edge of battery holder, top & bottom edge of slot, y edge of part that goes into case receiving slot
    //also move slot for board up by 1 trayTolerance amount, so board is centered vertically between the Z tolerances
    difference(){
        //the part of the tray that goes around edge of board and into slot in case
        cube([trayX + boardXAdd,trayY + trayTolerance,trayHeight + trayTolerance*2]);

        if (!modelVoid){    
            //remove void for edge of board
            translate([0,0,trayBoardInsetZOffset + trayTolerance]){
                cube([trayX,trayBoardInsetY,trayBoardInsetZ + trayTolerance]); //TODO check this, only doing one so tighter fit for board
            }  
            
            //remove slot for battery cables
            translate([trayBoardCableSlotXOffset,trayBoardCableSlotYOffset,0]){
                cube([trayBoardCableSlotX,trayBoardCableSlotY,trayHeight + trayTolerance*2]);
            }  
            
            //TODO remove slot for orange cable on top of board
        }

    }
    
    //battery Support forward part of tray (closer to USB port)
    translate([0,-(trayBatterySupportY-trayBatterySupportYOverlap),trayHeight]){
        difference(){
            //main part
            cube([trayBatterySupportFwdX + boardXAdd,trayBatterySupportY,trayBatterySupportZHeight]);

            if (!modelVoid){ 
                //subtract from under it to slide over components
                //TODO Fix under voids
                cube([trayBatterySupportFwdX,trayBatterySupportY-trayBatterySupportYOverlap,trayBatterySupportFwdZOffset]);
            }
        }
    }
    
    //battery Support rear part of tray (further from USB port)
    translate([trayBatterySupportFwdX,-(trayBatterySupportY-trayBatterySupportYOverlap),trayHeight]){
        difference(){
            //main part
            cube([trayBatterySupportRearX + boardXAdd,trayBatterySupportY,trayBatterySupportZHeight]);
            if (!modelVoid){ 
                //subtract from under it to slide over components
                //TODO Fix under voids
                cube([trayBatterySupportRearX,trayBatterySupportY-trayBatterySupportYOverlap,trayBatterySupportRearZOffset]);
            }
        }  
    }
    
     
    //holder for battery that sits on top of battery support XY plane
    translate([0,-(trayBatterySupportY-trayBatterySupportYOverlap),trayHeight+trayBatterySupportZHeight]){
        difference(){
            cube([trayX + boardXAdd,trayBatterySupportY,trayBatteryHolderZ]);
            
            if (!modelVoid){
                translate([0,0,0]){
                    rotate([0,0,-45]){ //TODO hmm -45 is prob just about right. 
                        //NOPE for exactness, battery void should be moved down a bit Y (bc battery hangs over this tray) and back some X, but I think that would get us to roughly the same spot actually
                        //TODO move battery up Y a bit. maybe change angle
                        cube([trayBatteryHolderX,trayBatteryHolderY,trayBatteryHolderZ]);
                    }
                }
            }
        }
    }
    
            echo("Tray Y =",trayY + trayTolerance);
        echo("Tray Height =",trayHeight + trayTolerance*2);
    
}
//whitespace
//


//these are not measuremnts of the board, but the board + tolerances etc to make void
boardX = 51;
boardXVoid = boardX + 6;//need to add minkowski radius to get through backwall
boardY = 23;
boardZ = 2;

//trayHeight = 4; //TODO do we want to make edge that goes into slot thinner?

boardYOverflow = trayY - trayBoardInsetY;

//TODO remove boardTolerance and just bake it into the above?
module boardVoid(boardTolerance){
    //NB: All components must have a clear channel from end to final position so they can slide into case
    union(){
        //base board, no components
        cube([boardXVoid,boardY,boardZ]);
        
        //USB port
        translate([0,boardY/2 - 8/2,boardZ]){
            cube([boardXVoid,8,3.5]);
        }
        
        //USB Cable area
        //metal port  
        translate([-2,boardY/2 - 8/2,boardZ]){
            cube([2,8,3.5]); //TODO make this trapezoidal
        }
        //cable shroud 
        translate([-2-30,boardY/2 - (11+2+2)/2,boardZ-3.5/2]){
            cube([30,11+2+2,8]); //TODO make this trapezoidal
        }
        
        //red & yellow LED
        translate([0,4,boardZ]){
            cube([boardXVoid,14,1.5]);
        }
        
         //JST Port
        translate([7,boardY - 8,boardZ]){
            cube([boardXVoid-7,8,6]);
        }
        
         //JST cable
        translate([7,boardY,boardZ]){
            cube([boardXVoid-7,7,5.5]);
        }
        
        
        //board reset button
        translate([6,4,boardZ]){
            cube([boardXVoid,4,2+0.5]); //3.6 measured with 1.7 board thickness
        }
        
         //battery tray
        translate([15,boardY - trayBoardInsetY,-trayBoardInsetZOffset]){
            tray(true,printTolerance,40);
        }
        
        //TODO battery sticking out... hmm crap maybe do in tray void??
        
        //TODO water button (Button legs over side of board taken care of by battery tray slide slot)
        translate([42,boardY-10,boardZ]){
            cube([10,10,10+5]);
        }
        
        //TODO components on lower Y-half of board, esp protoboard. also near reset button??
        
        //TODO vibration motor and cables & protoboard solder on bottom
        
        
        
    }
}
//whitespace
//



//TODO is caseX right??
caseX = boardX+1; //+1 because button extends 1mm beyond edge of board //TODO TEST THIS
caseY = boardY + (trayY -trayBoardInsetY); //(23 + (12 - 2)
//caseY = 30;
//caseZ = 15; 
VariableToBeDiscHeight = 3;
caseZ = VariableToBeDiscHeight + (trayHeight - trayBoardInsetZOffset) + trayBatterySupportZHeight + trayBatteryHolderZ; //(4 + 4 + 4)
caseMinkRad = 3;
//mink cube as base


sliderX = 2;
module caseSlidingCap(capTolerance){
    //part that goes into channel
    union(){
        //bottom
        translate([0,0,-caseMinkRad]){
            cube([sliderX,caseY,caseZ]); //TODO: have Z here be an additional caseMinkRad/2 or just 0? butt up against case, it slide into top part?
        }
        
        //sides
        translate([0,-caseMinkRad,0]){
            cube([sliderX,caseY + caseMinkRad + caseMinkRad,caseZ ]);
        }
        
        rotate([90,0,90]){
            cylinder(sliderX,caseMinkRad,caseMinkRad);
        }    
    
        translate([0,caseY,0]){    
            rotate([90,0,90]){
                cylinder(sliderX,caseMinkRad,caseMinkRad);
            }
        }
    } //end union
    
    //TODO - chop off some of right and left edges? or go all the way through case sides?
    //i'm leaning towards chopping off a mm from each side - yeah bc otherwise there is a whole column of material on each side that can pull off easily (between the two cylinders of side and back)
    //part that forms end cap
    translate([sliderX,0,0]){
        cube([caseMinkRad,caseY,caseZ]);
        difference(){
            rotate([-90,0,0]){
                cylinder(caseY,caseMinkRad,caseMinkRad);
            }
            
            //bottom
            translate([-caseMinkRad,0,-caseMinkRad]){
                cube([caseMinkRad,caseY,caseZ]);
            }
        }
    }
       
}
//whitespace
//

endcapInsetX = 7; //this should give room for a heat set insert
insertDiameter = 5.3;
clipZ = 2;
clipZGap = 2;
clipY = 10;
clipX = 35;

//TODO - test clip. likely too flimsy...

module caseSlideInEndcap(clip){ 
    //make outer edges/end
    translate([-0.2,0,0]){
        difference(){
            minkowski(){
                union(){
                    cube([0.2,caseY,caseZ]);
                    if(clip){
                        translate([-clipX,caseY/2-clipY/2,-(clipZ+clipZGap)]){
                            cube([clipX+0.2,clipY,clipZ+clipZGap]);
                        }
                    }
                }
                sphere(caseMinkRad);
            }
            translate([-clipX-caseMinkRad,-caseMinkRad,-caseMinkRad-clipZGap]){
                cube([clipX+0.2+caseMinkRad,caseY+caseMinkRad*2,caseZ+caseMinkRad*2+clipZGap]);
            }
        }
    }
    
    //part that slides into case
    difference(){
        translate([-endcapInsetX,0,0]){
            cube([endcapInsetX,caseY,caseZ]);
        }
    
        translate([-(insertDiameter/2+0.5),caseY-7,caseZ/2]){
            rotate([-90,0,0]){
                cylinder(7,insertDiameter/2,insertDiameter/2);
            }
        }
    }
}
//whitespace
//


endcapInsetXTolerance = 1; //extra slack space

module case(){
    difference(){
        minkowski(){
            cube([caseX,caseY,caseZ]);
            sphere(caseMinkRad);
        }
        
        //TODO
        //is Y position good with minkowski raidus being distance between board edge and outside wall (on negative Y side) 
        //what is wanted Z position - want it to be just mink radius off bottom of case?
        translate([0,0,VariableToBeDiscHeight]){
            boardVoid(0);
        }
        
        //TODO use slider module to make void here
        
        //remove material for slide in endcap
        
        //remove outer edges for end cap
        translate([caseX,-caseMinkRad,-caseMinkRad]){
            cube([caseMinkRad,caseY+caseMinkRad*2,caseZ+caseMinkRad*2]);
        }
        
        //remove material for end capo to slide in
        translate([caseX-endcapInsetX-endcapInsetXTolerance,0,0]){
            cube([endcapInsetX+endcapInsetXTolerance,caseY,caseZ]);
        }
        
        //todo
        //make hole for screw
        //make inset for screw head
    } //end difference
}



//
// FOR REFERENCE / FOR REFERENCE / FOR REFERENCE
//
//this will model actual piece you want to print: tray(false,0,0);
//this will model the void you want inside another object: tray(true,printTolerance,40); //or just a number long enough to make void go out back of case

//tray(false,0,0);


//boardVoid(0);

case();

//caseSlidingCap();

//caseSlideInEndcap(false);

//         //battery tray
//        translate([15,boardY - trayBoardInsetY,-trayBoardInsetZOffset + 30]){
//            tray(true,printTolerance,40);
//        }
