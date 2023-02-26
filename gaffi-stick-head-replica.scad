//gaffi stick head replica
//all in mm because.

use <dotSCAD/path_extrude.scad>
use <dotSCAD/shape_circle.scad>
use <dotSCAD/util/flat.scad>
use <dotSCAD/arc_path.scad>
use <dotSCAD/util/reverse.scad>



rough_preview_fns = 30;
render_fns = 180;

$fn = render_fns;


/* ---------------------------------------------\
|                                               |
|     Define dimensions of staff connector      |
|                                               |
\--------------------------------------------- */

spike_length = 76;
spike_final_radius = 4;    
spike_final_length = 10; 


height_staff_head_connector = 126;

circle12 = shape_circle(radius = 25/2);
circle15 = shape_circle(radius = 15);
circle18 = shape_circle(radius = 18);

staff_start_diameter = 25;
staff_connector_start_circle = shape_circle(radius = staff_start_diameter/2);
staff_end_size_ratio = 1.6;


/* ---------------------------------------\
|                                         |
|     Define dimensions of ellipsoid      |
|                                         |
\--------------------------------------- */

Main_Head_Diameter_X = 100; //roughly 4 inches
//Main_Head_Diameter_Y = 100; //not dealing with this extra math right now.
Main_Head_Diameter_Y = Main_Head_Diameter_X;
Main_Head_Height_Z = 45;

Depth_Of_Chisel_Path = 5;
Upper_Angle_Of_Chisel = 30;
Lower_Angle_Of_Chisel = 30;
Additional_Squared_Off_Depth_After_Chisel_Cut = 0;
Vertical_Distance_Between_Chisel_Cuts = 3; //'vertical' being going up the y axis, ie a rotation around the x, ie the ridges going around the longer part of ellipsoid, the horizontal bands). this is the pythag (straight line) distance between one ridge's upper edge and the next's lower edge, not the length of the arc between the two.
Horizontal_Distance_Between_Chisel_Cuts = 3; //'horizontal' being going around the z axis, ie the ridges going around the shorter part of ellipsoid, the vertical bands).  this is the pythag (straight line) distance between one ridge's upper edge and the next's lower edge, not the length of the arc between the two.


Diameter_of_Material_to_Remove_Inside_Ridged_Surface_on_Outside_of_Head = 114;
Diameter_of_Material_to_Remove_Inside_Ridged_Surface_on_Inside_of_Head = 117;
Remove_Platform_Material_From_Inside_of_Head = true;
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
      
path_arc_staff_to_ellipsoid_temp1 = arc_path(radius = 12.5*3/2*1.2, angle = [70, 159]);
path_arc_staff_to_ellipsoid_temp2 = reverse(path_arc_staff_to_ellipsoid_temp1);

path_arc_staff_to_ellipsoid = [   
for (t = path_arc_staff_to_ellipsoid_temp2)
    [t.x + (12.5*3/2)*2 + (height_staff_head_connector/(height_staff_head_connector/3))*(height_staff_head_connector/(height_staff_head_connector/5)) - 15.7, 0 , t.y + height_staff_head_connector-5]
];

path_staff_and_bend_temp = [
    [
    for(i = [0:height_staff_head_connector]) 
        if (i <= height_staff_head_connector)
            [(i/(height_staff_head_connector/3))*(i/(height_staff_head_connector/5)), 0, i]
    ]
        , path_arc_staff_to_ellipsoid
];
path_staff_and_bend = flat(path_staff_and_bend_temp);
        

difference(){
    union(){
        path_extrude(staff_connector_start_circle, path_staff_and_bend,scale = staff_end_size_ratio, method = "EULER_ANGLE"); 
       
    
        translate(path_staff_and_bend[len(path_staff_and_bend)-1]){
            rotate([0,-71,0]){
                translate([0,0,-spike_length]){
                    cylinder(spike_length,spike_final_radius,(staff_start_diameter/2*staff_end_size_ratio));
                    
                    translate([0,0,-spike_final_length]){
                        cylinder(spike_final_length,spike_final_radius,spike_final_radius);
                    }
                }
            }
        }

    
    } //end union

    translate([0,0,-1]){
        rotate([0,3,0]){
            cylinder(75,25.4/2,25.4/2);
        }
    }
}//end difference




/* ------------------------\
|                          |
|      Make ellipsoid      |
|                          |
\------------------------ */

//shift_x = 20;
shift_x = Main_Head_Height_Z/2;
translation_amount = 
    let(p = path_staff_and_bend[len(path_staff_and_bend)-1])
        [p.x+shift_x,p.y,p.z - (90-60)/90*shift_x];

//        echo(path_staff_and_bend[len(path_staff_and_bend)-1]);
//        echo(translation_amount);

