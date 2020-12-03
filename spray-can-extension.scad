//broomstick holder for can foam

//options:
//friction clip to broom stick - exist or not & diameter of stick
    //make sure ot include enough space to snap clip onto broomstick and then screw holder down onto stick
    //maybe don't include option to not have broom stick clips. prob need for hoizontal stability and so threaded tube doesn't crack along layer lines with any sideways force...
//threading diameter/pitch
//diameter of can
//height of can

//TODO 
//use screw library for threading to attach to broomstick?
//design actuation
//iterate on clip holder to hold base steady to broomstick, what angle is good for clip on and tigh hold?
//use clip to hold line/pullstring to actuate spray can
//check thickness of backbone - thicker needed to hold all together?
//design cable run for actuation line
//oh prob some actuation holder to put on can itself? or attach to top of this contraption?

//TODO take actual measurements!

draftFNs = 36;
renderFNs = 180;
$fn = draftFNs;

canDiameter = 100;

canHolderWallThickness = 3;
canHolderWallHeight = 10; //TODO rethink height and seperation. add third ring?? nah prob not.
canHolderVerticalSeperation = 40;
canHolderPlatformHeight = 3;

holderBackboneDepth = canHolderWallThickness; //could make bigger?
holderBackboneWidth = 20;
holderBackboneHeight = 40 + canHolderVerticalSeperation+canHolderWallHeight+canHolderPlatformHeight;

broomThreadHeight = 15;
broomThreadDiameter = 8;
broomThreadEndcapHeight = 3;
broomThreadBaseHeight = 20;
broomThreadBaseDiameter = 20;
broomThreadBaseWallThickness = 3;

broomHandleDiameter = 12;
broomHandleClipWallThickness = 3;
broomHandleClipWallHeight = 10;
broomHandleClipVerticalOffset = 50;
broomHandleClipAngularCoverage = 240;


//upper tube to hold spray can
translate([0,0,canHolderVerticalSeperation+canHolderWallHeight+canHolderPlatformHeight]){
    difference(){
        cylinder(canHolderWallHeight, canDiameter/2+canHolderWallThickness, canDiameter/2+canHolderWallThickness);
        
        cylinder(canHolderWallHeight, canDiameter/2, canDiameter/2);
    }
}

//lower platform & tube to hold spray can
difference(){
    cylinder(canHolderWallHeight+canHolderPlatformHeight, canDiameter/2+canHolderWallThickness, canDiameter/2+canHolderWallThickness);
    translate([0,0,canHolderPlatformHeight]){     
        cylinder(canHolderWallHeight, canDiameter/2, canDiameter/2);
    }
}

//main backbone connecting all various holders
translate([canDiameter/2,-holderBackboneWidth/2,0]){
    cube([holderBackboneDepth, holderBackboneWidth, holderBackboneHeight]);
}


//bottom broom handle clip
translate([canDiameter/2+broomHandleDiameter/2+broomHandleClipWallThickness,0,0]){
    rotate([0,0,(360-broomHandleClipAngularCoverage)/2]){
        rotate_extrude(angle = broomHandleClipAngularCoverage){
            translate([broomHandleDiameter/2,0,0]){
                square([broomHandleClipWallThickness,broomHandleClipWallHeight]);
            }
        }
    }
}

//TODO make holder taller to have two clips? probably
////top broom handle clip
//translate([canDiameter/2+broomHandleDiameter/2+broomHandleClipWallThickness,0,broomHandleClipVerticalOffset]){
//    rotate([0,0,(360-broomHandleClipAngularCoverage)/2]){
//        rotate_extrude(angle = broomHandleClipAngularCoverage){
//            translate([broomHandleDiameter/2,0,0]){
//                square([broomHandleClipWallThickness,broomHandleClipWallHeight]);
//            }
//        }
//    }
//}



//top (threaded) tube to attach all this to broom thread
translate([canDiameter/2+broomThreadBaseDiameter/2+broomThreadBaseWallThickness,0,holderBackboneHeight-broomThreadHeight]){
    difference(){
        cylinder(broomThreadHeight+broomThreadEndcapHeight, broomThreadBaseDiameter/2+broomThreadBaseWallThickness, broomThreadBaseDiameter/2+broomThreadBaseWallThickness);
        
        cylinder(broomThreadHeight, broomThreadDiameter/2, broomThreadDiameter/2);
    }
}

//lower (non-threaded) tube to attach all this to broom thread
translate([canDiameter/2+broomThreadBaseDiameter/2+broomThreadBaseWallThickness,0,holderBackboneHeight-broomThreadHeight-broomThreadBaseHeight]){
    difference(){
        cylinder(broomThreadBaseHeight, broomThreadBaseDiameter/2+broomThreadBaseWallThickness, broomThreadBaseDiameter/2+broomThreadBaseWallThickness);
        
        cylinder(broomThreadBaseHeight, broomThreadBaseDiameter/2, broomThreadBaseDiameter/2);
    }
}

