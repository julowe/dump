//salt cellar press fit Handle
//justin lowe 2020-10-29

//idea: cover for salt cellar. cylinder, with press fit custom handle - for easy novelty swap out

//0.1 is a good tolerance for press fit square
tolerance = 0.1;

draftingFNs = 36;
renderingFNs = 360;
//currentFNs = draftingFNs;
$fn = draftingFNs;

lidPressFitSquareWidth = 10;
lidPressFitSquareDepth = 3;
lidPressFitSquareDepthTrue = 2.6;

handleDiameter = 15;
torusSubtractionRadius = 5;
handleHeight = handleDiameter;
handleTopHeight = 4;

difference(){
    union(){
        translate([0,0,lidPressFitSquareDepth/2]){
            cube([lidPressFitSquareWidth-tolerance, lidPressFitSquareWidth-tolerance, lidPressFitSquareDepth*1],true);
        }
        translate([0,0,lidPressFitSquareDepthTrue]){
            cylinder(handleHeight+handleTopHeight,handleDiameter/2+torusSubtractionRadius,handleDiameter/2+torusSubtractionRadius);
        //    cube([lidPressFitSquareWidth-tolerance, lidPressFitSquareWidth-tolerance, lidPressFitSquareDepth*4],true);
        }
        translate([0,0,lidPressFitSquareDepthTrue+handleDiameter+handleTopHeight/2]){
            rotate([0,0,0]){
                rotate_extrude(angle=360, convexity = 10){
                    translate([handleDiameter/2+torusSubtractionRadius, 0, 0]){
                        circle(handleTopHeight/2);
                    }
                }
            }
        }
    }

    translate([0,0,lidPressFitSquareDepthTrue+handleDiameter/2]){
        rotate([0,0,0]){
            rotate_extrude(angle=360, convexity = 10){
                translate([torusSubtractionRadius+handleDiameter/2, 0, 0]){
                    circle(handleDiameter/2);
                }
            }
        }
    }
    
    translate([0,0,handleHeight+11.0]){
        scale([1,1,0.5]){
            sphere(15);
        }
    }
    
}

