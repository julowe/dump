//utensil rack/dryer
//20210202

//TODO make sure measurements are right
draftingFNs = 18;
renderingFNs = 180;
currentFNs = draftingFNs;
$fn = currentFNs;

barWallOffset = 28; //actual 33.3

cupTopDepth = 80;
cupBottomDepth = 70;
cupTopWidth = 150;
cupBottomWidth = 130;
depth = 80;
width = 150;
wall = .5;
height = 130;
roundingRadius = 2;

difference(){
    minkowski(){
        difference(){
                linear_extrude(height = height, center = false, scale=[1.2,1.3]) {
                    translate([-(cupBottomWidth+2*wall),0]){
                        square([cupBottomWidth+2*wall,cupBottomDepth+2*wall]);
                    }
                }
//            }
            translate([0,0,(wall*2)]){
                linear_extrude(height = height+roundingRadius*3, center = false, scale=[1.2,1.3]) {
                    translate([-(cupBottomWidth+wall),wall]){
                        square([cupBottomWidth,cupBottomDepth]);
                    }
                }

            }
        
        }
        sphere(roundingRadius);
    }
    
    //make drain holes - only 2 rows so it drips on sink lip but not counter
    for (i = [0:16]) {
        for (j = [0:1]) {
            translate([-(9+i*7),cupBottomDepth-12+j*7,-5]){
                cylinder(10,1.5,1.5);
            }
        }
    }
}

//TODO attach hanging clips 2-3?
// clip for hanging bar above sink
// justin lowe 20201116

//v2 are measuremnts of bar, not clips that apparently don't fit well over bar... darn.
barHeight = 25; //24.3 actual
barDepth = 12.5; //12.25 actual
barStandoff = 33.3; //distance from front of bar to wall behind it

//11.75mm void depth for clip (part that goes around hanging bar)
//14.5 mm wide clip (looking striaght on, left to right side) not important really
//15.4mm height straight section of clip 
//27.2 clip height


//clipInnerRadius = 11.75/2; //v1
clipInnerRadius = barDepth/2; //v2
clipWallThickness = 3;
clipOuterRadius = clipInnerRadius+clipWallThickness;
//clipInnerHeight = 15.5; //v1
//clipOuterHeight = 20; //v1
clipInnerHeight = barHeight - barDepth; // minus 2x the radius
clipOuterHeight = clipInnerHeight + 4; //how much the front/outer side of the clip extends down

clipWidth = 14;


polyPoints = [
  [  0,  0,  0 ],  //0
  [ 0,  0-clipOuterRadius,  0 ],  //1
  [ -10,  0-clipOuterRadius,  0 ],  //2
  [  0,  0,  clipWidth ],  //3
  [  -10,  0-clipOuterRadius,  clipWidth ],  //4
  [ 0,  0-clipOuterRadius,  clipWidth ],  //5
];
  
polyFaces = [
  [0,1,2],  // bottom
  [1,5,4,2],  // front
  [0,3,5,1],  // right
  [0,2,4,3],  // back
  [3,4,5],  // top
]; 


module clip(){
    difference(){
        //outer cylinder to subtract from 
        translate([0,0,0]){
            cylinder(clipWidth,clipOuterRadius,clipOuterRadius);
        }
        
        //inner cylinder to subtract
        translate([0,0,0]){
            cylinder(clipWidth,clipInnerRadius,clipInnerRadius);
        }
        
        //get rid of bottom half of cylinder/tube
        translate([-(clipOuterRadius),-(clipOuterRadius)*2,0]){
            cube([(clipOuterRadius)*2,(clipOuterRadius)*2,clipWidth]);
        }
    } //end of difference
    
    translate([0,-clipInnerHeight,0]){
        difference(){
            //outer cylinder to subtract from 
            translate([0,0,0]){
                cylinder(clipWidth,clipOuterRadius,clipOuterRadius);
            }
            
            //inner cylinder to subtract
            translate([0,0,0]){
                cylinder(clipWidth,clipInnerRadius,clipInnerRadius);
            }
            
            //get rid of top half of cylinder/tube
            translate([-(clipOuterRadius),0,0]){
                cube([(clipOuterRadius)*2,(clipOuterRadius)*2,clipWidth]);
            }
      
            polyhedron( polyPoints, polyFaces );
    
            //get rid of bottom half of cylinder/tube
            translate([0,-(clipOuterRadius),0]){
                cube([(clipOuterRadius),(clipOuterRadius),clipWidth]);
            }
        } //end of difference
    }  
    
    //clip wall behind hanging bar
    translate([-(clipInnerRadius+clipWallThickness),-clipInnerHeight,0]){
        cube([clipWallThickness,clipInnerHeight,clipWidth]);
    }
    
    //clip wall in front of hanging bar
    translate([clipInnerRadius,-clipOuterHeight,0]){
        cube([clipWallThickness,clipOuterHeight,clipWidth]);
    }

} //end module
//whitespace

translate([-(clipWidth+10),-clipOuterRadius+(clipWallThickness-roundingRadius)-1.1,height-clipOuterRadius]){
    rotate([90,-4,90]){
        clip();
    }
}
//-(clipWidth+(cupBottomWidth*1.2)-10)
translate([-((cupBottomWidth*1.2)-10),-clipOuterRadius+(clipWallThickness-roundingRadius)-1.1,height-clipOuterRadius]){
    rotate([90,-4,90]){
        clip();
    }
}

bumperRadius = 10;

translate([-(bumperRadius+10),0,bumperRadius+10]){
    rotate([90,0,0]){
        cylinder(barWallOffset,bumperRadius,bumperRadius);
    }
}
translate([-(cupBottomWidth-bumperRadius-5),0,bumperRadius+10]){
    rotate([90,0,0]){
        cylinder(barWallOffset,bumperRadius,bumperRadius);
    }
}

//TODO make wall bumpers near bottom - at correct angle for water draining
