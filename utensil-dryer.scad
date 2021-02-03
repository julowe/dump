//utensil rack/dryer
//20210202

//TODO make sure measurements are right
$fn = 60;
depth = 70;
wall = 2;

difference(){
    union(){
        mirror([1,0,0]){
            linear_extrude(height = 120, center = false, convexity = 10, scale=[1.2,1.3], $fn=100, slices=20, twist=0) {
                offset(r=5){
                    square([124,depth+2*wall]);
                }
            }
        }
        minkowski(){
            mirror([1,0,0]){
                linear_extrude(height = 1, center = false, convexity = 10, twist=0) {
                    square([124,depth+2*wall]);
                }
            }
            sphere(5);
        }
        translate([0,0,120]){
    difference(){
        scale([1.2,1.3]){
            minkowski(){
                mirror([1,0,0]){
                    linear_extrude(height = 1, center = false, convexity = 10, twist=0) {
                        square([124,depth+2*wall]);
                    }
                }
                sphere(5);
            }
        } //end scale
        translate([0,0,-5]){
            scale([1.2,1.3]){
                mirror([1,0,0]){
                    linear_extrude(height = 5, center = false, convexity = 10, scale=[1.2,1.3], $fn=100, slices=20, twist=0) {
                        offset(r=5){
                            square([124,depth+2*wall]);
                        }
                    }
                }
            }
        }
    }
} 
    }
    translate([-2.5,2.5,0]){
        mirror([1,0,0]){
            linear_extrude(height = 126, center = false, convexity = 10, scale=[1.2,1.3], $fn=100, slices=20, twist=0) {
                offset(r=5){
                    square([120,depth]);
                }
            }
        }
    }
    for (i = [0:17]) {
        for (j = [0:1]) {
            translate([-(4+i*7),depth-4+j*7,-5]){
                cylinder(10,1.5,1.5);
            }
        }
    }
}

//TODO attach hanging clips 2-3?
