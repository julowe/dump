//aeropress stand - wide free-floating base vs fletcher design
rough_render = 30;
smooooth_render = 360;
$fn = rough_render; //resolution of curves


//
// physical things
//
//aeropress
plunger_tube_diameter = 58; //measured 56.5mm. same travel size and regular.
//plunger_lip_diameter = 74; //measured 70.9mm for the travel size. huh thats a thing.
plunger_lip_diameter = 86; //measured 83.65mm
//plunger_lip_height = 4.5; //measured 3.6mm for travel size.
plunger_lip_height = 5; //did not measure normal size, just bumped up to 5mm and that was a good fit.
plunger_nominal_height = 100; //not measured, just tall enough to subtract from everything

//magnets
magnet_diam = 8.5; //measured 7.9mm
magnet_height = 2.2; //measured 1.94mm - add .4 as two layers of gap

//grippy dome feet
grippy_diam = 12; //measured 11.04mm
grippy_height = 4.5; //measured at 5.25mm

//notes
//4mm grippy height looked too shallow
//9mm magnet diam has a bit of rattle room
//8mm magnet diam was too small, but not the best test as the print stopped a layer too late.
//2.4mm magner height was good but im going to try to squeeze another .2 out of it
//2mm wall thickness around grippy got down to just 1 wall at the top of the grippy inset void. bah changed to 3mm

//
// model things
//
wall_thickness_around_magnets = 2;
wall_thickness_around_grippy = 3;
thickness_under_magnets = 0.2; //adjust to be one layer
cone_top_wall_width = 10;
//cone_bottom_wall_width = 10; 
//cone_bottom_wall_width = magnet_diam + wall_thickness_around_magnets*2; 
cone_bottom_wall_width = grippy_diam + wall_thickness_around_grippy*2; 
cone_height = 75; //just making this up, 3"

d20_height = 129.17; //FYI 129.17 is exactly right to make a nice clean point where faces meet at top of dice and the void for pluger to slide into

//
//make holder
//

difference(){
    //
    //make holder around plunger
    //
  
    //normal cone shape, I like to render final object at $fn=180 or above for smooth surface  
    cylinder(cone_height,plunger_lip_diameter/2+cone_bottom_wall_width,plunger_tube_diameter/2+cone_top_wall_width);
    
    //or comment out above and do $fn=4 to make a pyramid. or fn=3,5,8 etc to make other shapes
//    cylinder(cone_height,plunger_lip_diameter/2+cone_bottom_wall_width+25,plunger_tube_diameter/2+cone_top_wall_width+3, $fn=4); //pyramid

    //
    //start subtracting/differencing things
    //
    
    //make plunger model to subtract from things
    cylinder(plunger_nominal_height, plunger_tube_diameter/2, plunger_tube_diameter/2);
    //make plunger lip
    cylinder(plunger_lip_height, plunger_lip_diameter/2, plunger_lip_diameter/2);
    
    //then square off the tubes so we have the path of object going into the holder
    //square of plunger tube
    translate([-plunger_tube_diameter/2,0,-0.1]){
        cube([plunger_tube_diameter,plunger_tube_diameter*2,plunger_nominal_height]);
    }
    
//    //square off plunger lip. or don't! then there is a slight catch in the forward direction after you put this item down
//    translate([-plunger_lip_diameter/2,0,0]){
//        cube([plunger_lip_diameter,plunger_lip_diameter,plunger_lip_height]);
//    }
    
    //remove magnet voids (internal to model)
    for (i = [30,150,220,320]){
        rotate([0,0,i]){
            translate([plunger_lip_diameter/2+cone_bottom_wall_width/2,0,thickness_under_magnets]){
                cylinder(magnet_height, magnet_diam/2, magnet_diam/2);
            }
        }
    }
    
    //remove grippy feet insets (visible insets to place grippys in)
    for (i = [0,180,270]){
        rotate([0,0,i]){
            translate([plunger_lip_diameter/2+cone_bottom_wall_width/2,0,0]){
                cylinder(grippy_height, grippy_diam/2, grippy_diam/2);
            }
        }
    }

} //end difference

module box(size) {
    cube([2*size, 2*size, size], center = true); 
}

module dodecahedron(size) {
      dihedral = 116.565;
      intersection(){
            box(size);
            intersection_for(i=[1:5])  { 
                rotate([dihedral, 0, 360 / 5 * i])  box(size); 
           }
      }
}



