//case for mindfulness buzzer/feather
//contains disc buzzer, adafruit feather proto board, battery, & button
//clip on end cap, or not
// Justin Lowe, 20210324, jklideas.com

/*rough outline of what & why:
//make battery tray module, with clip for around top edge of PCB, pass as a variable the tolerance allotment in mm (0 for printing, >0.1 etc when using the object of the board to create a void in the actual model of the case/container)
//make seperate 'board etc void' module. use in difference statement. use battery clip module here as well to include in void
//figure out how to hold case together:
  // now using a end cap that slides in along the x axis, into the case in same direction that circuit board slides into case
  // original idea was to have an end wall (by the button) that slides down/up on Z axis into slots/receiver (so perpendicular to the direction that the board slides into the case
    //pcb slides in from that side (end of x axis of case), guide/holding rails on each side of case, top (far Y-axis) side rails only go from usb port along until JST connection, but full length/Y on bottom
    //battery tray can serve as top side rail after JST port
//way to hit reset button? paperclip for now, but ugh. captive button/cylinder with fingernail slot on outside of case? maybe.
    // maybe if bored then make a 'fingertip' module from rotate extrude for finger pad and linear extrude for nail, then convoluted thing for curved front of nail. 2mm depression depth to make void for that captive button.
*/

draftingFNs = 36;
renderFNs = 180;
$fn = renderFNs;

printTolerance = 0.2;

//NB: tried to make a lot of this variable based, but towards the end a lot of magic/undocumented numbers show up as I just wanted to have an actual physical thing done to use finally. 20210324jkl

trayHeight = 4; //TODO do we want to make edge that goes into slot thinner? Nope. good so far. is durability enough? more than needed?
trayY = 12;
trayX = 25;
trayBoardInsetY = 2;
trayBoardInsetZ = 2;
trayBoardInsetZOffset = 1;


trayBatterySupportFwdZOffset = 1.5;
//trayBatterySupportFwdZOffset = 0;
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
        cube([trayX + boardXAdd,trayY + trayTolerance*2,trayHeight + trayTolerance*2]);

        if (!modelVoid){    
            //remove void for edge of board
            translate([0,0,trayBoardInsetZOffset + trayTolerance]){
                cube([trayX,trayBoardInsetY,trayBoardInsetZ + trayTolerance]); //TODO check this, only doing one so tighter fit for board
            }  
            
            //remove slot for battery cables
            translate([trayBoardCableSlotXOffset,trayBoardCableSlotYOffset,0]){
                cube([trayBoardCableSlotX,trayBoardCableSlotY,trayHeight + trayTolerance*2]);
            }  
            
            //remove slot for orange cable on top & bottom (solder) of board
//            15 from x front, .9 bottom, 1.7 top
            translate([15,0,0]){
                cube([3,trayBoardInsetY,trayHeight + trayTolerance*2]);
            }  
            
        } // end if !modelvoid

    } //end difference
    
    if (modelVoid){ 
        //make void for wires under board. 3mm below tongue level, 5mm in from usb edge, 6mm in from far edge (this doesn't matter as material on this side is cut away for sliding in), 16 in from edge of tongue
        translate([5,-16,-3]){
            cube([trayX-5+boardXAdd,16+(trayY-3),4]);
        }
    }
    
    
    
    //battery Support forward part of tray (closer to USB port)
    translate([0,-(trayBatterySupportY-trayBatterySupportYOverlap),(trayBoardInsetZ+trayBoardInsetZOffset)]){
        difference(){
            //main part
            cube([trayBatterySupportFwdX + boardXAdd,trayBatterySupportY,trayBatterySupportZHeight]);

            if (!modelVoid){ 
                //subtract from under it to slide over components
                cube([trayBatterySupportFwdX,trayBatterySupportY-trayBatterySupportYOverlap,trayBatterySupportFwdZOffset]);
            }
        } //end difference
    } //end translate
    
    //battery Support rear part of tray (further from USB port)
    translate([trayBatterySupportFwdX,-(trayBatterySupportY-trayBatterySupportYOverlap),(trayBoardInsetZ+trayBoardInsetZOffset)]){
        difference(){
            //main part
            cube([trayBatterySupportRearX + boardXAdd,trayBatterySupportY,trayBatterySupportZHeight]);
            if (!modelVoid){
                //subtract from under it to slide over components
                cube([trayBatterySupportRearX,trayBatterySupportY-trayBatterySupportYOverlap,trayBatterySupportRearZOffset]);
                
                translate([1,0,0]){
//                    cube([trayBoardCableSlotX,trayBoardInsetY,2]);
                    cube([3,(trayBatterySupportY-trayBatterySupportYOverlap)+trayBoardInsetY,2]);
                }  
            } //end if !model void
        }  //end difference
        
        if (modelVoid){

            //make space for wires above board/tray tab. esp near button   
            translate([trayBatterySupportRearX-13,trayBatterySupportY,0]){
                cube([13 + boardXAdd,4,trayBatterySupportZHeight+trayBatteryHolderZ]);
            }
            //TODO create more space at button end of battery tray, more clearance for end of battery
        }
    } //end translate
    
     
    //holder for battery that sits on top of battery support XY plane
    translate([0,-(trayBatterySupportY-trayBatterySupportYOverlap),(trayBoardInsetZ+trayBoardInsetZOffset)+trayBatterySupportZHeight]){
        difference(){
            cube([trayX + boardXAdd,trayBatterySupportY,trayBatteryHolderZ]);
            
            if (!modelVoid){
                translate([-4,5,0]){
                    rotate([0,0,-60]){
                        cube([trayBatteryHolderX,trayBatteryHolderY+2,trayBatteryHolderZ]);
                    }
                }
            }
        } //end difference
        if (modelVoid){
            //TODO if model void then extend battery holder up some.
            //make room for end of battery, hanging over end of tray almost until edge of board - for almost full depth of case - really 6mm (measured at 5.1 or so) further in towards usb port than the edge of tray is now
            translate([-6,-6,0]){ //HARDCODED PAIN
//            cube([6+10,13,9]);
                cube([trayX + boardXAdd+6,18,trayBatteryHolderZ+1]);
            }
            
            //make room for battery tray and battery wires, towards fat tongue side of tray
            translate([0,-6+18,0]){ //HARDCODED PAIN
//            cube([6+10,13,9]);
                cube([trayX + boardXAdd,12,trayBatteryHolderZ+1]);
            }
        } //end if modelvoid
    }

    echo("Tray Y =",trayY + trayTolerance*2);
    echo("Tray Height =",trayHeight + trayTolerance*2);
    
}
//whitespace
//


