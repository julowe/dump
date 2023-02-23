//gaffi stick head
//jkl 20230222

$fn = 90;


//degree notation at 0 deg for (1,0), 90deg at (0,1)

head_sphere_radius = 80; 
head_sphere_degree_to_intersection = 45; ///please limit to 90 to 180 degress?


//main_point_sphere_radius = 78.9; //what makes the drop part
main_point_sphere_degree_to_intersection = 45; ///please limit to 270 to 360 degress?
drop_curve_angle_provided = true;

point_rounding_radius = 2.5;

///coool i messed up something and only 45 deg works righ tnow...

//main_point_tip_radius = 5;
//main_point_length = 25;
//main_sphere_radius = 60;
//point_intersection_height_scaling_factor = 1;
//point_intersection_height_adjustment = 0;
//
//intersect_height = (main_sphere_radius) * 1/2; //at what height above the center of the sphere does the bottom of the torus intersect with the sphere
//
//
////stuff to make below a little cleaner
//main_point_circle_radius = (main_sphere_radius - main_point_tip_radius);








//given radius of actaul head/main body of drop and angle that the droppy/pointy part meets the head, and (angle of incidence relative to droppy constructor OR that said anglle is complementary to main body angle) then calc other things

if (drop_curve_angle_provided){
//    main_point_sphere_radius = (cos(head_sphere_degree_to_intersection)*head_sphere_radius)/2 + pow(((2*(cos(head_sphere_degree_to_intersection)*head_sphere_radius))/tan(2*main_point_sphere_degree_to_intersection/4)),2)/(8*(cos(head_sphere_degree_to_intersection)*head_sphere_radius));
    makeMainPoint(head_sphere_radius, head_sphere_degree_to_intersection, main_point_sphere_degree_to_intersection, point_rounding_radius);
} else {
//    main_point_sphere_radius = (cos(head_sphere_degree_to_intersection)*head_sphere_radius)/2 + pow(((2*(cos(head_sphere_degree_to_intersection)*head_sphere_radius))/tan(2*(90-head_sphere_degree_to_intersection)/4)),2)/(8*(cos(head_sphere_degree_to_intersection)*head_sphere_radius));
    makeMainPoint(head_sphere_radius, head_sphere_degree_to_intersection, 90-head_sphere_degree_to_intersection, point_rounding_radius);
}








//translate([0, 0, -main_point_length]){
//    cylinder(main_point_length, main_sphere_diameter/2, main_sphere_diameter/2);
//}
///skew to double height of tip, using just bottom to but off parts of other object
//scale([1, 1, 1]){
//    rotate_extrude(convexity = 10, $fn = 100)
////        translate([main_point_length + main_point_tip_diameter, 0, 0])
//        translate([main_sphere_diameter/2 + main_point_tip_diameter, 0, 0])
//            circle(r = main_sphere_diameter/2 - main_point_tip_diameter/2, $fn = 100);
//}

//translate([0,0,-1]){
//circle(r = head_sphere_radius);
//}

sphere(head_sphere_radius);

donut_offset = head_sphere_radius/2+15;

        rotate_extrude(convexity = 10){
//            translate([drop_sphere_translation_x, drop_sphere_translation_y]){
            //to make the donut we just need it moved above the x axis and juuuuust barely past the y axis. placing said object is when we might need other math
            translate([donut_offset, donut_offset-25]){
                color("red")
                circle(r = head_sphere_radius/3+0);
            }  
        }




//////difference(){
////////translate([0, 0, -(main_sphere_radius + main_point_length)]){
//////translate([0, 0, -(main_sphere_radius*2)+intersect_height + main_point_tip_radius]){
//////    sphere(main_sphere_radius);
//////}
//////
//////
//////    rotate_extrude(convexity = 10){
//////        translate([main_point_circle_radius + main_point_tip_radius, 0, 0]){
//////            circle(r = main_point_circle_radius);
//////        }
//////    }
//////}
        
//        i = 0;
        
        for (i = [0:15:350]){
        rotate([53,0,i]){
        translate([0,0,84]){
            rotate([-20,0,0]){
makeSecondaryPoint(20,50,1,1);
            }
        }
    } 
//}

        rotate([66,0,i]){
        translate([0,0,86]){
            rotate([7,0,0]){
makeSecondaryPoint(20,50,1,1);
            }
        }
    } 
}

