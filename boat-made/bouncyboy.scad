//78.5 front rectangle width
//66.5 back rectangel width
//53.7 depth
//26 back 76 width
//64
//57.16 slider width
//3 slider sticks out

//47 width of circular monitor mount junction
//30 height of circular monitor mount junction


neck_front_width = 79;
neck_mid_width = 76;
neck_rear_width = 64;
neck_depth_at_mid_width = 26;
neck_depth = 54;

collar_full_height = 50;

slider_depth = 3.5;
slider_width = 58;

slider_junction_width = 48;
slider_junction_height = 30;

wall_thickness = 3;

//difference(){
//cube([neck_front_width+wall_thickness*2, neck_depth+wall_thickness*2, 10],center = true);
//cube([neck_front_width, neck_depth, 10],center = true);
//}

difference(){
    linear_extrude(height=collar_full_height, scale=1){
        polygon( [ [0,0], 
        [(neck_front_width-slider_width)/2,0],
        [(neck_front_width-slider_width)/2,-slider_depth], 
        [neck_front_width-(neck_front_width-slider_width)/2+wall_thickness*2,-slider_depth], 
        [neck_front_width-(neck_front_width-slider_width)/2+wall_thickness*2,0], 
        [neck_front_width+wall_thickness*2,0], 
        [neck_front_width-((neck_front_width-neck_mid_width)/2)+wall_thickness*2,neck_depth_at_mid_width], 
        [neck_front_width-((neck_front_width-neck_rear_width)/2)+wall_thickness*2,neck_depth+wall_thickness*2], 
        [((neck_front_width-neck_rear_width)/2),neck_depth+wall_thickness*2], 
        [((neck_front_width-neck_mid_width)/2),neck_depth_at_mid_width] ] );
    }

//color("green"){
    translate([wall_thickness,wall_thickness,0]){
        //inside
        linear_extrude(height=collar_full_height, scale=1){
            polygon( [ [0,0], 
            [(neck_front_width-slider_width)/2,0],
            [(neck_front_width-slider_width)/2,-slider_depth], 
            [neck_front_width-(neck_front_width-slider_width)/2,-slider_depth], 
            [neck_front_width-(neck_front_width-slider_width)/2,0], 
            [neck_front_width,0], 
            [neck_front_width-((neck_front_width-neck_mid_width)/2),neck_depth_at_mid_width], 
            [neck_front_width-((neck_front_width-neck_rear_width)/2),neck_depth], 
            [((neck_front_width-neck_rear_width)/2),neck_depth], 
            [((neck_front_width-neck_mid_width)/2),neck_depth_at_mid_width] ] );
        }
    }
//}
    translate([(neck_front_width)/2-slider_junction_width/2+wall_thickness,-slider_depth,collar_full_height-slider_junction_height]){
        cube([slider_junction_width,10,slider_junction_height]);
    }
}