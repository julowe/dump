//salt cellar cover
//justin lowe 2020-10-26

//idea: cover for salt cellar. cylinder, with press fit custom handle - for easy novelty swap out

draftingFNs = 18;
renderingFNs = 360;
//currentFNs = draftingFNs;
$fn = draftingFNs;

cellarInsideDiameter = 73.6;
cellarOutsideDiameter = 82.2;

lidInnerCylinderDiameter = cellarInsideDiameter - 1;
lidInnerWallWidth = 2;
lidInnerWallDepth = 10;
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

//tsp_radius = sqrt(tsp / (PI * lidInnerWallDepth));
//half_tsp_radius = sqrt((tsp/2) / (PI * lidInnerWallDepth/2));

//have quarter tsp take up half of height of inner cylinder
quarter_tsp_height = lidInnerWallDepth/2;
quarter_tsp_radius = sqrt((tsp/4) / (PI * quarter_tsp_height));

//have half teaspoon take up half of (remaining height - 1 mm) for better wall structure between pressfit and measurement holes
half_tsp_height = (lidInnerWallDepth - 1 - lidInnerWallDepth/2)/2;
half_tsp_radius = sqrt((tsp/2) / (PI * half_tsp_height));

//have tsp height be same as half tsp height
tsp_height = half_tsp_height;
tsp_radius = sqrt(tsp / (PI * tsp_height));

echo("tsp_radius = ", tsp_radius);
echo("half_tsp_radius = ", half_tsp_radius);
echo("quarter_tsp_radius = ", quarter_tsp_radius);



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
    





translate([0,0,(tsp_height + half_tsp_height)]){
    color("Green")
    cylinder(quarter_tsp_height, quarter_tsp_radius, quarter_tsp_radius);
}
translate([0,0,tsp_height]){
    color("Red")
    cylinder(half_tsp_height, half_tsp_radius, half_tsp_radius);
}
translate([0,0,0]){
    color("Blue")
    cylinder(tsp_height, tsp_radius, tsp_radius);
}

}// end difference

text_height = 1;

rotate([0,180,0]){
    translate([-quarter_tsp_radius*3/3/2,-quarter_tsp_radius*2/3/2, -(tsp_height + half_tsp_height + quarter_tsp_height - text_height)]){
        linear_extrude(height = text_height, center = true, convexity = 10){
            resize([quarter_tsp_radius*3/3,quarter_tsp_radius*2/3,1]){
                text("1/4", size = 10);
            }
        }
    }
}


rotate([0,180,0]){
    translate([-(half_tsp_radius - quarter_tsp_radius)*2/3/2, quarter_tsp_radius + (half_tsp_radius - quarter_tsp_radius - (half_tsp_radius - quarter_tsp_radius)*1/2)/2, -(tsp_height + half_tsp_height - text_height)]){
        linear_extrude(height = text_height, center = true, convexity = 10){
            resize([(half_tsp_radius - quarter_tsp_radius)*2/3, (half_tsp_radius - quarter_tsp_radius)*1/2, 1]){
                text("1/2", size = 10);
            }
        }
    }
}


rotate([0,180,0]){
    translate([-(tsp_radius - half_tsp_radius)*3/3/2, half_tsp_radius + (tsp_radius - half_tsp_radius - (tsp_radius - half_tsp_radius)*2/3)/2, -(tsp_height - text_height)]){
        linear_extrude(height = text_height, center = true, convexity = 10){
            resize([(tsp_radius - half_tsp_radius)*3/3, (tsp_radius - half_tsp_radius)*2/3, 1]){
                text("tsp", size = 10);
            }
        }
    }
}
    
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