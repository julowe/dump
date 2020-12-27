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


caseX = 55;
caseY = 30;
caseZ = 15; 
caseMinkRad = 3;
//mink cube as base

module case(){
minkowski(){
    cube([caseX,caseY,caseZ]);
    sphere(caseMinkRad);
}
}


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
module tray(trayTolerance){ 
    //printer tolerance only needed for top edge of battery holder, top & bottom edge of slot, y edge of part that goes into case receiving slot
    //also move slot for board up by 1 trayTolerance amount, so board is centered vertically between the Z tolerances
    difference(){
        //the part of the tray that goes around edge of board and into slot in case
        cube([trayX,trayY + trayTolerance,trayHeight + trayTolerance*2]);
        
        //remove void for edge of board
        translate([0,0,trayBoardInsetZOffset + trayTolerance]){
            cube([trayX,trayBoardInsetY,trayBoardInsetZ + trayTolerance]); //TODO check this, only doing one so tighter fit for board
        }  
        
        //remove slot for battery cables
        translate([trayBoardCableSlotXOffset,trayBoardCableSlotYOffset,0]){
            cube([trayBoardCableSlotX,trayBoardCableSlotY,trayHeight + trayTolerance*2]);
        }  
    }
    
    //battery Support forward part of tray (closer to USB port)
    translate([0,-(trayBatterySupportY-trayBatterySupportYOverlap),trayHeight]){
        difference(){
        //main part
            cube([trayBatterySupportFwdX,trayBatterySupportY,trayBatterySupportZHeight]);

        //subtract from under it to slide over components
            cube([trayBatterySupportFwdX,trayBatterySupportY-trayBatterySupportYOverlap,trayBatterySupportFwdZOffset]);
        }  
    }
    
    //battery Support rear part of tray (further from USB port)
    translate([trayBatterySupportFwdX,-(trayBatterySupportY-trayBatterySupportYOverlap),trayHeight]){
        difference(){
        //main part
            cube([trayBatterySupportRearX,trayBatterySupportY,trayBatterySupportZHeight]);

        //subtract from under it to slide over components
            cube([trayBatterySupportRearX,trayBatterySupportY-trayBatterySupportYOverlap,trayBatterySupportRearZOffset]);
        }  
    }
    
    //holder for battery that sits on top of battery support XY plane
    translate([0,-(trayBatterySupportY-trayBatterySupportYOverlap),trayHeight+trayBatterySupportZHeight]){
        difference(){
            cube([trayX,trayBatterySupportY,trayBatteryHolderZ]);
            translate([0,0,0]){
                rotate([0,0,-45]){ //TODO hmm -45 is prob just about right. for exactness, battery void should be moved down a bit Y (bc battery hangs over this tray) and back some X, but I think that would get us to roughly the same spot actually
                    cube([trayBatteryHolderX,trayBatteryHolderY,trayBatteryHolderZ]);
                }
            }
        }
    }
    
    
    
}

tray(0.0);