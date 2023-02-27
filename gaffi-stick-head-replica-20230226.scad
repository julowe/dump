//gaffi stick head replica
//all in mm because.

use <dotSCAD/path_extrude.scad>
use <dotSCAD/shape_circle.scad>
use <dotSCAD/util/flat.scad>
use <dotSCAD/arc_path.scad>
use <dotSCAD/util/reverse.scad>


use <dotSCAD/polyline3d.scad>
use <dotSCAD/polyline2d.scad>


rough_preview_fns = 80;
render_fns = 180;

//$fn = render_fns;
$fn = $preview ? rough_preview_fns : render_fns;

/* ---------------------------------------------\
|                                               |
|     Define dimensions of staff connector      |
|                                               |
\--------------------------------------------- */

spike_length = 76;
spike_final_radius = 4;    
spike_final_length = 10; 


//height_staff_head_connector = 150;
height_staff_head_connector = 100;
//void_for_staff_height = 100;
void_for_staff_height = 75;

circle12 = shape_circle(radius = 25/2);
circle15 = shape_circle(radius = 15);
circle18 = shape_circle(radius = 18);

staff_actual_diameter = 25.4;
staff_start_diameter = 30;
staff_transition_ring_height = 6;
staff_connector_start_circle = shape_circle(radius = staff_start_diameter/2);
staff_end_size_ratio = 1.6;
staff_Straight_end_diameter = staff_start_diameter*(staff_end_size_ratio-0.06);
staff_connector_end_circle = shape_circle(radius = staff_Straight_end_diameter/2);
staff_to_head_bend_ellipse_ratio = 1.7;

spike_rotation_angle = -72;


/* ---------------------------------------\
|                                         |
|     Define dimensions of ellipsoid      |
|                                         |
\--------------------------------------- */

Main_Head_Diameter_X = 100; //roughly 4 inches
//Main_Head_Diameter_Y = 100; //not dealing with this extra math right now.
Main_Head_Diameter_Y = Main_Head_Diameter_X;
Main_Head_Height_Z = 35;

Depth_Of_Chisel_Path = 4;
Upper_Angle_Of_Chisel = 30;
Lower_Angle_Of_Chisel = 30;
Additional_Squared_Off_Depth_After_Chisel_Cut = 0;
Vertical_Distance_Between_Chisel_Cuts = 3; //'vertical' being going up the y axis, ie a rotation around the x, ie the ridges going around the longer part of ellipsoid, the horizontal bands). this is the pythag (straight line) distance between one ridge's upper edge and the next's lower edge, not the length of the arc between the two.
Horizontal_Distance_Between_Chisel_Cuts = 3; //'horizontal' being going around the z axis, ie the ridges going around the shorter part of ellipsoid, the vertical bands).  this is the pythag (straight line) distance between one ridge's upper edge and the next's lower edge, not the length of the arc between the two.


Diameter_of_Material_to_Remove_Inside_Ridged_Surface_on_Outside_of_Head = 85;
Diameter_of_Material_to_Remove_Inside_Ridged_Surface_on_Inside_of_Head = 117;
Remove_Platform_Material_From_Inside_of_Head = false;
Remove_Platform_Material_From_Outside_of_Head = true;


/* ------------------------------\
|                                |
|      Don't touch. Math.        |
|                                |
\------------------------------ */

Ridge_Head_Diameter_X = 100 + (Depth_Of_Chisel_Path+Additional_Squared_Off_Depth_After_Chisel_Cut)*2; //roughly 4 inches
//Ridge_Head_Diameter_Y = 100 + Depth_Of_Chisel_Path*2; //not dealing with this extra math right now.
Ridge_Head_Diameter_Y = Ridge_Head_Diameter_X;
Ridge_Head_Height_Z = 45 + (Depth_Of_Chisel_Path+Additional_Squared_Off_Depth_After_Chisel_Cut)*2;


/* ------------------------------\
|                                |
|      Make staff connector      |
|                                |
\------------------------------ */
      
      
//TODO why 1.2??  why angles?
//path_arc_staff_to_ellipsoid_temp1 = arc_path(radius = staff_start_diameter/2*3/2*1.2, angle = [70, 163]);

