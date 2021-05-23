// speaker holder for top of couch arm
//20210522 jkl

draftingFNs = 36;
renderFNs = 180;
$fn = draftingFNs;

minkRad = 1;

couchWidth = 115 + minkRad*2; //actual around 110-120mm, depending on squish of couch cushioning
holderDepth = 55;
holderBackHeight = 70; //maybe 50 coudl work, but 70 first try
//holderSideHeight = 60;

wallThickness = 3;


//speaker stand is 30mm fornt to back for support leg, 25mm side to side
speakerHoleRad = 15 + minkRad;
speakerHoleOffset = 15;

//minkowski(){
    difference(){
        //exterior walls
            cube([couchWidth+(wallThickness*2),holderDepth+wallThickness,holderBackHeight+wallThickness]);
        
        //remove interior void and front & bottom walls
        translate([wallThickness,0,0]){
            cube([couchWidth,holderDepth,holderBackHeight]);
        }
        
        //circle for speaker holder
        translate([couchWidth/2+wallThickness,holderDepth-(speakerHoleOffset+speakerHoleRad),holderBackHeight]){
            cylinder(wallThickness,speakerHoleRad+1,speakerHoleRad); //bottom slightly bigger to cinch down on stand?
        }
    }
    
    //round it all
//    sphere(minkRad);
//}

//
//linear_extrude(height = 2){
//    difference(){
//        circle(17);
//        circle(15);
//    }
//}