module makeSecondaryPoint(point_height, subtractor_donut_radius, skew_factor, point_clip_radius){
    
    subtractor_donut_radius = subtractor_donut_radius;
    
        chord_length_for_point_rounding = 2*sqrt(2*subtractor_donut_radius*point_clip_radius - pow(point_clip_radius, 2));
    
//    echo(chord_length_for_point_rounding);
    
    degree_to_bottom_of_point_rounding_subtractor = atan((2*point_clip_radius)/chord_length_for_point_rounding)*4/2; //divide by two at the end to get half the angle of chord, so can find y offset
    
//    echo(degree_to_bottom_of_point_rounding_subtractor);
    
    y_offset_from_center_height_of_torus_for_point_truncator = sin(degree_to_bottom_of_point_rounding_subtractor)*subtractor_donut_radius;
    echo("secondary point");
    echo(y_offset_from_center_height_of_torus_for_point_truncator);
    
    translate([0,0,-(subtractor_donut_radius-point_height-y_offset_from_center_height_of_torus_for_point_truncator+point_clip_radius)]){
        difference(){
        h=subtractor_donut_radius;
        w=subtractor_donut_radius;
        
        translate([0, 0, 0]){
            cylinder(h, w, w);
        }
        
        rotate_extrude(convexity = 10){
//            translate([drop_sphere_translation_x, drop_sphere_translation_y]){
            //to make the donut we just need it moved above the x axis and juuuuust barely past the y axis. placing said object is when we might need other math
            translate([subtractor_donut_radius+0.0001, subtractor_donut_radius]){
                color("red")
                circle(r = subtractor_donut_radius);
            }  
        }
        
        //remove pointy tip
        translate([0, 0, subtractor_donut_radius-y_offset_from_center_height_of_torus_for_point_truncator]){
            cylinder(h, w, w);
        }
        //remove excess bottom curve
        translate([0, 0, 0]){
            cylinder(h-point_height-y_offset_from_center_height_of_torus_for_point_truncator+point_clip_radius, w, w);
        }

    }
    
        translate([0,0,subtractor_donut_radius-y_offset_from_center_height_of_torus_for_point_truncator]){
        sphere(point_clip_radius);
    }
}
    
}

//https://en.wikipedia.org/wiki/Circular_segment

module makeMainPoint(radius_of_main_body, degree_of_incidence_wrt_main_body, degree_of_incidence_wrt_drop_subtractor, radius_of_point_truncation){
    
    drop_subtractor_sphere_radius = (cos(degree_of_incidence_wrt_main_body)*radius_of_main_body)/2 + pow(((2*(cos(degree_of_incidence_wrt_main_body)*radius_of_main_body))/tan(2*degree_of_incidence_wrt_drop_subtractor/4)),2)/(8*(cos(degree_of_incidence_wrt_main_body)*radius_of_main_body));
    
    drop_sphere_translation_x = radius_of_main_body*cos(degree_of_incidence_wrt_main_body) - drop_subtractor_sphere_radius*-cos(degree_of_incidence_wrt_main_body); 

    drop_sphere_translation_y = radius_of_main_body*sin(degree_of_incidence_wrt_main_body) - drop_subtractor_sphere_radius*-sin(degree_of_incidence_wrt_main_body);
    
    chord_length_for_point_rounding = 2*sqrt(2*drop_subtractor_sphere_radius*radius_of_point_truncation - pow(radius_of_point_truncation, 2));
    
    echo(chord_length_for_point_rounding);
    
    degree_to_bottom_of_point_rounding_subtractor = atan((2*radius_of_point_truncation)/chord_length_for_point_rounding)*4/2; //divide by two at the end to get half the angle of chord, so can find y offset
    
    echo(degree_to_bottom_of_point_rounding_subtractor);
    
    y_offset_from_center_height_of_torus_for_point_truncator = sin(degree_to_bottom_of_point_rounding_subtractor)*drop_subtractor_sphere_radius;
    echo(y_offset_from_center_height_of_torus_for_point_truncator);
    
