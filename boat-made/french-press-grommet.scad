//french-press-grommet
rough_render = 30;
smooooth_render = 180;
$fn = smooooth_render; //resolution of curves

//
// physical things
//
shaft_diam = 5.1; //tpu 5.3 was close but still came out a little too easy. but did have some friction to push through in general. 5.1mm was good for tpu. 5.5 woudl prob be good for pla/plastics

grommet_top_top_diam = 15.5; //measured at 14.78mm
grommet_top_neck_diam = 9.75; //measured at 
grommet_top_height = 3.6; 

grommet_neck_diam = 9.5;
grommet_neck_height = 0.0;

//grommet_bottom_top_diam = 10.5; //measured at 9.9mm //pla
grommet_bottom_top_diam = 12; //measured at 9.9mm //tpu
grommet_bottom_bottom_diam = 9.5; //measured at 
grommet_bottom_height = 2.5;
//fyi top hole is 10mm diam

// notes: 
//at 12, top_bottom_diam it does not fit thorugh. at 10mm it is too loose. 10.5 worked and looks to have enough to not slip out
// could prob decrease grommet_top_height by 0.5 or 1mm to somewhere in 2.6-3.1 range. it sits a little bit up off the lid now. but totally usable as is.
// grommet_top_height at 3.6 printed and fit fine, but had a little too much play
// grommet_top_top_diam at 16 printed and fit fine, but had a little too much play, maybe too steep a slope to sit nicely in top, so making smaller to get diff slope down to through-hole in lid


//
// model dimensions
//
cut_in_depth_into_top_cone = 0.5; //I'm not sure this rectangular cutout is actually allowing for some flex or not. 
cut_in_width_into_top_cone = 0; //set to 2 for the piece printed already. prob set this to zero for TPU so there is no cutout



difference(){
    union(){
        //grommet top
        translate([0,0,grommet_neck_height+grommet_bottom_height]){
            cylinder(grommet_top_height,grommet_top_neck_diam/2,grommet_top_top_diam/2);
        }
        
        //grommet neck
        translate([0,0,grommet_bottom_height]){
            cylinder(grommet_neck_height,grommet_top_neck_diam/2,grommet_top_neck_diam/2);
        }
        
        //grommet bottom
        cylinder(grommet_bottom_height,grommet_bottom_bottom_diam/2,grommet_bottom_top_diam/2);
    } //end union


    //shaft to difference
    cylinder(100,shaft_diam/2,shaft_diam/2);
    
    //rectangle to allow for deformation
    translate([-grommet_top_top_diam/2,-cut_in_width_into_top_cone/2,0]){
        cube([grommet_top_top_diam,cut_in_width_into_top_cone,grommet_neck_height+grommet_bottom_height+cut_in_depth_into_top_cone]);
    }
}

