//broomstick holder for can foam

//options:
//friction clip to broom stick - exist or not & diameter of stick
    //make sure ot include enough space to snap clip onto broomstick and then screw holder down onto stick
    //maybe don't include option to not have broom stick clips. prob need for hoizontal stability and so threaded tube doesn't crack along layer lines with any sideways force...
//threading diameter/pitch
//diameter of can
//height of can

//TODO 
//design actuation
//check thickness of backbone - thicker needed to hold all together?
//TODO oh prob some actuation holder to put on can itself? or attach to top of this contraption?


//
/*broomstick measurements
Broom stick
23.8mm shaft diameter
34mm large yellow nut/bolt diameter
60 height nut bolt
97 total yellow height
24 threaded bolt height
21.5 non threaded diameter
19 bolt diameter w threads
16 inner bolt diameter
5mm pitch
2nm thread height
4 turns per inch
*/
//


draftFNs = 36;
renderFNs = 180;
$fn = renderFNs;

canDiameter = 69;
canTopDimpleDiameter = 53;
canTopStrawSlotWidth = 15;

canHolderWallThickness = 5;
canHolderWallHeight = 20; //TODO rethink height and seperation. add third ring?? nah prob not.
canHolderVerticalSeperation = 100;
canHolderPlatformHeight = 5;


holderBackboneDepth = canHolderWallThickness; //could make bigger?
holderBackboneWidth = 20;
holderBackboneHeight = 40 + canHolderVerticalSeperation+canHolderWallHeight+canHolderPlatformHeight;
//todo-maybe: chamfer cylinder to backbone by creating cylinder taller and then orthogonal cylinder to subtract

broomThreadHeight = 24;
broomThreadDiameter = 19;
broomThreadEndcapHeight = 0;//3;
broomThreadBaseHeight = 97-24-10;
broomThreadBaseDiameter = 36;
broomThreadBaseWallThickness = 5;

broomHandleDiameter = 23.5;
broomHandleClipWallThickness = 3;
broomHandleClipWallHeight = 10;
broomHandleClipVerticalOffset = 50; //distance between two clips... and 2nd one isn't made anymore
broomHandleClipAngularCoverage = 240;

lineDiameter = 4.5;
lineDiameterSquished = 2.5;
lineClipWallThickness = 2;


//------------------------------------------------------------------------------------------------

// Metric Screw Thread Library
// by Maximilian Karl <karlma@in.tum.de> (2014)
// modified the api to create internal threads, smooth the start and
// stop threads, and use imperial units: 
//
// 
//
// use module thread_imperial(pitch, majorD, stepAngle, numRotations, tol, internal) 
//         or thread(pitch, majorD, stepAngle, numRotations, tol, internal)
// with the parameters:
// pitch        - screw thread pitch
// majorD       - screw thread major diameter
// step         - step size in degrees (36 gives ten steps per rotation)
// numRotations - the number of full rotations of the thread
// tol          - (optional parameter for internal threads) the amount to increase the 
//                 thread size in mm.Default is 0
// internal     - (optional parameter for internal threads) - this can be set true or  
//                false.  Default is true

root3 = sqrt(3);
root3div3 = root3/3;

//Creates a thread cross section starting with an equilateral triangle
//and removing the point.  Internal threads (for creating nuts) will 
//have a non-zero tolerance value which enlarges the triangle to
//accomodate a bolt of the same size
module screwthread_triangle(P, tol) {
    cylinderRadius=root3div3*(P+2*tol);
    translate([2*tol,0,0]){
        difference() {
            translate([-cylinderRadius+root3/2*(P)/8,0,0])
            rotate([90,0,0])
            cylinder(r=cylinderRadius,h=0.00001,$fn=3,center=true);
            
            translate([-tol,-P/2,-P/2]){
                cube([P,P,P]); 
            }

            translate([-P,-P/2,P/2]){
               cube([P,P,P]); 
            }
            
            translate([-P,-P/2,-3*P/2]){
               cube([P,P,P]); 
            }
        }
    }
}

//Hulls two consecutive thread triangles to create a segment of the thread
module threadSegment(P,D_maj, step, tol){
    for(i=[0:step:360-step]){
    hull()
        for(j = [0,step])
        rotate([0,0,(i+j)])
        translate([D_maj/2,0,(i+j)/360*P])
           screwthread_triangle(P, tol);
    }  
}

//Places enough thread segments to create one full rotation.  The first
//and last portion of external threads (for making bolts) are tapered 
//at a 20 degree angle for an easier fit
module screwthread_onerotation(P,D_maj,step, tol=0, first=false, last=false, internal=false) {
	H = root3/2*P;
	D_min = D_maj - 5*root3/8*P;       
        