//make staff bottom path
path_staff_and_bend_temp1 = [
    
    for(i = [0:height_staff_head_connector]) 
        if (i <= height_staff_head_connector)
            [(i/(height_staff_head_connector/3))*(i/(height_staff_head_connector/5)), 0, i]
    
];
echo(path_staff_and_bend_temp1);
path_staff_and_bend_temp1_end = path_staff_and_bend_temp1[len(path_staff_and_bend_temp1)-1];
echo("path_staff_and_bend_temp1_end");
echo(path_staff_and_bend_temp1_end);

//make circular arc path of points in 2 dimensions
path_ellipse_staff_to_ellipsoid_tempA = arc_path(radius = staff_Straight_end_diameter/2*2.2, angle = [90, 180]);

    echo(path_ellipse_staff_to_ellipsoid_tempA);
        
        
//change directions of path just for my mind
path_ellipse_staff_to_ellipsoid_tempB = reverse(path_ellipse_staff_to_ellipsoid_tempA);
    echo(path_ellipse_staff_to_ellipsoid_tempB);
        
//polyline2d(
//    path_ellipse_staff_to_ellipsoid_tempB, 
//    width = 1,
//    $fn = 24
//);

//use <dotSCAD/ptf/ptf_rotate.scad>
//path_ellipse_staff_to_ellipsoid_tempB_rotated = [
//    for (i = path_ellipse_staff_to_ellipsoid_tempB)
//
//        
////    for (j = [0:len(path_ellipse_staff_to_ellipsoid_tempA)-1])
////    for(p = points_circle3d) 
//        ptf_rotate(i,[0,0,-16.9])
//    
//    ];
    


//     echo("what");
//    echo(path_ellipse_staff_to_ellipsoid_tempB_rotated);
//path_ellipse_staff_to_ellipsoid_tempB_rotated_start = path_ellipse_staff_to_ellipsoid_tempB_rotated[0];
//echo(path_ellipse_staff_to_ellipsoid_tempB_rotated_start);
//    
//    echo("path_ellipse_staff_to_ellipsoid_translation");
//    path_ellipse_staff_to_ellipsoid_translation = -path_ellipse_staff_to_ellipsoid_tempB_rotated_start.x + path_staff_and_bend_temp1_end.x;
//    
//    echo(path_ellipse_staff_to_ellipsoid_translation);
    
    

//     echo("what");
//    echo(path_ellipse_staff_to_ellipsoid_tempB);
//path_ellipse_staff_to_ellipsoid_tempB_start = path_ellipse_staff_to_ellipsoid_tempB[0];
//echo(path_ellipse_staff_to_ellipsoid_tempB_start);
//    
//    echo("path_ellipse_staff_to_ellipsoid_translation");
//    path_ellipse_staff_to_ellipsoid_translation = -path_ellipse_staff_to_ellipsoid_tempB_start.x + path_staff_and_bend_temp1_end.x;
//    
//    echo(path_ellipse_staff_to_ellipsoid_translation);
    
    
    

//path_ellipse_staff_to_ellipsoid_tempC = [   
//for (t = path_ellipse_staff_to_ellipsoid_tempB)
//    [t.x + path_ellipse_staff_to_ellipsoid_translation , 0, t.y*staff_to_head_bend_ellipse_ratio + path_staff_and_bend_temp1_end.z]
//];

path_ellipse_staff_to_ellipsoid_tempC = [   
for (t = path_ellipse_staff_to_ellipsoid_tempB)
    [t.x, 0, t.y*staff_to_head_bend_ellipse_ratio]
];
echo("path_ellipse_staff_to_ellipsoid_tempC");
echo(path_ellipse_staff_to_ellipsoid_tempC);
echo(path_ellipse_staff_to_ellipsoid_tempC[0]);