//these are not measurements of the board, but the board + tolerances etc to make void
boardX = 51;
boardXVoid = boardX + 6;//need to add minkowski radius to get through backwall
boardY = 24;
boardZ = 2;

VariableToBeDiscHeight = 3;

//trayHeight = 4;

boardYOverflow = trayY - trayBoardInsetY;

//TODO remove boardTolerance and just bake it into the above?
module boardVoid(boardTolerance){
    //NB: All components must have a clear channel from end to final position so they can slide into case
    union(){
        
        //base board, no components
        cube([boardXVoid,boardY+boardTolerance*2,boardZ]);
        
        //USB port
        translate([0,boardY/2 - 8.8/2,boardZ]){
            cube([boardXVoid,8.8,3.5]);
        }
        
        //USB Cable area
        //from printed test object - move actual usb hole down 0.5 mm, move shroud hole down 0.5, make 1 bigger mm on bottom
        //metal port  
        translate([-2,boardY/2 - 8.8/2,boardZ-0.5]){
            cube([2,8.8,3.5]); //TODO make this trapezoidal
        }
        //USB cable shroud 
        translate([-2-29,boardY/2 - (11+2+2)/2,boardZ-3.5/2-1.5]){
            cube([30,11+2+2,9]); //TODO make this trapezoidal
        }
        
        //red & yellow LED
        translate([0,3.5,boardZ]){
            cube([boardXVoid,16,1.5]);
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
            cube([boardXVoid-6,4,2+0.5]); //3.6 measured with 1.7 board thickness
        }
        
        //hole for paperclip to hit reset button
        paperclipRadius = 0.6; //actual diam just under 1mm - measured by eye...
        translate([9,7,boardZ]){
//            cube([boardXVoid-6,4,2+0.5]); //3.6 measured with 1.7 board thickness
            cylinder(20,paperclipRadius,paperclipRadius);
        }
        
        
         //battery tray
        translate([15,boardY - trayBoardInsetY,-trayBoardInsetZOffset]){
            tray(true,printTolerance,40);
        }
        
        //water button (Button legs over side of board taken care of by battery tray slide slot)
        translate([42,boardY-10,boardZ]){
            cube([10,10,10+5]);
        }
        
        //components on lower Y-half of board's protoboard
        translate([30,3,boardZ]){
            cube([boardXVoid-30,9,5]); //3.6 measured with 1.7 board thickness
        }
        
        //components -Y to the board reset button
        translate([4,3,boardZ]){
            cube([boardXVoid-4,3,1.5]); //3.6 measured with 1.7 board thickness
        }
        
        //vibration motor on bottom of board
        translate([9,6,0-VariableToBeDiscHeight]){
            cube([boardXVoid-9,12,VariableToBeDiscHeight]);
        }
        //cables & protoboard solder on bottom of proto board
        translate([30,3,0-2]){
            cube([boardXVoid-30,boardY-3,2]);
        }
        
        
        
    }
}
//whitespace
//



//TODO is caseX right??
caseX = boardX+1; //+1 because button extends 1mm beyond edge of board //TODO TEST THIS
caseY = boardY + (trayY -trayBoardInsetY); //(23 + (12 - 2)
//caseY = 30;
//caseZ = 15; 
caseZ = VariableToBeDiscHeight + (trayHeight - trayBoardInsetZOffset) + trayBatterySupportZHeight + trayBatteryHolderZ; //(4 + 4 + 4)
caseMinkRad = 3;
//mink cube as base

