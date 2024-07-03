// monitor brace for rough seas
curvy = 180;

//TODO
// fits ok. need a little tigher on post to friction fit. 35.75? 35.5 was too tight, maybe 35.6.
//need to rotate monitor clip. frame not parallel to post. 
//also anyway, it doesn't grip it tight enough, montior frame curves at bottom. if higher friction fit might be fine?

post_diameter = 35.8; //35.45
monitor_frame_depth = 22.25; //21.8
//back of monitor aligned with back of post
post_monitor_gap = 10; //12.35

brace_height = 25;
brace_wall_width = 4;
brace_U_depth = 12;

difference(){
    hull(){
        //outer wall brace aroudn post
        cylinder(brace_height, post_diameter/2+brace_wall_width, post_diameter/2+brace_wall_width, $fn=curvy);
        
        //outer monitor part here to create nice hull
        translate([-(post_diameter/2+brace_wall_width)-(post_monitor_gap+brace_U_depth), post_diameter/2-(monitor_frame_depth+brace_wall_width*2)+brace_wall_width, 0]){
            cube([post_monitor_gap+brace_U_depth+0/2,monitor_frame_depth+brace_wall_width*2,brace_height]);
        }
    }
    //subtract post void
    cylinder(brace_height, post_diameter/2, post_diameter/2, $fn=curvy);
    //subtract monitor frame void               
    translate([-(post_diameter/2+brace_wall_width)-(post_monitor_gap+brace_U_depth)-(post_diameter/2+post_monitor_gap), post_diameter/2-(monitor_frame_depth+brace_wall_width*2)+brace_wall_width*2, 0]){
        cube([post_monitor_gap+brace_U_depth+post_diameter/2,monitor_frame_depth,brace_height]);
    }
}