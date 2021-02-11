//pelican style box
//20210210 jkl

/*modeling outline 
1. make simple box with cubes, spheres at corners, cylinders at edges (v minkowski quicker to render. worth it?)
2. as below:
difference(){
    union(){
        main outside shell
        
        difference(){
            outside shell that will be extent of ridges (on main shell)
            
            cubes to take away most of material and make shell into ridges
        } //end difference
    } //end union
    
    ?difference(){
        simple box to make void inside main shell
        stand offs on bottom or at corners etc for various inserts?
    ?}
} //end difference

3. make back hinge 
4. make pin holes for back hinges & front (& side?) clip(s?)

z. cubes to split in two to create seperate halves for making

a. make clip(s?)
*/

draftingFNs = 36;
renderingFNs = 360;
//currentFNs = draftingFNs;
$fn = draftingFNs;

boxRoundingRadius = 5;
boxWidth = 40;
boxDepth = 80;
boxHeight = 60;
asdf = 1;

module roundedBox(width, depth, height, edgeRoundingRadius){
    //top & bottom
    translate([edgeRoundingRadius,edgeRoundingRadius,0]){
        cube([width-edgeRoundingRadius*2,depth-edgeRoundingRadius*2,height]);
    }
    //front & back
    translate([edgeRoundingRadius,0,edgeRoundingRadius]){
        cube([width-edgeRoundingRadius*2,depth,height-edgeRoundingRadius*2]);
    }
    //left & right
    translate([0,edgeRoundingRadius,edgeRoundingRadius]){
        cube([width,depth-edgeRoundingRadius*2,height-edgeRoundingRadius*2]);
    }
    
    //corners
    //front
    translate([edgeRoundingRadius,edgeRoundingRadius,height-edgeRoundingRadius]){
        sphere(edgeRoundingRadius);
    }
    translate([width-edgeRoundingRadius,edgeRoundingRadius,height-edgeRoundingRadius]){
        sphere(edgeRoundingRadius);
    }
    translate([width-edgeRoundingRadius,edgeRoundingRadius,edgeRoundingRadius]){
        sphere(edgeRoundingRadius);
    }
    translate([edgeRoundingRadius,edgeRoundingRadius,edgeRoundingRadius]){
        sphere(edgeRoundingRadius);
    }
    //back
    translate([edgeRoundingRadius,depth-edgeRoundingRadius,height-edgeRoundingRadius]){
        sphere(edgeRoundingRadius);
    }
    translate([width-edgeRoundingRadius,depth-edgeRoundingRadius,height-edgeRoundingRadius]){
        sphere(edgeRoundingRadius);
    }
    translate([width-edgeRoundingRadius,depth-edgeRoundingRadius,edgeRoundingRadius]){
        sphere(edgeRoundingRadius);
    }
    translate([edgeRoundingRadius,depth-edgeRoundingRadius,edgeRoundingRadius]){
        sphere(edgeRoundingRadius);
    }
    
    //edges
    //front
    translate([edgeRoundingRadius,edgeRoundingRadius,height-edgeRoundingRadius]){
        rotate([0,90,0]){
            cylinder(width-edgeRoundingRadius*2,edgeRoundingRadius,edgeRoundingRadius);
        }
    }
    translate([width-edgeRoundingRadius,edgeRoundingRadius,edgeRoundingRadius]){
        rotate([0,0,0]){
            cylinder(height-edgeRoundingRadius*2,edgeRoundingRadius,edgeRoundingRadius);
        }
    }
    translate([edgeRoundingRadius,edgeRoundingRadius,edgeRoundingRadius]){
        rotate([0,90,0]){
            cylinder(width-edgeRoundingRadius*2,edgeRoundingRadius,edgeRoundingRadius);
        }
    }
    translate([edgeRoundingRadius,edgeRoundingRadius,edgeRoundingRadius]){
        rotate([0,0,0]){
            cylinder(height-edgeRoundingRadius*2,edgeRoundingRadius,edgeRoundingRadius);
        }
    }
    
    //sides
    translate([edgeRoundingRadius,edgeRoundingRadius,edgeRoundingRadius]){
        rotate([-90,0,0]){
            cylinder(depth-edgeRoundingRadius*2,edgeRoundingRadius,edgeRoundingRadius);
        }
    }
    translate([edgeRoundingRadius,edgeRoundingRadius,height-edgeRoundingRadius]){
        rotate([-90,0,0]){
            cylinder(depth-edgeRoundingRadius*2,edgeRoundingRadius,edgeRoundingRadius);
        }
    }
    translate([width-edgeRoundingRadius,edgeRoundingRadius,edgeRoundingRadius]){
        rotate([-90,0,0]){
            cylinder(depth-edgeRoundingRadius*2,edgeRoundingRadius,edgeRoundingRadius);
        }
    }
    translate([width-edgeRoundingRadius,edgeRoundingRadius,height-edgeRoundingRadius]){
        rotate([-90,0,0]){
            cylinder(depth-edgeRoundingRadius*2,edgeRoundingRadius,edgeRoundingRadius);
        }
    }
    
    //back
    translate([edgeRoundingRadius,depth-edgeRoundingRadius,height-edgeRoundingRadius]){
        rotate([0,90,0]){
            cylinder(width-edgeRoundingRadius*2,edgeRoundingRadius,edgeRoundingRadius);
        }
    }
    translate([width-edgeRoundingRadius,depth-edgeRoundingRadius,edgeRoundingRadius]){
        rotate([0,0,0]){
            cylinder(height-edgeRoundingRadius*2,edgeRoundingRadius,edgeRoundingRadius);
        }
    }
    translate([edgeRoundingRadius,depth-edgeRoundingRadius,edgeRoundingRadius]){
        rotate([0,90,0]){
            cylinder(width-edgeRoundingRadius*2,edgeRoundingRadius,edgeRoundingRadius);
        }
    }
    translate([edgeRoundingRadius,depth-edgeRoundingRadius,edgeRoundingRadius]){
        rotate([0,0,0]){
            cylinder(height-edgeRoundingRadius*2,edgeRoundingRadius,edgeRoundingRadius);
        }
    }
}


roundedBox(boxWidth, boxDepth, boxHeight, boxRoundingRadius);