use <dotSCAD/ptf/ptf_rotate.scad>
path_ellipse_staff_to_ellipsoid_tempC_rotated = [
    for (i = path_ellipse_staff_to_ellipsoid_tempC)

        
//    for (j = [0:len(path_ellipse_staff_to_ellipsoid_tempA)-1])
//    for(p = points_circle3d) 
        ptf_rotate(i,[0,17,0])
    
    ];
    
    
    



     echo("what");
    echo(path_ellipse_staff_to_ellipsoid_tempC_rotated);
path_ellipse_staff_to_ellipsoid_tempC_rotated_start = path_ellipse_staff_to_ellipsoid_tempC_rotated[0];
echo("path_ellipse_staff_to_ellipsoid_tempC_rotated_start");
echo(path_ellipse_staff_to_ellipsoid_tempC_rotated_start);
    
    echo("path_ellipse_staff_to_ellipsoid_translation");
    path_ellipse_staff_to_ellipsoid_translation = -path_ellipse_staff_to_ellipsoid_tempC_rotated_start + path_staff_and_bend_temp1_end;
    
    echo(path_ellipse_staff_to_ellipsoid_translation);
    

path_ellipse_staff_to_ellipsoid_tempC_rotated_translated = [   
for (t = path_ellipse_staff_to_ellipsoid_tempC_rotated)
    [t.x + path_ellipse_staff_to_ellipsoid_translation.x , 0, t.z+ path_ellipse_staff_to_ellipsoid_translation.z]
];

echo("path_ellipse_staff_to_ellipsoid_tempC_rotated_translated");
echo(path_ellipse_staff_to_ellipsoid_tempC_rotated_translated);

    
use <dotSCAD/util/slice.scad>
path_ellipse_staff_to_ellipsoid_tempC_rotated_translated_sliced = slice(path_ellipse_staff_to_ellipsoid_tempC_rotated_translated,1);
echo("path_ellipse_staff_to_ellipsoid_tempC_rotated_translated_sliced");
echo(path_ellipse_staff_to_ellipsoid_tempC_rotated_translated_sliced);
    
    
    
//        translate([0,-0,0]){
//    color("red"){
//    path_extrude(staff_connector_end_circle*1.01, path_ellipse_staff_to_ellipsoid_tempC_rotated_translated_sliced,scale = 1.0, method = "AXIS_ANGLE");
//    }
//}


//     echo("what");
//    echo(path_ellipse_staff_to_ellipsoid_tempB_rotated);
//path_ellipse_staff_to_ellipsoid_tempB_rotated_end = path_ellipse_staff_to_ellipsoid_tempB_rotated[len(path_ellipse_staff_to_ellipsoid_tempB_rotated)-1];
//echo(path_ellipse_staff_to_ellipsoid_tempB_rotated_end);
//    
//    echo("path_ellipse_staff_to_ellipsoid_translation");
//    path_ellipse_staff_to_ellipsoid_translation = -path_ellipse_staff_to_ellipsoid_tempB_rotated_end.x + path_staff_and_bend_temp1_end.x;
//    
//    echo(path_ellipse_staff_to_ellipsoid_translation);

////echo(path_ellipse_staff_to_ellipsoid_tempA);
////polyline2d(
////    path_ellipse_staff_to_ellipsoid_tempA, 
////    width = 1,
////    $fn = 24
////);


//path_arc_staff_to_ellipsoid = [   
//for (t = path_arc_staff_to_ellipsoid_temp2)
//    [t.x + (staff_start_diameter/2*3/2)*2 + (height_staff_head_connector/(height_staff_head_connector/3))*(height_staff_head_connector/(height_staff_head_connector/5)) - 15.7, 0 , t.y + height_staff_head_connector-5]
//];


//skew circular path into elllipse and rotate it by making z=y and y =0
//path_ellipse_staff_to_ellipsoid_tempB = [   
//for (t = path_ellipse_staff_to_ellipsoid_tempA_rotated)
//    [t.x + (staff_start_diameter/2*3/2)*2 + (height_staff_head_connector/(height_staff_head_connector/3))*(height_staff_head_connector/(height_staff_head_connector/5)) + 3.8 , 0, t.y*staff_to_head_bend_ellipse_ratio + height_staff_head_connector-24]
////];
//path_ellipse_staff_to_ellipsoid_tempC = [   
//for (t = path_ellipse_staff_to_ellipsoid_tempB_rotated)
//    [t.x - path_ellipse_staff_to_ellipsoid_tempB_rotated_end.x , 0, t.y*staff_to_head_bend_ellipse_ratio + path_staff_and_bend_temp1_end.z]
//];
////echo(path_ellipse_staff_to_ellipsoid_tempB);

