//base for moon lamp


draftingFNs = 36;
renderFNs = 180;
$fn = draftingFNs;

baseHeight = 12;

//translate([26,4,20]){
//    import("/tank/projects/3d-printing/new-files/lampShade-base.stl");
//}

difference(){
    //outer wall
    cylinder(baseHeight,82/2,82/2);
    //remore inner void
    cylinder(baseHeight,76/2,76/2);
    
    //TODO check dimensions of printed object, make shorter? move lower? deeper?
    //remove screw lip/torus
    translate([0,0,7]){
        rotate_extrude(){
            translate([42,0,0]){
                circle(baseHeight/2/2);
            }
        }
    }
}


//TODO make cavity for metal ring - below screw lip? so then that part can't deform (as easily)?
        