echo("CaseZ= ", caseZ);

sliderX = 2;
module caseWallSlideCap(capTolerance){
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
    
    //TODO - for the slide-into-channel end cap: chop off some of right and left edges? or go all the way through case sides?
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
insertXoffset = 0.75;
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
                    cube([0.4,caseY,caseZ]);
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
            
            //void for button base overhanging the end of circuit board
            translate([0,12,5]){
                cube([3,14,5]);
            }
        } //end difference
    }
    

    
    //part that slides into case
    difference(){
        translate([-endcapInsetX,caseY-7.2,0.2]){
            cube([endcapInsetX,7,caseZ-0.4]);
        }
    
        //remove part for threaded heatset insert
        translate([-(insertDiameter/2+insertXoffset),caseY-7.2,caseZ/2]){
            rotate([-90,0,0]){
                cylinder(7,insertDiameter/2,insertDiameter/2);
            }
        }
    } //end difference
    
    //removed because circuit board goes to end of case (i think it does go to end of case?)
//    //-Y side of inset, full height
//    translate([-1.5,0,0]){
//        cube([1.5,10,caseZ]);
//    }
    
    //-y side of inset, under board
    translate([-5,0.2,0.2]){
        cube([5,5,3]);
    }
    
    //-y side of inset, above board
    translate([-endcapInsetX,0.2,caseZ-5.2]){
        cube([endcapInsetX,8,5]);
    }
       
}
//whitespace
//


endcapInsetXTolerance = 1; //extra slack space

module case(endcapType){
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
        
        if (endcapType == "wallSlide") { //make a wall that slides into a receiving channel - up and down on z axis
            //TODO use caseWallSlideCap module to make void here IFF using wall-slide end cap
            
            
            
        } else if (endcapType == "slideIn") { //remove material for slide in (to case) endcap
        
            //remove outer edges for end cap
            translate([caseX,-caseMinkRad,-caseMinkRad]){
                cube([caseMinkRad,caseY+caseMinkRad*2,caseZ+caseMinkRad*2]);
            }
            
            //remove material for end capo to slide in
            translate([caseX-endcapInsetX-endcapInsetXTolerance,0,0]){
                cube([endcapInsetX+endcapInsetXTolerance,caseY,caseZ]);
            }
            
            
            
            
            
        screwHoleDiameter = 3.5;//m3 = 3mm diam, 2.93mm actual
        screwHeadVerticalInset = 0.5;
        screwHeadHeight = 2;
        screwHeadDiameterOuter = 5.75; //5.37mm actual
        screwHeadDiameterInner = screwHoleDiameter;
            
            
            
            //remove for screw shaft    
            translate([caseX-insertXoffset-insertDiameter/2,caseY-caseMinkRad,caseZ/2]){ //move to end of case, then back the offset, then half the diameter of insert, 
                rotate([-90,0,0]){
                    color("Green")
                    cylinder(caseMinkRad*2, screwHoleDiameter/2, screwHoleDiameter/2);
                }
            }  

            
            //remove void for screw head
//            translate([gutterRadius+islandRadius-4-voidInsertRadius-3+3.8,0,screwHeadVerticalInset]){
            translate([caseX-insertXoffset-insertDiameter/2,caseY+caseMinkRad-screwHeadVerticalInset,caseZ/2]){
                rotate([90,0,0]){
                color("Green")
                cylinder(screwHeadHeight, screwHeadDiameterOuter/2, screwHeadDiameterInner/2);
                }
            }
 
            //remove void for screw head inset
            translate([caseX-insertXoffset-insertDiameter/2,caseY+caseMinkRad,caseZ/2]){
                rotate([90,0,0]){
                    color("Green")
                    cylinder(screwHeadVerticalInset, (screwHeadDiameterOuter/2)*1.2, screwHeadDiameterOuter/2);
                }
            }
        
//            //remove void for screw head inset
//            translate([caseX-insertXoffset-insertDiameter/2,caseY+caseMinkRad,caseZ/2]){
//                color("Green")
//                cylinder(screwHeadVerticalInset, (screwHeadDiameterOuter/2)*1.2, screwHeadDiameterOuter/2);
//            }

        }
    } //end difference
}




            





//
// FOR REFERENCE / FOR REFERENCE / FOR REFERENCE
//
//this will model actual piece you want to print: tray(false,0,0);
//this will model the void you want inside another object: tray(true,printTolerance,40); //or just a number long enough to make void go out back of case

//tray(false,0,0);
//tray(true,printTolerance,40);

//boardVoid(0);

case("slideIn");

//caseWallSlideCap();

//caseSlideInEndcap(false);

//         //battery tray
//        translate([15,boardY - trayBoardInsetY,-trayBoardInsetZOffset + 30]){
//            tray(true,printTolerance,40);
//        }