////////change directions of path just for my mind
//path_ellipse_staff_to_ellipsoid_tempC = reverse(path_ellipse_staff_to_ellipsoid_tempB);


//test draw path
//polyline3d(
//    path_ellipse_staff_to_ellipsoid_tempC, 
//    diameter = 1,
//    $fn = 24
//);


//////path_ellipse_staff_to_ellipsoid_tempB = [
//////    [
//////    for(i = [0:height_staff_head_connector]) 
//////        if (i <= height_staff_head_connector)
//////            [(i/(height_staff_head_connector/3))*(i/(height_staff_head_connector/5)), 0, i]
//////    ]
//////        , path_arc_staff_to_ellipsoid
//////];

//translate([0,-0,0]){
//    color("red"){
//    path_extrude(staff_connector_end_circle*1.01, path_ellipse_staff_to_ellipsoid_tempC_sliced_rotated,scale = 1.0, method = "AXIS_ANGLE");
//    }
//}










//path_arc_staff_to_ellipsoid_temp2 = reverse(path_arc_staff_to_ellipsoid_temp1);

//path_arc_staff_to_ellipsoid = [   
//for (t = path_arc_staff_to_ellipsoid_temp2)
//    [t.x + (staff_start_diameter/2*3/2)*2 + (height_staff_head_connector/(height_staff_head_connector/3))*(height_staff_head_connector/(height_staff_head_connector/5)) - 15.7, 0 , t.y + height_staff_head_connector-5]
//];
//
//echo(path_arc_staff_to_ellipsoid);

//translate([0,10,0]){
//    color("green")
//    path_extrude(staff_connector_start_circle*(staff_end_size_ratio-0.1), path_arc_staff_to_ellipsoid,scale = 1.1, method = "EULER_ANGLE");
//}


path_staff_and_bend_temp = [
    [
    for(i = [0:height_staff_head_connector]) 
        if (i <= height_staff_head_connector)
            [(i/(height_staff_head_connector/3))*(i/(height_staff_head_connector/5)), 0, i]
    ]
        , path_ellipse_staff_to_ellipsoid_tempC_rotated_translated_sliced
];
path_staff_and_bend = flat(path_staff_and_bend_temp);
        
    union(){ 
        
difference(){
    union(){

        translate([0,0,-(staff_transition_ring_height-0.0)]){
            cylinder(staff_transition_ring_height, staff_actual_diameter/2, staff_start_diameter/2);
        }
        
        path_extrude(staff_connector_start_circle, path_staff_and_bend,scale = staff_end_size_ratio, method = "AXIS_ANGLE"); //AXIS_ANGLE   EULER_ANGLE
    } //end union to make shaft connection
    
        //AXIS_ANGLE   EULER_ANGLE
    
           //make end of staff curve uniform
    translate(path_staff_and_bend[len(path_staff_and_bend)-1]){
//        rotate([0,126,0]){
        rotate([0,spike_rotation_angle,0]){
            translate([0,0,-3]){
            cylinder(5,(staff_start_diameter*staff_end_size_ratio)*1.2/2,(staff_start_diameter*staff_end_size_ratio)*1.2/2);
            }
        }
    }
    
    translate([0,0,-(staff_transition_ring_height+1)]){
        rotate([0,3,0]){
            cylinder(void_for_staff_height+staff_transition_ring_height,staff_actual_diameter/2,staff_actual_diameter/2);
        }
    }
}//end difference

        translate(path_staff_and_bend[len(path_staff_and_bend)-1]){
            rotate([0,spike_rotation_angle,0]){
                translate([0,0,-(spike_length-5+3)]){
                    cylinder(spike_length,spike_final_radius,(staff_start_diameter/2*staff_end_size_ratio));
                    
                    translate([0,0,-spike_final_length]){
                        cylinder(spike_final_length,spike_final_radius,spike_final_radius);
                    }
                }
            }
        } //end translation for spike

    
    } //end union
    


    
