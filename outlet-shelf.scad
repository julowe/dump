//shelf for over outlet
//justin lowe 2020-1026

//total dimensions - 14mm x 4mm x 270mm
//outelt is 115mm wide (horizontal is lnoger axis in this instance)
//print area 220x220x250

//design: simple, two legs holding up a shelf above outlet. make shelf rounded void to angle pictures etc

//$fn = 36; //less for drafting
$fn = 180; //more for rendering

shelfLength = 200;
shelfDepth = 6;
shelfHeight = 14;
shelfEdgeRounding = 2;
shelfWallDepth = 1;
outletWidth = 115 + 10; //20 is fudge
legOffCenterDistance = 20;
legFirstX = (shelfLength/2 - outletWidth/2) - legOffCenterDistance;
legSecondX = (shelfLength/2 + outletWidth/2) + legOffCenterDistance;

legHeight = shelfHeight + shelfDepth;
legWidthTop = 4;
legWidthBottom = 10;


roundedEndCaps = false; //valid values are true or false

union(){
    difference(){
        union(){
            rotate([0,90,0]){
                cylinder(shelfLength, shelfDepth, shelfDepth);
            }
            
            if ( roundedEndCaps ){
                translate([0,0,0]){
                    sphere(shelfDepth);
                }
                translate([shelfLength,0,0]){
                    sphere(shelfDepth);
                }
            }
            
            translate([legFirstX,-(legWidthTop*0.75),-(legHeight)]){
                cylinder(legHeight, legWidthBottom/2, legWidthTop/2);
            }
            translate([legSecondX,-(legWidthTop*0.75),-(legHeight)]){
                cylinder(legHeight, legWidthBottom/2, legWidthTop/2);
            }
            
        } //end union
        //whitespace
        
        
        //start subtracting
        
        //subtracting other 3 quadrants of cylinder & spheres
        translate([-shelfDepth,-shelfDepth,0]){
            cube([shelfLength+shelfDepth*2, shelfDepth*2, shelfDepth]);
        }
        translate([-shelfDepth,0,-shelfDepth*10]){
            cube([shelfLength+shelfDepth*2, shelfDepth, shelfDepth*10]);
        }
    
        //start forming shelf inset
        //spheres to round inside void
        translate([0,0,0]){
            sphere(shelfDepth - shelfEdgeRounding);
        }
        translate([shelfLength,0,0]){
            sphere(shelfDepth - shelfEdgeRounding);
        }
        
        //remove main shelf void
        translate([0,0,0]){
            rotate([0,90,0]){
                cylinder(shelfLength, shelfDepth - shelfEdgeRounding, shelfDepth - shelfEdgeRounding);
            }
        }
    } //end difference
    //whitespace
    
    //add edge rounding lips
    if ( roundedEndCaps ){
        translate([0,0,0]){
            rotate([0,0,180]){
                rotate_extrude(angle=90, convexity = 10){
                    translate([(shelfDepth - shelfEdgeRounding/2), 0, 0]){
                        circle(shelfEdgeRounding/2);
                    }
                }
            }
        }
        translate([shelfLength,0,0]){
            rotate([0,0,270]){
                rotate_extrude(angle=90, convexity = 10){
                    translate([(shelfDepth - shelfEdgeRounding/2), 0, 0]){
                        circle(shelfEdgeRounding/2);
                    }
                }
            }
        }
    } else {
        translate([0,-(shelfDepth - shelfEdgeRounding/2),0]){
            sphere(shelfEdgeRounding/2);
        }
        translate([0,0,0]){
            rotate([0,90,180]){
                rotate_extrude(angle=90, convexity = 10){
                    translate([(shelfDepth - shelfEdgeRounding/2), 0, 0]){
                        circle(shelfEdgeRounding/2);
                    }
                }
            }
        }
        
        translate([shelfLength,-(shelfDepth - shelfEdgeRounding/2),0]){
            sphere(shelfEdgeRounding/2);
        }
        translate([shelfLength,0,0]){
            rotate([-90,0,270]){
                rotate_extrude(angle=90, convexity = 10){
                    translate([(shelfDepth - shelfEdgeRounding/2), 0, 0]){
                        circle(shelfEdgeRounding/2);
                    }
                }
            }
        }
        
    } //end if
    //whitespace
    
    
    
    translate([0,-(shelfDepth - shelfEdgeRounding/2),0]){
        rotate([0,90,0]){
            cylinder(shelfLength, shelfEdgeRounding/2, shelfEdgeRounding/2);
        }
    }
    
    //make back shelf wall
    translate([0,-shelfWallDepth,-(0+shelfDepth)]){
        cube([shelfLength, shelfWallDepth,(shelfDepth + 0)]);
    }
    
    difference(){
        union(){
            //round back shelf wall edges
            translate([0,0,-(shelfDepth-shelfWallDepth)]){
                cylinder(shelfDepth - shelfWallDepth, shelfWallDepth, shelfWallDepth);
            }
            translate([shelfLength,0,-(shelfDepth-shelfWallDepth)]){
                cylinder(shelfDepth - shelfWallDepth, shelfWallDepth, shelfWallDepth);
            }
            
            translate([shelfLength,0,0]){
                sphere(shelfWallDepth);
            }
            translate([0,0,0]){
                sphere(shelfWallDepth);
            }
            translate([0,0,0]){
                rotate([0,90,0]){
                    cylinder(shelfLength, shelfWallDepth, shelfWallDepth);
                }
            }
        }
        
        //remove extraneous rounding on back wall edge
        translate([-shelfWallDepth,0,-(shelfDepth-shelfWallDepth)]){
            color("Green")
            cube([shelfLength + shelfWallDepth*2,1,shelfDepth]);
        }
    }


} //end union
//whitespace


