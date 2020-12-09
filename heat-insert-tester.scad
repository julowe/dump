//heat insert tester
//justin lowe 20201209

//this initial round of testing is for 5mm tall, 5.3mm diameter m3 screw inserts, specifically:
//uxcell a16041800ux0827 M3 x 5mm x 5.3mm Brass Cylindrical Knurled Threaded Insert

draftingFNs = 36;
renderFNs = 180;
$fn = draftingFNs;

insertHeight = 5;
insertDiameter = 5.3;
voidMedianDiameter = 5.3; //set to insert diameter to have large and smaller holes, or set to custom value to, you know, have a hole of a custom diamter as the central/starting point
voidMedianRadius = voidMedianDiameter/2;

voidBottomWall = 3; //how much material to have under the void
voidHorizontalDistance = 5; //how much space between holes - ugh set this large enough to deal with incrementing hole size (because I dont want to deal with varying translation size)
voidHorizontalWall = 3; //space between wall and edge of cube
voidVerticalPadding = 0.5; //how much higher to make hole than the insert's height

voidsBracketingNumber = 2; //how many test holes to make on the plus & minus size of starting hole
radiusIncrement = 0.1;

difference(){
    union(){
        translate([0,0,(insertHeight+voidVerticalPadding+voidBottomWall)/2]){
            cube([voidHorizontalWall+insertDiameter+(2*voidsBracketingNumber*insertDiameter)+(2*voidsBracketingNumber*radiusIncrement*2)+(2*voidsBracketingNumber*voidHorizontalDistance)+voidHorizontalWall,voidHorizontalWall+(insertDiameter+(voidsBracketingNumber*radiusIncrement))+voidHorizontalWall,insertHeight+voidVerticalPadding+voidBottomWall],true);
        }
        
        //make a - sign to signify smaller and larger diameters
        translate([-3,(voidHorizontalWall+(insertDiameter+(voidsBracketingNumber*radiusIncrement))+voidHorizontalWall)/2-1,(insertHeight+voidVerticalPadding+voidBottomWall)]){
            cube([3,1,1]);
        }
    }

    for (i=[0:voidsBracketingNumber]){
        translate([i*voidHorizontalDistance+i*voidMedianRadius*2+(i*radiusIncrement*2),0,voidBottomWall]){
            cylinder(insertHeight+voidVerticalPadding,voidMedianRadius+(i*radiusIncrement),voidMedianRadius+(i*radiusIncrement));
        }
        


        //also create negative hole if not central starting hole
        if (i > 0){ 
            translate([-i*voidHorizontalDistance-i*voidMedianRadius*2+(-i*radiusIncrement*2),0,voidBottomWall]){
                cylinder(insertHeight+voidVerticalPadding,voidMedianRadius+(-i*radiusIncrement),voidMedianRadius+(-i*radiusIncrement));
            }
        }
    }
}