//    translate(path_staff_and_bend[len(path_staff_and_bend)-1]){
////        rotate([0,126,0]){
//        rotate([0,-55,0]){
//            translate([0,0,-3]){
//            cylinder(5,(staff_start_diameter*staff_end_size_ratio)*1.2/2,(staff_start_diameter*staff_end_size_ratio)*1.2/2);
//            }
//        }
//    }
    

//            cylinder(1,(staff_start_diameter*staff_end_size_ratio)/2,(staff_start_diameter*staff_end_size_ratio)/2);



/* ------------------------\
|                          |
|      Make ellipsoid      |
|                          |
\------------------------ */

//shift_x = 20;
shift_x = Main_Head_Height_Z/2-5;
translation_amount = 
    let(p = path_staff_and_bend[len(path_staff_and_bend)-1])
        [p.x+shift_x,p.y,p.z - (90-60)/90*shift_x];

//        echo(path_staff_and_bend[len(path_staff_and_bend)-1]);
//        echo(translation_amount);

translate(translation_amount){
    rotate([0,spike_rotation_angle,0]){
        
resize([Main_Head_Diameter_X, Main_Head_Diameter_Y, Main_Head_Height_Z]){
//scale([1, 1, 1]){
//make main inner part of main head (does not get altered by chisel)
//resize([Main_Head_Diameter_X, Main_Head_Diameter_Y, Main_Head_Height_Z]){
    sphere(Main_Head_Diameter_X/2);
//}


//Make chiseled-out surface
difference(){
    //make main outer part of main head (gets altered by chisel)
//    resize([Ridge_Head_Diameter_X, Ridge_Head_Diameter_Y, Ridge_Head_Height_Z]){
        sphere(Ridge_Head_Diameter_X/2);
//    }
    
    if (Remove_Platform_Material_From_Inside_of_Head){
        cylinder(h = Ridge_Head_Height_Z+1, r2 = Diameter_of_Material_to_Remove_Inside_Ridged_Surface_on_Inside_of_Head/2, r1 = 1, center = false); //the +1 is so surfaces cut clean through and i don't get random cgal errors :-/
    }
    
    if (Remove_Platform_Material_From_Outside_of_Head){
        translate([0, 0, -(Ridge_Head_Height_Z+1)]){
//            cylinder(h = Ridge_Head_Height_Z+1, r1 = Diameter_of_Material_to_Remove_Inside_Ridged_Surface_on_Outside_of_Head/2, r2=1, center = false); //the +1 is so surfaces cut clean through and i don't get random cgal errors :-/
            cylinder(h = Ridge_Head_Height_Z+1, r1 = 33, r2=33, center = false); //the +1 is so surfaces cut clean through and i don't get random cgal errors :-/
        }
    }
    
    
    //for ref: module makeCircularChiselPath(chiselUpperAngle, chiselLowerAngle, chiselDepth, chiselExtraSquaredDepth, rotationAboutYaxis, start, endrotationAboutZaxis, radiusOfChiselPointPath){
    
    for (q = [0:9:360]){
        rotate([q,90,0]){
            makeCircularChiselPath(Upper_Angle_Of_Chisel, Lower_Angle_Of_Chisel, Depth_Of_Chisel_Path, Additional_Squared_Off_Depth_After_Chisel_Cut, 0, 45, 134, Main_Head_Diameter_X/2);
        }
    }
    
    makeCircularChiselPath(Upper_Angle_Of_Chisel, Lower_Angle_Of_Chisel, Depth_Of_Chisel_Path, Additional_Squared_Off_Depth_After_Chisel_Cut, 0, 0, 360, Main_Head_Diameter_X/2);
    
    //use Vertical_Distance_Between_Chisel_Cuts to calc placememt of next ridge
    
    a=Main_Head_Diameter_X/2 + 5;
    b=Main_Head_Diameter_X/2 + 5;
    
       rotationAngles = [9.2, 18.4, 27.6, 36.8, -9.2, -18.4, -27.6, -36.8, -46]; //negative angles are for outside face of club head (away from shaft)
//       rotationAngles = [-9.2, -18.4, -27.6, -36.8, -46];
    Upper_AngleS_Of_Chisel = [Upper_Angle_Of_Chisel, Upper_Angle_Of_Chisel, Upper_Angle_Of_Chisel, Upper_Angle_Of_Chisel, Upper_Angle_Of_Chisel, Upper_Angle_Of_Chisel, Upper_Angle_Of_Chisel, Upper_Angle_Of_Chisel, Upper_Angle_Of_Chisel];
    Lower_AngleS_Of_Chisel = [Lower_Angle_Of_Chisel, Lower_Angle_Of_Chisel, Lower_Angle_Of_Chisel, Lower_Angle_Of_Chisel, Lower_Angle_Of_Chisel, Lower_Angle_Of_Chisel, Lower_Angle_Of_Chisel, Lower_Angle_Of_Chisel, 44];
    
    
    for (i = [0:len(rotationAngles)-1]){
//        echo(h);
        
            heightOfChiselPath = (Main_Head_Diameter_X/2)*sin(rotationAngles[i]);
//    echo(heightOfChiselPath);
        modifiedChiselPathDiameter = (Main_Head_Diameter_X/2)*cos(rotationAngles[i]);
//    echo(modifiedChiselPathDiameter);
//    modifiedChiselPathDiameter = 40;
//    echo(modifiedChiselPathDiameter);
    translate([0,0,heightOfChiselPath]){
    //for ref: module makeCircularChiselPath(chiselUpperAngle, chiselLowerAngle, chiselDepth, chiselExtraSquaredDepth, rotationAboutYaxis, start, endrotationAboutZaxis, radiusOfChiselPointPath){
        
        makeCircularChiselPath(Upper_AngleS_Of_Chisel[i], Lower_AngleS_Of_Chisel[i], Depth_Of_Chisel_Path, Additional_Squared_Off_Depth_After_Chisel_Cut, rotationAngles[i], 0, 360, modifiedChiselPathDiameter);
        
    }
    
    
    
    }
    
    
} //end of difference
}//end resize
}

}
//end ellipsoid