         if(internal==false){ 
            difference(){ 
                threadSegment(P,D_maj, step, 0); 
                if(first==true){
                   //echo("first thread");
                    translate([D_maj/2-P/2,0,-P/2]){
                        rotate(-20,[0,0,1]){translate([0,-P*5,0]){cube([P,P*10,P]); }}}
                }
                
                if(last==true){
                   //echo("last thread");
                    translate([D_maj/2-P/2,0,-P/2+P]){
                        rotate(20,[0,0,1]){translate([0,-P*5,0]){cube([P,P*10,P]); }}}
                }
            }
            
        }else{
            threadSegment(P,D_maj+tol, step, tol);          
        }
 
               
        //make the cylinder a little larger if this is to be an internal thread
        if(internal==false){
            translate([0,0,P/2])
            cylinder(r=D_min/2,h=2*P,$fn=360/step,center=true);
        }else{
            translate([0,0,P/2])
            cylinder(r=D_min/2+tol,h=2*P,$fn=360/step,center=true);          
        }
}

//creates a thread using inches as units (tol is still in mm)
module thread_imperial(pitch, majorD, stepAngle, numRotations, tol=0, internal = false){
    p=pitch*25.4;
    d=majorD*25.4;
    thread(p,d,stepAngle,numRotations, tol);
}

//creates a thread using mm as units
module thread(P,D,step,rotations, tol=0, internal = false) {
    // added parameter "rotations"
    // as proposed by user bluecamel
	for(i=[0:rotations-1])
	translate([0,0,i*P]){
            if(i==0&&rotations<=1){
                screwthread_onerotation(
                P,D,step, tol, true, true, internal); //first if there is only one rotation
            }else if(i==0){
                screwthread_onerotation(
                P,D,step, tol, true, false, internal); //first if more than one rotation
            }else if(i==rotations-1){
                screwthread_onerotation(
                P,D,step, tol, false, true, internal); //last if more than one rotation
            }else{
                screwthread_onerotation(
                P,D,step, tol, false, false, internal); //middle threads
            }
        }
}
//------------------------------------------------------------------------------------------------





