//desktop monitor mount
rough_preview_fns = 20;
render_fns = 60;

$fn = $preview ? rough_preview_fns : render_fns;
offset_for_preview = $preview ? 0.01 : 0;

//measurements etc

//leave room for TPU friction fit pad?

desktop_height = 35; //measured at 33 with ruler
desk_to_wall_gap_width = 15; //very rough

c_clamp_height_under_desk = 15;
c_clamp_depth_under_desk = 80;

c_clamp_height_straight_above_desk = 10;
c_clamp_width = 80;
c_clamp_side_swoop_width = 110;
c_clamp_front_swoop_depth = 70; //make height & depth equal for 1/4 circle cutout

c_clamp_monitor_front_support_depth = 10; //how much material for lip in front of monitor bottom?

monitor_cutout_depth = 22;
monitor_cutout_height = 22;
monitor_cutout_offset_depth = 10; //TODO MEASURE!! //this is how much space does curved back of monitor take up when flush against wall until the start of lip that holds monitor up from bottom

min_depth_monitor_holder = monitor_cutout_offset_depth + monitor_cutout_depth + c_clamp_monitor_front_support_depth;

//120 mm in from edge is where buttons start on monitor bottom lip

//NB: bottom of monitor is currently 158mm above the desk.
monitor_to_desk_vertical_distance = 160;

//stand_height = (c_clamp_height_under_desk + desktop_height + c_clamp_front_swoop_depth + monitor_to_desk_vertical_distance);
stand_height = (c_clamp_height_under_desk + desktop_height + monitor_to_desk_vertical_distance + monitor_cutout_height);
//stand_height = 245; //bc print bed is 250 max - but this is actually a little higher than I need.



//simplest
difference(){
    //make main body
        cube([(desk_to_wall_gap_width + c_clamp_depth_under_desk),c_clamp_width,stand_height]);

    
    //subtract area for desk
    translate([desk_to_wall_gap_width, -offset_for_preview, c_clamp_height_under_desk]){
        cube([100,100,desktop_height]);
    }
    
    //subtract area for monitor
    translate([monitor_cutout_offset_depth, -offset_for_preview, stand_height-monitor_cutout_depth]){
        cube([monitor_cutout_depth,100,monitor_cutout_height+offset_for_preview]);
    }
    
    //subtract material in front of monitor support shelf/lip
//    translate([min_depth_monitor_holder, -offset_for_preview, c_clamp_height_under_desk + desktop_height + c_clamp_front_swoop_depth]){
    translate([min_depth_monitor_holder, -offset_for_preview, c_clamp_height_under_desk]){
        cube([100,100,250]);
    }
    
}

//add in aesthetic front swoop
translate([min_depth_monitor_holder,0,(c_clamp_height_under_desk + desktop_height)]){
    difference(){
        //make main swoop material
        cube([c_clamp_front_swoop_depth,c_clamp_width,c_clamp_front_swoop_depth]);
        
        //subtract cylinder to make it a swoop
        translate([c_clamp_front_swoop_depth,-offset_for_preview,c_clamp_front_swoop_depth]){
            rotate([-90,0,0]){
                cylinder(100, c_clamp_front_swoop_depth, c_clamp_front_swoop_depth);
            }
        }
    }
}

////TPU Pad
//tpu_model_offset = c_clamp_width + 20;
//tpu_pad_height_base = 2;
//tpu_pad_bump_width = 30;
//
//translate([0, tpu_model_offset, 0]){
//    cube([c_clamp_depth_under_desk,c_clamp_width*1.2,tpu_pad_height_base]);
//}
//translate([0, tpu_model_offset + c_clamp_width/2 - tpu_pad_bump_width/2, 0]){
//    cube([c_clamp_depth_under_desk,tpu_pad_bump_width,tpu_pad_height_base*2]);
//}
//
////or rather grab on both slides and slide towards wall?