module makeChiselHead(upperAngle, lowerAngle, depth, extraSquaredDepth){
    
    lengthUpperSubtractor = tan(upperAngle)*depth;
    lengthLowerSubtractor = tan(lowerAngle)*depth;
    renderArtifactHack = 1.2; //hack so that this extends past circle vs square differences and random render artifacts
    //make subtractor - depth being how far does chisel cut in to material, height being intersection of angled face with depth measurement
    polygon([[0, 0],[depth, lengthUpperSubtractor],[(depth+extraSquaredDepth)*renderArtifactHack, lengthUpperSubtractor],[(depth+extraSquaredDepth)*renderArtifactHack, -lengthLowerSubtractor],[depth, -lengthLowerSubtractor]]);
    
}

module makeCircularChiselPath(chiselUpperAngle, chiselLowerAngle, chiselDepth, chiselExtraSquaredDepth, rotationAboutYaxis, startRotationAboutZaxis, endRotationAboutZaxis, radiusOfChiselPointPath){
    //check that this parameter is less than that param... TODO

    rotate([0, 0, startRotationAboutZaxis]){ //y rotation set to z here becayse extrude rotates object around z axis
        rotate_extrude(angle = endRotationAboutZaxis-startRotationAboutZaxis, convexity = 10){
            translate([radiusOfChiselPointPath, 0, 0]){
                rotate([0, 0, rotationAboutYaxis]){ //y rotation set to z here becayse extrude rotates object around z axis
                    makeChiselHead(chiselUpperAngle, chiselLowerAngle, chiselDepth, chiselExtraSquaredDepth);
                }
            }
        }
    }
}