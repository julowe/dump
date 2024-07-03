// coffee carrier insert

//TODO measure the thing

//physical things
//carrier itself
base_width = 200;
base_height = 70;
base_thickness = 3;
base_corner_radius = 10;

//coffee bits
body_height = 50;
body_diam = 30;

filter_disc_diam = 25;
filter_dics_thickness = 5;

ring_diam = 52;
ring_height = 25;



//make wider part of base
translate([0,base_corner_radius,0]){
    cube([base_width,base_height-base_corner_radius*2,base_thickness]);
}

//make taller part of base
translate([base_corner_radius,0,0]){
    cube([base_width-base_corner_radius*2,base_height,base_thickness]);
}

//make rounded corners
translate([base_corner_radius,base_corner_radius,0]){
    cylinder(base_thickness,base_corner_radius,base_corner_radius);
}
translate([base_width-base_corner_radius,base_corner_radius,0]){
    cylinder(base_thickness,base_corner_radius,base_corner_radius);
}
translate([base_width-base_corner_radius,base_height-base_corner_radius,0]){
    cylinder(base_thickness,base_corner_radius,base_corner_radius);
}
translate([base_corner_radius,base_height-base_corner_radius,0]){
    cylinder(base_thickness,base_corner_radius,base_corner_radius);
}



// objects to use as voids
translate([0,0,body_diam/2+base_thickness]){
    rotate([90,0,0]){
        cylinder(body_height,body_diam/2,body_diam/2);
    }
}
translate([0,0,filter_disc_diam/2+base_thickness]){
    rotate([90,0,0]){
        cylinder(filter_dics_thickness,filter_disc_diam/2,filter_disc_diam/2);
    }
}
translate([0,0,ring_diam/2+base_thickness]){
    rotate([90,0,0]){
        cylinder(ring_height,ring_diam/2,ring_diam/2);
    }
}
    
    
    
    
    
    
    