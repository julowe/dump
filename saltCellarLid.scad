//salt cellar cover
//justin lowe 2020-10-26

//idea: cover for salt cellar. cylinder, with press fit custom handle - for easy novelty swap out

draftingFNs = 18;
renderingFNs = 180;
//currentFNs = draftingFNs;
$fn = draftingFNs;

cellarInsideDiameter = 73.6;
cellarOutsideDiameter = 82.2;

lidInnerCylinderDiameter = cellarInsideDiameter - 1;
lidInnerWallWidth = 2;
lidInnerWallDepth = 15;
lidOuterCylinderDiameter = cellarOutsideDiameter + 0;
lidOuterOverlap = 0;
lidOuterCylinderHeight = 5;

lidInnerWallEdgeRounding = lidInnerWallDepth/4;

lidPressFitSquareWidth = 10;
lidPressFitSquareDepth = 3;

//cylinder volume = circle * height = pi*r^2 * height
//1 teaspoon = 4928.92 mm^3
//1 tablespoon = 14786.8 mm^3
tsp = 4928.92;
tbsp = 14786.8;

difference(){
    union(){
        translate([0,0,lidInnerWallDepth]){
            cylinder(lidOuterCylinderHeight,lidOuterCylinderDiameter/2, lidOuterCylinderDiameter/2);
        }
        
        translate([0,0,lidInnerWallEdgeRounding]){
            cylinder(lidInnerWallDepth - lidInnerWallEdgeRounding,lidInnerCylinderDiameter/2, lidInnerCylinderDiameter/2);
        }
        translate([0,0,0]){
            cylinder(lidInnerWallEdgeRounding,lidInnerCylinderDiameter/2 - lidInnerWallEdgeRounding, lidInnerCylinderDiameter/2 - lidInnerWallEdgeRounding);
        }
        
        translate([0,0,lidInnerWallEdgeRounding]){
            rotate([0,0,0]){
                rotate_extrude(angle=360, convexity = 10){
                    translate([(lidInnerCylinderDiameter/2 - lidInnerWallEdgeRounding), 0, 0]){
                        circle(lidInnerWallEdgeRounding);
                    }
                }
            }
        }
    } //end union for lid cylinders
    
    translate([-lidPressFitSquareWidth/2, -lidPressFitSquareWidth/2, (lidInnerWallDepth + lidOuterCylinderHeight - lidPressFitSquareDepth)]){
        cube([lidPressFitSquareWidth, lidPressFitSquareWidth, lidPressFitSquareDepth]);
    }
    
}// end difference
    
    
//union
//(
//top cylinder X
//torus around top cylinder
//
//cylinder to stop lid from sliding off cellar X
//torus under cylinder/tube downward edge X
//
//maybe chamfer the tube to cylinder joint?
//)
//subtract
//(
//make various cylinders inside lid for different volumes of salt (1/4, 1/2, 1 teaspoons?) tabelspoon??
//
//
//pressfit square
//)