// clip for hanging bar above sink
// justin lowe 20201116

//11.75mm void depth for clip (part that goes around hanging bar)
//14.5 mm wide clip (looking striaght on, left to right side) not important really
//15.4mm height straight section of clip 
//27.2 clip height

//9mm diamter brush hole
//8mm height brush hole

draftingFNs = 18;
renderingFNs = 180;
currentFNs = draftingFNs;
$fn = currentFNs;

clipInnerRadius = 11.75/2;
clipWallThickness = 3;
clipOuterRadius = clipInnerRadius+clipWallThickness;
clipInnerHeight = 15.5;
clipOuterHeight = 20;

clipWidth = 14;

hangerHeight = 10;
hangerRadius = 9/2;
hangerHookHeight = 5;

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

module hanger(){
    translate([clipOuterRadius,-hangerRadius,clipWidth/2]){
        rotate([0,90,0]){
            cylinder(hangerHeight,hangerRadius,hangerRadius);
        }
    }
    
    translate([clipOuterRadius+hangerHeight+hangerRadius,0,clipWidth/2]){
        rotate([0,90,90]){
            cylinder(hangerHookHeight,hangerRadius,hangerRadius);
        }
    }
    
    translate([clipOuterRadius+hangerHeight,0,clipWidth/2-hangerRadius]){
        rotate([0,0,-90]){
            rotate_extrude(angle = 90){
                translate([hangerRadius,hangerRadius,0]){
                    circle(hangerRadius);
                }
            }
        }
    }
    
    translate([clipOuterRadius+hangerHeight+hangerRadius,hangerHookHeight,clipWidth/2]){
        sphere(hangerRadius);
    }
} //end module
//whitespace
    

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
                    
    //        //get rid of most of bottom half of cylinder/tube
    //        translate([0,-(clipOuterRadius)+0,clipWidth]){
    //            rotate([0,180,30]){
    //                cube([(clipOuterRadius),(clipOuterRadius),clipWidth]);
    //            }
    //        }
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



clip();
hanger();