    difference(){
        h=abs(drop_subtractor_sphere_radius*sin(degree_of_incidence_wrt_drop_subtractor));
        w=abs(radius_of_main_body*cos(degree_of_incidence_wrt_main_body));
        
        translate([0, 0, radius_of_main_body*sin(degree_of_incidence_wrt_main_body)]){
            cylinder(h, w, w);
        }
        
        rotate_extrude(convexity = 10, $fn = 100){
//            translate([drop_sphere_translation_x, drop_sphere_translation_y]){
            //to make the donut we just need it moved above the x axis and juuuuust barely past the y axis. placing said object is when we might need other math
            translate([drop_subtractor_sphere_radius+0.0001, drop_subtractor_sphere_radius]){
                color("red")
                circle(r = drop_subtractor_sphere_radius);
            }  
        }
        echo(drop_subtractor_sphere_radius);
        echo(drop_sphere_translation_y);
        
        translate([0, 0, drop_sphere_translation_y-y_offset_from_center_height_of_torus_for_point_truncator]){
            cylinder(h, w, w);
        }

    }
    
    translate([0,0,drop_sphere_translation_y-y_offset_from_center_height_of_torus_for_point_truncator]){
        sphere(radius_of_point_truncation);
    }
//            translate([0, 0, drop_sphere_translation_y-y_offset_from_center_height_of_torus_for_point_truncator]){
//            cylinder(10, 10, 10);
//        }
        
//                rotate_extrude(convexity = 10, $fn = 100){
////            translate([drop_sphere_translation_x, drop_sphere_translation_y]){
//            //to make the donut we just need it moved above the x axis and juuuuust barely past the y axis. placing said object is when we might need other math
//            translate([drop_subtractor_sphere_radius+0.0001, drop_subtractor_sphere_radius]){
//                color("red")
//                circle(r = drop_subtractor_sphere_radius);
//            }  
//        }
        
        
        
        
    
    
//            h=abs(drop_subtractor_sphere_radius*sin(degree_of_incidence_wrt_drop_subtractor));
//        w=abs(radius_of_main_body*cos(degree_of_incidence_wrt_main_body)); //w=x
//        translate([main_sphere_translation_x, main_sphere_translation_y, 10]){
//        translate([radius_of_main_body*cos(degree_of_incidence_wrt_drop_subtractor), drop_subtractor_sphere_radius*sin(degree_of_incidence_wrt_drop_subtractor), 10]){
//        translate([0, radius_of_main_body*sin(degree_of_incidence_wrt_main_body), 10]){
////            circle(r = main_sphere_radius);
//            color("blue")
//            square([w,h], center=false);
//        }
        
        
}












/*

//second attempt allowed for both spheres to be moved around. maybe useful?

//degree notation at 0 deg for (1,0), 90deg at (0,1)

main_sphere_radius = 10; 
main_sphere_degree_to_intersection = 135; ///please limit to 90 to 180 degress?

main_point_sphere_radius = 20; //what makes the drop part
main_point_sphere_degree_to_intersection = 315; ///please limit to 270 to 360 degress?



main_sphere_translation_x = main_point_sphere_radius*cos(main_point_sphere_degree_to_intersection) - main_sphere_radius*cos(main_sphere_degree_to_intersection); //main sphere usually 45 deg off of drop sphere?

main_sphere_translation_y = main_point_sphere_radius*sin(main_point_sphere_degree_to_intersection) - main_sphere_radius*sin(main_sphere_degree_to_intersection);

//main sphere
//    rotate_extrude(convexity = 10){
        translate([main_sphere_translation_x, main_sphere_translation_y, 0]){
            circle(r = main_sphere_radius);
        }
//    }
    
    
//drop sphere
//        rotate_extrude(convexity = 10){
        translate([0, 0, 0]){
            circle(r = main_point_sphere_radius);
        }
//    }
        h=abs(main_point_sphere_radius*sin(main_point_sphere_degree_to_intersection));
        w=abs(main_sphere_radius*cos(main_sphere_degree_to_intersection)); //w=x
//        translate([main_sphere_translation_x, main_sphere_translation_y, 10]){
        translate([main_point_sphere_radius*cos(main_point_sphere_degree_to_intersection), main_point_sphere_radius*sin(main_point_sphere_degree_to_intersection), 10]){
//            circle(r = main_sphere_radius);
            color("blue")
            square([w,h], center=false);
        }
*/