translate(translation_amount){
    rotate([0,-71,0]){
        
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
    
    if (Remove_Platform_Material_From_Outside_of_Head){
        cylinder(h = Ridge_Head_Height_Z+1, r2 = Diameter_of_Material_to_Remove_Inside_Ridged_Surface_on_Outside_of_Head/2, r1 = 1, center = false); //the +1 is so surfaces cut clean through and i don't get random cgal errors :-/
    }
    
    if (Remove_Platform_Material_From_Inside_of_Head){
        translate([0, 0, -(Ridge_Head_Height_Z+1)]){
            cylinder(h = Ridge_Head_Height_Z+1, r1 = Diameter_of_Material_to_Remove_Inside_Ridged_Surface_on_Inside_of_Head/2, r2=1, center = false); //the +1 is so surfaces cut clean through and i don't get random cgal errors :-/
        }
    }
    
    
    //for ref: module makeCircularChiselPath(chiselUpperAngle, chiselLowerAngle, chiselDepth, chiselExtraSquaredDepth, rotationAboutYaxis, rotationAboutZaxis, radiusOfChiselPointPath){
    
    for (q = [0:9:180]){
        rotate([q,90,0]){
            makeCircularChiselPath(Upper_Angle_Of_Chisel, Lower_Angle_Of_Chisel, Depth_Of_Chisel_Path, Additional_Squared_Off_Depth_After_Chisel_Cut, 0, 360, Main_Head_Diameter_X/2);
        }
    }
    
    makeCircularChiselPath(Upper_Angle_Of_Chisel, Lower_Angle_Of_Chisel, Depth_Of_Chisel_Path, Additional_Squared_Off_Depth_After_Chisel_Cut, 0, 360, Main_Head_Diameter_X/2);
    
    //use Vertical_Distance_Between_Chisel_Cuts to calc placememt of next ridge
    
    a=Main_Head_Diameter_X/2 + 5;
    b=Main_Head_Diameter_X/2 + 5;
    
//       rotationAngles = [9.2, 18.4, 27.6, 36.8, -9.2, -18.4, -27.6, -36.8];
       rotationAngles = [9.2, 18.4, 27.6, 37, -9.2, -18.4, -27.6, -36.8];
    
    
    for (h = rotationAngles){
//        echo(h);
        
            heightOfChiselPath = (Main_Head_Diameter_X/2)*sin(h);
//    echo(heightOfChiselPath);
        modifiedChiselPathDiameter = (Main_Head_Diameter_X/2)*cos(h);
//    echo(modifiedChiselPathDiameter);
//    modifiedChiselPathDiameter = 40;
//    echo(modifiedChiselPathDiameter);
    translate([0,0,heightOfChiselPath]){
    //for ref: module makeCircularChiselPath(chiselUpperAngle, chiselLowerAngle, chiselDepth, chiselExtraSquaredDepth, rotationAboutYaxis, rotationAboutZaxis, radiusOfChiselPointPath){
        
        makeCircularChiselPath(Upper_Angle_Of_Chisel, Lower_Angle_Of_Chisel, Depth_Of_Chisel_Path, Additional_Squared_Off_Depth_After_Chisel_Cut, h, 360, modifiedChiselPathDiameter);
        
    }
    
    
    
    }
    
    
} //end of difference
}//end resize
}

}





module makeChiselHead(upperAngle, lowerAngle, depth, extraSquaredDepth){
    
    lengthUpperSubtractor = tan(upperAngle)*depth;
    lengthLowerSubtractor = tan(lowerAngle)*depth;
    renderArtifactHack = 1.2; //hack so that this extends past circle vs square differences and random render artifacts
    //make subtractor - depth being how far does chisel cut in to material, height being intersection of angled face with depth measurement
    polygon([[0, 0],[depth, lengthUpperSubtractor],[(depth+extraSquaredDepth)*renderArtifactHack, lengthUpperSubtractor],[(depth+extraSquaredDepth)*renderArtifactHack, -lengthLowerSubtractor],[depth, -lengthLowerSubtractor]]);
    
}

module makeCircularChiselPath(chiselUpperAngle, chiselLowerAngle, chiselDepth, chiselExtraSquaredDepth, rotationAboutYaxis, rotationAboutZaxis, radiusOfChiselPointPath){
    //check that ... TODO
    
    
    rotate_extrude(angle = rotationAboutZaxis, convexity = 10){
        translate([radiusOfChiselPointPath, 0, 0]){
            rotate([0, 0, rotationAboutYaxis]){ //y rotation set to z here becayse extrude rotates object around z axis
                makeChiselHead(chiselUpperAngle, chiselLowerAngle, chiselDepth, chiselExtraSquaredDepth);
            }
        }
    }
    
    
    
    
    
    
}