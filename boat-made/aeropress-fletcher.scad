//aeropress stand
$fn = 90; //resolution of curves


plunger_tube_diameter = 58; //measured 56.5mm
plunger_lip_diameter = 74; //measured 70.9mm
plunger_lip_height = 4.5; //measured 3.6mm
plunger_nominal_height = 100; //not measured, just tall enough to subtract from everything


//c-clamp, or full wrap around that bench lip?

//back is part to c-clamp to
back_height = 25;
back_depth = 3;
back_additional_side = 15;

finger_width = 8;
finger_back_width = 5;
finger_height = 3;
front_overhang = -20;

//
//make holder
//
difference(){
//    hull(){ //hull-wedge, or union/right angle? make put a rotated cylinder subtraction?
    union(){
        //make holder around plunger
        translate([-plunger_lip_diameter/2-finger_width,-plunger_lip_diameter/2-finger_back_width,0]){
            cube([plunger_lip_diameter+finger_width*2+back_additional_side,plunger_lip_diameter+front_overhang+finger_back_width,plunger_lip_height+finger_height]);
        }
        
        //make back wall against bench lip
        translate([-plunger_lip_diameter/2-finger_width,-plunger_lip_diameter/2-finger_back_width,0]){
            cube([plunger_lip_diameter+finger_width*2+back_additional_side,back_depth,back_height]);
        }

    } //end union


    //make plunger model to subtract from things
    cylinder(plunger_nominal_height, plunger_tube_diameter/2, plunger_tube_diameter/2);
    cylinder(plunger_lip_height, plunger_lip_diameter/2, plunger_lip_diameter/2);
    //then square off the tubes so we have the path of object going into the holder
    translate([-plunger_tube_diameter/2,0,0]){
        cube([plunger_tube_diameter,plunger_tube_diameter,plunger_nominal_height]);
    }
    translate([-plunger_lip_diameter/2,0,0]){
        cube([plunger_lip_diameter,plunger_lip_diameter,plunger_lip_height]);
    }

} //end difference

bevel_diameter = 15;
//TODO this is fucked.
translate([plunger_lip_diameter/2+finger_width+back_additional_side,-plunger_lip_diameter/2-0.5,bevel_diameter/2+plunger_lip_height+finger_height]){
    rotate([180,0,0]){
        rotate([0,-90,0]){
            difference(){
                cube([bevel_diameter/2,bevel_diameter/2,plunger_lip_diameter+finger_width*2+back_additional_side]);
                cylinder(plunger_lip_diameter+finger_width*2+back_additional_side,bevel_diameter/2,bevel_diameter/2);
            }
        }
    }
}