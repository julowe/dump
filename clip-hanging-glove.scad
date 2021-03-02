//glove hanging clip

//0.8mm thickness

//4mm diameter of clip

//diameter of wire rack 2.8mm
//22.3mm between wires on shelf

//2021-03-02 3mm radius 1.5mm clip gap worked well. maybe  atouch too tight? but holds well. 

draftingFNs = 18;
renderingFNs = 180;
//currentFNs = draftingFNs;
$fn = renderingFNs;
debugBool = true;

gloveVoidThickness = 1.5;
gloveVoidDepth = 20;
gloveVoidOverlap = 2; //distance before void meets sphere
clipRadius = 3;
clipHeight = 35;
clipInnerRadius = 3;
ridgeIntrusion = 3/2;
ridgeDepth = (gloveVoidDepth-clipRadius)*2/3;


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
difference(){
    union(){
        //main body of clip
        cylinder(clipHeight,clipRadius,clipRadius);
        
        //bottom rounded edge of clip
        sphere(clipRadius);
    } //end union
    
    //void for glove to slide into
    translate([-gloveVoidThickness/2,-clipRadius,-clipRadius]){
        cube([gloveVoidThickness,clipRadius*2,gloveVoidDepth]);
    }
    
    //void to take away material above glove void
    translate([0,-clipRadius,gloveVoidDepth]){
        cube([clipRadius,clipRadius*2,clipHeight-gloveVoidDepth]);
    }
}

difference(){
    //top rounded edge of clip
    translate([0,0,gloveVoidDepth]){
        sphere(clipRadius);
    }

//remove bottom half of sphere
    translate([-clipRadius,-clipRadius,gloveVoidDepth-clipRadius]){
        cube([clipRadius*2,clipRadius*2,clipRadius]);
    }
}



//TODO CHANGE X translation

//add ridges to compress glove inside clip
translate([gloveVoidThickness/3*2,-2.8,0]){
    rotate([0,0,45]){
        cube([gloveVoidThickness,gloveVoidThickness,ridgeDepth]);
    }
}
translate([-gloveVoidThickness/3*2,-1.6,0]){
    rotate([0,0,45]){
        cube([gloveVoidThickness,gloveVoidThickness,ridgeDepth]);
    }
}
translate([-gloveVoidThickness/3*2,0.7,0]){
    rotate([0,0,45]){
        cube([gloveVoidThickness,gloveVoidThickness,ridgeDepth]);
    }
}
translate([gloveVoidThickness/3*2,-0.4,0]){
    rotate([0,0,45]){
        cube([gloveVoidThickness,gloveVoidThickness,ridgeDepth]);
    }
}

//top hook
translate([clipInnerRadius,0,clipHeight]){
    rotate([-90,0,0]){
        rotate_extrude(angle = 220, convexity = 2) {
            translate([-clipInnerRadius,0,0]){//half circle
                difference(){
                    circle(clipRadius);
                    translate([0,-clipRadius,0]){
                        square(clipRadius*2,clipRadius*2);
                    }
                }
            }
        }
    }
}
}//end union

//square edges for nice printing when laid on bed
translate([-clipRadius,clipRadius*0.95,-clipRadius]){
    cube([(clipRadius+clipInnerRadius)*2,1,clipHeight+clipRadius*2+clipInnerRadius]);
}

//make it symmetric just because
translate([-clipRadius,-clipRadius*0.95-1,-clipRadius]){
    cube([(clipRadius+clipInnerRadius)*2,1,clipHeight+clipRadius*2+clipInnerRadius]);
}

}
