//gaffi stick base replica
//all in mm because.


rough_preview_fns = 80;
render_fns = 180;

$fn = $preview ? rough_preview_fns : render_fns;


staff_actual_diameter = 25.4;
staff_start_diameter = 30;
staff_transition_ring_height = 6;
staff_inset_height = 75;

base_spike_fin_height = 125;
base_spike_fin_width = 37;
base_spike_fin_depth = 4;
base_spike_taper_angles = 45;
base_spike_length_after_fins = 100;

for (i = [0:120:240]){
    rotate([0,0,i]){
        translate([0,staff_start_diameter/2,0]){
            rotate([0,-90,0]){
                linear_extrude(base_spike_fin_depth) {
                    polygon([[0,0],[base_spike_fin_height,0],[base_spike_fin_height-base_spike_fin_width-10,base_spike_fin_width],[base_spike_fin_width,base_spike_fin_width]]);
                }
            }
        }
    }
}

//cylinder(staff_inset_height,staff_actual_diameter/2,staff_actual_diameter/2);



difference(){

cylinder(base_spike_fin_height,staff_start_diameter/2,staff_start_diameter/2);

cylinder(staff_inset_height,staff_actual_diameter/2,staff_actual_diameter/2);
}//end difference


translate([0,0,base_spike_fin_height]){
    cylinder(base_spike_length_after_fins,staff_start_diameter/2,2.5);
}

//polyhedron([[0,0,0],[base_spike_fin_height,0,0],[base_spike_fin_height-base_spike_fin_width-10,base_spike_fin_width,0],[base_spike_fin_width,base_spike_fin_width,0],[[0,0,base_spike_fin_depth],[base_spike_fin_height,0,base_spike_fin_depth],[base_spike_fin_height-base_spike_fin_width-10,base_spike_fin_width,base_spike_fin_depth],[base_spike_fin_width,base_spike_fin_width,base_spike_fin_depth]]);