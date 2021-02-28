//glove hanging clip

//0.8mm thickness

//4mm diameter of clip

//diameter of wire rack 2.8mm
//22.3mm between wires on shelf

draftingFNs = 18;
renderingFNs = 180;
//currentFNs = draftingFNs;
$fn = draftingFNs;
debugBool = true;

gloveVoidThickness = 1.2;
gloveVoidDepth = 10;


//linear_extrude(height = 15, center = true, convexity = 10, twist = 0, slices = 20, scale = 1.0) {
//    //half circle
//    difference(){
//        circle(2);
//        translate([0,-2,0]){
//            square(4,4);
//        }
//    }
//}
//


difference(){
    union(){
        //main body of clip
        cylinder(15,2,2);
        
        //bottom rounded edge of clip
        sphere(2);
    } //end union
    
    //void for glove to slide into
    translate([-gloveVoidThickness/2,-2,-2]){
        cube([gloveVoidThickness,4,12]);
    }
    
    //void to take away material above glove void
    translate([0,-2,gloveVoidDepth]){
        cube([2,4,15-gloveVoidDepth]);
    }
}

difference(){
//top rounded edge of clip
translate([0,0,gloveVoidDepth]){
    sphere(2);
}

//remove bottom half of sphere
    translate([-2,-2,8]){
        cube([4,4,2]);
    }
}

//add ridges to compress glove inside clip
translate([gloveVoidThickness/2,-1.8,0]){
    rotate([0,0,45]){
        cube([gloveVoidThickness/2,gloveVoidThickness/2,gloveVoidDepth/2]);
    }
}
translate([-gloveVoidThickness/2,-1,0]){
    rotate([0,0,45]){
        cube([gloveVoidThickness/2,gloveVoidThickness/2,gloveVoidDepth/2]);
    }
}
translate([-gloveVoidThickness/2,1,0]){
    rotate([0,0,45]){
        cube([gloveVoidThickness/2,gloveVoidThickness/2,gloveVoidDepth/2]);
    }
}
translate([gloveVoidThickness/2,0,0]){
    rotate([0,0,45]){
        cube([gloveVoidThickness/2,gloveVoidThickness/2,gloveVoidDepth/2]);
    }
}


//top hook
translate([3,0,15]){
rotate([-90,0,0]){
rotate_extrude(angle = 220, convexity = 2) {
    translate([-3,0,0]){//half circle
        difference(){
            circle(2);
            translate([0,-2,0]){
                square(4,4);
            }
        }
    }
}
}
}


//translate([0,0,-7.5]){
//rotate([90,00,0]){
//rotate_extrude(angle = 90, convexity = 2) {
////    translate([-2,0,0]){//half circle
//        difference(){
//            circle(2);
//            translate([0,-2,0]){
//                square(4,4);
//            }
//        }
////    }
//}
//}
//}