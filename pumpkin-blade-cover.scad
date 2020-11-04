//pumpkin carver blade cover
//add on to https://www.thingiverse.com/thing:4637250 awesome pumpkin carver holder for jigaw blades
// thicker blades along with lots of pumpkin guts make the lock harder to remove, and I wanted a bit more safety as I exert a lot of force around a blade - so this quick and simple cover
//justin lowe 20201104

//lock for handle is 19mm inner dimension width and height.
//thick and long jigsaw blade is 1.2mm thick, 7.4mm wide, 73.4mm long

bladeLength = 74;
bladeWidth = 7.5;
bladeDepth = 1.2;

innerWidth = bladeWidth*1.2;
innerLength = bladeLength*1.2;
innerDepth = bladeDepth*1.5;

echo("innerWidth = ", innerWidth);
echo("innerLength = ", innerLength);
echo("innerDepth = ", innerDepth);

wallThickness = 3;

outerWidth = innerWidth + wallThickness*2;
outerLength = innerLength + wallThickness*2; //keep as 2x and just have double thickness end cap?
outerDepth = innerDepth + wallThickness*2;


echo("outerWidth = ", outerWidth);
echo("outerLength = ", outerLength);
echo("outerDepth = ", outerDepth);

difference(){
    translate([0,0,wallThickness]){
        cube([outerWidth,outerDepth,outerLength],true);
    }
    cube([innerWidth,innerDepth,innerLength],true);
}