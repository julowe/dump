// speaker holder for top of couch arm
//20210522 jkl

draftingFNs = 9;
renderFNs = 90;
$fn = renderFNs;

minkRad = 2;

couchWidth = 115 + minkRad*2; //actual around 110-120mm, depending on squish of couch cushioning
//holderDepth = 55;
holderHeight = 40; //just the clamping/squeezing part
//holderSideHeight = 60;

wallThickness = 2;


//speaker stand is 30mm fornt to back for support leg, 25mm side to side
speakerHoleRad = 18;// + minkRad;
speakerHoleOffset = 15;


ringHolderWidth = 5;
ringHolderThickness = wallThickness;

couchBackRad = 35 + minkRad;

holderDepthAddition = 20;
holderDepth = couchBackRad + speakerHoleRad + ringHolderWidth + holderDepthAddition;

holderCornerRad = 7;

holderBevelRad = couchWidth/2-(speakerHoleRad*2+ringHolderWidth*2)/2;
//difference(){
minkowski(){
    union(){
        //form ring holder
        translate([holderBevelRad+wallThickness,holderDepthAddition,couchBackRad+holderHeight+holderBevelRad]){
            difference(){
                union(){
                    //connect ring holder to back piece
                    cube([speakerHoleRad*2+ringHolderWidth*2,speakerHoleRad+ringHolderWidth,wallThickness]);
                    
                    //outer curve of ring holder
                    translate([speakerHoleRad+ringHolderWidth,0,0]){
                        cylinder(wallThickness,speakerHoleRad+ringHolderWidth,speakerHoleRad+ringHolderWidth);
                    }
                } //end union
                //outer curve of ring holder
                translate([speakerHoleRad+ringHolderWidth,0,-minkRad]){
                    cylinder(wallThickness+minkRad*2,speakerHoleRad+minkRad,speakerHoleRad+minkRad);
                }
            } //end diff
        }// end translate & formation of ring holder
        
        //form curved connector
        translate([(couchWidth/2+wallThickness)+(speakerHoleRad*2+ringHolderWidth*2)/2,speakerHoleRad+ringHolderWidth+holderDepthAddition,holderHeight+holderBevelRad]){
            rotate([0,-90,0]){
                rotate_extrude(angle = 90){
                    translate([couchBackRad,0,0]){
                        square([wallThickness,speakerHoleRad*2+ringHolderWidth*2]);
                    }
                }
            }
        }//end translate & form curved connector
        

        
        holderBevelRadVertPad = 5; // no, use holderCornerRad
        difference(){
            union(){
            //exterior walls of holder/squeezer
                cube([couchWidth+(wallThickness*2),holderDepth+wallThickness,holderHeight]);
                
                //add material on left inside corner
                translate([wallThickness,holderDepth-holderCornerRad,holderHeight]){
                    cube([holderCornerRad,holderCornerRad,holderCornerRad]);
                }
                
                //add material on right inside corner
                translate([wallThickness+couchWidth-holderCornerRad,holderDepth-holderCornerRad,holderHeight]){
                    cube([holderCornerRad,holderCornerRad,holderCornerRad]);
                }
                
                //vertical connector to later bevel
                translate([wallThickness,holderDepth,holderHeight]){
                    cube([couchWidth,wallThickness,holderBevelRad]);
                }

//                //form vertical beveled connector
//                difference(){
//                    translate([wallThickness,holderDepth,holderHeight]){
//                        cube([couchWidth,wallThickness,holderBevelRad]);
//                    }
//                    
//                    //remove left side
//                    translate([wallThickness,holderDepth,holderBevelRad+holderHeight]){
//                        rotate([-90,0,0]){
//                            cylinder(wallThickness,holderBevelRad,holderBevelRad);
//                        }
//                    }
//                    
//                    //remove right side
//                    translate([wallThickness+holderBevelRad*2+(speakerHoleRad*2+ringHolderWidth*2),holderDepth,holderBevelRad+holderHeight]){
//                        rotate([-90,0,0]){
//                            cylinder(wallThickness,holderBevelRad,holderBevelRad);
//                        }
//                    }
//                }//end diff & form vertical beveled connector
            }
            
            //remove left side of bevel
            translate([wallThickness,holderDepth-holderCornerRad,holderBevelRad+holderHeight]){
                rotate([-90,0,0]){
                    cylinder(wallThickness+holderCornerRad,holderBevelRad,holderBevelRad);
                }
            }
            
            //remove right side of bevel
            translate([wallThickness+holderBevelRad*2+(speakerHoleRad*2+ringHolderWidth*2),holderDepth-holderCornerRad,holderBevelRad+holderHeight]){
                rotate([-90,0,0]){
                    cylinder(wallThickness+holderCornerRad,holderBevelRad,holderBevelRad);
                }
            }
                    
            //remove most of interior void and front & bottom walls
            translate([wallThickness,0,0]){
                cube([couchWidth,holderDepth-holderCornerRad,holderHeight]);
            }
            
            //remove rectangular close to holder void
            translate([wallThickness+holderCornerRad,holderDepth-holderCornerRad,0]){
                cube([couchWidth-holderCornerRad*2,holderCornerRad,holderHeight]);
            }
            
            //form left interior bevel
            translate([wallThickness+holderCornerRad,holderDepth-holderCornerRad,0]){
                cylinder(holderHeight+holderCornerRad,holderCornerRad,holderCornerRad);
            }
            
            //form right interior bevel
            translate([wallThickness+couchWidth-holderCornerRad,holderDepth-holderCornerRad,0]){
                cylinder(holderHeight+holderCornerRad,holderCornerRad,holderCornerRad);
            }
        } //end diff
    }//end union
    sphere(minkRad);
}
    
    
    
    
//    
//            //outer curve of ring holder
////        translate([speakerHoleRad+ringHolderWidth,0,0]){
//            translate([holderBevelRad+wallThickness+speakerHoleRad+ringHolderWidth,0,couchBackRad+holderHeight+holderBevelRad-minkRad]){
//            cylinder(wallThickness+minkRad*2,speakerHoleRad,speakerHoleRad);
//        }
//    }//end diff