module holder(){
//upper tube to hold spray can
translate([0,0,canHolderVerticalSeperation+canHolderWallHeight+canHolderPlatformHeight]){
    difference(){
        cylinder(canHolderWallHeight, canDiameter/2+canHolderWallThickness, canDiameter/2+canHolderWallThickness);
        
        cylinder(canHolderWallHeight, canDiameter/2, canDiameter/2);
    }
    
    //line clip/retainer
    translate([-(canDiameter/2+canHolderWallThickness+lineDiameter/2),0,0]){
        rotate([0,0,(0-300)/2]){
            rotate_extrude(angle = 300){
                translate([lineDiameter/2,0,0]){
                    square([lineClipWallThickness,canHolderWallHeight]);
                }
            }
        }
    }
    
    //rounded line guide
    translate([0,-(canDiameter/2+canHolderWallThickness+lineDiameter/2)+0.5,lineDiameter*3/2]){
        rotate([90,0,0]){                
            rotate_extrude(angle = 180){
                translate([lineDiameter/2+lineClipWallThickness+3,0,0]){
                    projection(){
                        rotate([0,0,(360-300)/2]){
                            rotate_extrude(angle = 300){
                                translate([lineDiameter/2,0,0]){
                                    square([lineClipWallThickness,broomHandleClipWallHeight]);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    //reinforcing center of rounded line guide
    translate([0,-(canDiameter/2+canHolderWallThickness-lineDiameter/2),lineDiameter*3/2]){
        rotate([90,0,0]){
//            difference(){
                cylinder(lineDiameter+2,5,4);
//                translate([-5,-5,0]){
//                    cube([5*2,5,lineDiameter+2]);
//                }
                
//            }
        }
    }
}


//lower platform & tube to hold spray can
difference(){
    cylinder(canHolderWallHeight+canHolderPlatformHeight, canDiameter/2+canHolderWallThickness, canDiameter/2+canHolderWallThickness);
    translate([0,0,canHolderPlatformHeight]){     
        cylinder(canHolderWallHeight, canDiameter/2, canDiameter/2);
    }
    //cube to cut out tube and spray attachemnt part
    translate([-canDiameter,-canTopStrawSlotWidth/2,0]){
        cube([canDiameter,canTopStrawSlotWidth,canHolderWallHeight+canHolderPlatformHeight]);
    }
    //cylinder to cut out what nozzel attaches to
    translate([0,0,0]){
        cylinder(canHolderWallHeight+canHolderPlatformHeight,canTopDimpleDiameter/2,canTopDimpleDiameter/2);
    }   
}
rotate([0,0,20]){//FIXME magic number, calculate circumference of outer wall and move 2/3 the slot width worth of rotation around circumference
    //line clip/retainer
    translate([-(canDiameter/2+canHolderWallThickness+lineDiameter/2),0,0]){
        rotate([0,0,(0-300)/2]){
            rotate_extrude(angle = 300){
                translate([lineDiameter/2,0,0]){
                    square([lineClipWallThickness,canHolderWallHeight]);
                }
            }
        }
    }
}
translate([lineDiameter,-0.3,lineDiameter*3/2+lineClipWallThickness*2]){
    rotate([0,170,0]){
        //line guide
        translate([0,-(canDiameter/2+canHolderWallThickness+lineDiameter/2)+0.5,0]){
            rotate([90,0,0]){                
                rotate_extrude(angle = 50){
                    translate([lineDiameter/2+lineClipWallThickness+3,0,0]){
                        projection(){
                            rotate([0,0,(360-300)/2]){
                                rotate_extrude(angle = 300){
                                    translate([lineDiameter/2,0,0]){
                                        square([lineClipWallThickness,broomHandleClipWallHeight]);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        //reinforcing center of line guide
        translate([0,-(canDiameter/2+canHolderWallThickness-lineDiameter/2),0]){
            rotate([90,170/2-50/2,0]){
//                difference(){
                    cylinder(lineDiameter+2,5,4);
//                    translate([-5,-5,0]){
//                        cube([5*2,5,lineDiameter+2]);
//                    }
                    
//                }
            }
        }
    }
}



//main backbone connecting all various holders
translate([canDiameter/2,-holderBackboneWidth/2,0]){
    cube([holderBackboneDepth, holderBackboneWidth, holderBackboneHeight]);
}

//top (threaded) tube to attach all this to broom thread
translate([canDiameter/2+broomThreadBaseDiameter/2+holderBackboneDepth,0,holderBackboneHeight-broomThreadHeight]){
    difference(){
        cylinder(broomThreadHeight+broomThreadEndcapHeight, broomThreadBaseDiameter/2+broomThreadBaseWallThickness, broomThreadBaseDiameter/2+broomThreadBaseWallThickness);
        
//        cylinder(broomThreadHeight, broomThreadDiameter/2, broomThreadDiameter/2);
        translate([0,0,-1.5875/2]){
            thread(5,20,12,4,0.6, true);
        }

    }
}

//lower (non-threaded) tube to attach all this to broom thread
translate([canDiameter/2+broomThreadBaseDiameter/2+broomThreadBaseWallThickness,0,holderBackboneHeight-broomThreadHeight-broomThreadBaseHeight]){
    difference(){
        cylinder(broomThreadBaseHeight, broomThreadBaseDiameter/2+broomThreadBaseWallThickness, broomThreadBaseDiameter/2+broomThreadBaseWallThickness);
        
        cylinder(broomThreadBaseHeight, broomThreadBaseDiameter/2, broomThreadBaseDiameter/2);
    }
}

clip();

}// end module holder
//whitespace


module clip(lineClip){ //blank or false for no line holder clip
//bottom broom handle clip
translate([canDiameter/2+broomHandleDiameter/2+holderBackboneDepth,0,0]){
    rotate([0,0,(360-broomHandleClipAngularCoverage)/2]){
        rotate_extrude(angle = broomHandleClipAngularCoverage){
            translate([broomHandleDiameter/2,0,0]){
                square([broomHandleClipWallThickness,broomHandleClipWallHeight]);
            }
        }
    }
}

if (lineClip) {
    //line clip/retainer
    translate([canDiameter/2-lineDiameter/2+lineClipWallThickness,0,0]){
        rotate([0,0,(180-300)/2]){
            rotate_extrude(angle = 300){
                translate([lineDiameter/2,0,0]){
                    square([lineClipWallThickness,broomHandleClipWallHeight]);
                }
            }
        }
    }
}

//translate([-4,-2.5/2,20]){
//    cube([4,2.5,2]);
//}
}

//TODO make holder taller to have two clips? probably. not.
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




holder();
//clip(true);


//line pull retainer

//rotate([90,0,0]){                
//    rotate_extrude(angle = 180){
//        translate([lineDiameter/2+lineClipWallThickness+3,0,0]){
//            projection(){
//                rotate([0,0,(360-300)/2]){
//                    rotate_extrude(angle = 300){
//                        translate([lineDiameter/2,0,0]){
//                            square([lineClipWallThickness,broomHandleClipWallHeight]);
//                        }
//                    }
//                }
//            }
//        }
//    }
//}

    

    