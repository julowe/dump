//pelican style box
//20210210 jkl

/*modeling outline 
1. make simple box with cubes, spheres at corners, cylinders at edges (v minkowski quicker to render. worth it?)
2. as below:
difference(){
    union(){
        main outside shell
        
        difference(){
            outside shell that will be extent of ridges (on main shell)
            
            cubes to take away most of material and make shell into ridges
        } //end difference
    } //end union
    
    ?difference(){
        simple box to make void inside main shell
        stand offs on bottom or at corners etc for various inserts?
    ?}
} //end difference

3. make back hinge 
4. make pin holes for back hinges & front (& side?) clip(s?)

z. cubes to split in two to create seperate halves for making

a. make clip(s?)
*/

//opting for specific sequential operations/math over condensing variables - e.g. "boxRidgeWidth + boxClipFrontWidth + boxRidgeWidth" vs "boxClipFrontWidth + boxRidgeWidth*2" to (hopefully) more clearly show physical dimensions of clip and ridges on either side

draftingFNs = 18;
renderingFNs = 360;
//currentFNs = draftingFNs;
$fn = draftingFNs;

//NB: these are inner dimensions!
boxInteriorWidth = 80;
boxInteriorDepth = 80;
boxInteriorHeight = 40;


boxRoundingRadius = 5;
boxWallWidth = 5; //should boxRoundingRadius be required to equal boxWallWidth? TODO
boxRidgeDepth = 5;
boxRidgeWidth = 3;
boxRidgePairOffset = 5;
boxClipFrontWidth = 20;
boxClipSideWidth = 15;
boxClipSide = true;

ridgePlacementRatio = 3; //used as 1/ridgePlacementRatio further on

//helpful values to calculate placement of front ridges
widthRidgePair = boxRidgeWidth + boxRidgePairOffset + boxRidgeWidth;

//             (half of flat front part + box wall on one side - rounded corner on one side) - half of box clip  - full width of one of the clip ridges (clip pin goes through this to hold clip)
widthFrontLeft = (boxInteriorWidth/2+boxWallWidth-boxRoundingRadius)-boxClipFrontWidth/2-boxRidgeWidth;
widthFrontRight = widthFrontLeft; //just remember to offset from center of box, not sure why would want this different... a lock on one side? but for now make the same as left side

//module will make box of WxDxH, but will subtract material to round the corners
module roundedBox(width, depth, height, edgeRoundingRadius){
    //top & bottom
    translate([edgeRoundingRadius,edgeRoundingRadius,0]){
        cube([width-edgeRoundingRadius*2,depth-edgeRoundingRadius*2,height]);
    }
    //front & back
    translate([edgeRoundingRadius,0,edgeRoundingRadius]){
        cube([width-edgeRoundingRadius*2,depth,height-edgeRoundingRadius*2]);
    }
    //left & right
    translate([0,edgeRoundingRadius,edgeRoundingRadius]){
        cube([width,depth-edgeRoundingRadius*2,height-edgeRoundingRadius*2]);
    }
    
    //corners
    //front
    translate([edgeRoundingRadius,edgeRoundingRadius,height-edgeRoundingRadius]){
        sphere(edgeRoundingRadius);
    }
    translate([width-edgeRoundingRadius,edgeRoundingRadius,height-edgeRoundingRadius]){
        sphere(edgeRoundingRadius);
    }
    translate([width-edgeRoundingRadius,edgeRoundingRadius,edgeRoundingRadius]){
        sphere(edgeRoundingRadius);
    }
    translate([edgeRoundingRadius,edgeRoundingRadius,edgeRoundingRadius]){
        sphere(edgeRoundingRadius);
    }
    //back
    translate([edgeRoundingRadius,depth-edgeRoundingRadius,height-edgeRoundingRadius]){
        sphere(edgeRoundingRadius);
    }
    translate([width-edgeRoundingRadius,depth-edgeRoundingRadius,height-edgeRoundingRadius]){
        sphere(edgeRoundingRadius);
    }
    translate([width-edgeRoundingRadius,depth-edgeRoundingRadius,edgeRoundingRadius]){
        sphere(edgeRoundingRadius);
    }
    translate([edgeRoundingRadius,depth-edgeRoundingRadius,edgeRoundingRadius]){
        sphere(edgeRoundingRadius);
    }
    
    //edges
    //front
    translate([edgeRoundingRadius,edgeRoundingRadius,height-edgeRoundingRadius]){
        rotate([0,90,0]){
            cylinder(width-edgeRoundingRadius*2,edgeRoundingRadius,edgeRoundingRadius);
        }
    }
    translate([width-edgeRoundingRadius,edgeRoundingRadius,edgeRoundingRadius]){
        rotate([0,0,0]){
            cylinder(height-edgeRoundingRadius*2,edgeRoundingRadius,edgeRoundingRadius);
        }
    }
    translate([edgeRoundingRadius,edgeRoundingRadius,edgeRoundingRadius]){
        rotate([0,90,0]){
            cylinder(width-edgeRoundingRadius*2,edgeRoundingRadius,edgeRoundingRadius);
        }
    }
    translate([edgeRoundingRadius,edgeRoundingRadius,edgeRoundingRadius]){
        rotate([0,0,0]){
            cylinder(height-edgeRoundingRadius*2,edgeRoundingRadius,edgeRoundingRadius);
        }
    }
    
    //sides
    translate([edgeRoundingRadius,edgeRoundingRadius,edgeRoundingRadius]){
        rotate([-90,0,0]){
            cylinder(depth-edgeRoundingRadius*2,edgeRoundingRadius,edgeRoundingRadius);
        }
    }
    translate([edgeRoundingRadius,edgeRoundingRadius,height-edgeRoundingRadius]){
        rotate([-90,0,0]){
            cylinder(depth-edgeRoundingRadius*2,edgeRoundingRadius,edgeRoundingRadius);
        }
    }
    translate([width-edgeRoundingRadius,edgeRoundingRadius,edgeRoundingRadius]){
        rotate([-90,0,0]){
            cylinder(depth-edgeRoundingRadius*2,edgeRoundingRadius,edgeRoundingRadius);
        }
    }
    translate([width-edgeRoundingRadius,edgeRoundingRadius,height-edgeRoundingRadius]){
        rotate([-90,0,0]){
            cylinder(depth-edgeRoundingRadius*2,edgeRoundingRadius,edgeRoundingRadius);
        }
    }
    
    //back
    translate([edgeRoundingRadius,depth-edgeRoundingRadius,height-edgeRoundingRadius]){
        rotate([0,90,0]){
            cylinder(width-edgeRoundingRadius*2,edgeRoundingRadius,edgeRoundingRadius);
        }
    }
    translate([width-edgeRoundingRadius,depth-edgeRoundingRadius,edgeRoundingRadius]){
        rotate([0,0,0]){
            cylinder(height-edgeRoundingRadius*2,edgeRoundingRadius,edgeRoundingRadius);
        }
    }
    translate([edgeRoundingRadius,depth-edgeRoundingRadius,edgeRoundingRadius]){
        rotate([0,90,0]){
            cylinder(width-edgeRoundingRadius*2,edgeRoundingRadius,edgeRoundingRadius);
        }
    }
    translate([edgeRoundingRadius,depth-edgeRoundingRadius,edgeRoundingRadius]){
        rotate([0,0,0]){
            cylinder(height-edgeRoundingRadius*2,edgeRoundingRadius,edgeRoundingRadius);
        }
    }
}
//whitespace


//make simple box with interior void 
//TODO move aroudn order of operations to ensure clear inner void, and ability to remove top & bottom for rendering pieces
translate([boxRidgeDepth,boxRidgeDepth,0]){
    difference(){
        //base shell
        difference(){
        roundedBox(boxInteriorWidth+boxWallWidth*2, boxInteriorDepth+boxWallWidth*2, boxInteriorHeight+boxWallWidth*2, boxRoundingRadius);
            translate([boxWallWidth,boxWallWidth,boxWallWidth]){
        roundedBox(boxInteriorWidth, boxInteriorDepth, boxInteriorHeight, boxRoundingRadius);
            }
        }//end difference
        
//TODO move this to last step
//        //remove top
//        translate([0,0,(boxInteriorHeight+boxWallWidth*2)*2/3]){
//            cube([boxInteriorWidth+boxWallWidth*2,boxInteriorDepth+boxWallWidth*2,boxInteriorHeight+boxWallWidth*2]);
//        }
        
//        //remove bottom
//        translate([0,0,0]){
//            cube([boxInteriorWidth,boxInteriorDepth,(boxInteriorHeight)*2/3]);
//        }
    }//end difference
}


maxDistanceFront = boxInteriorWidth+boxWallWidth*2-boxRoundingRadius*2; //gives edge length w/o corners

//paired front ridges would be at least (0 input for areas between ridges and closing clip): (add seperation of at least a boxRidgeWidth between 2 left ridge and 3rd left (i.e. left side ridge to hold clip pins)
minDistanceFrontPairRidges = boxRidgeWidth + boxRidgePairOffset + boxRidgeWidth + boxRidgeWidth + boxRidgeWidth + boxClipFrontWidth + boxRidgeWidth + boxRidgeWidth + boxRidgeWidth + boxRidgePairOffset + boxRidgeWidth;

//single front ridges
minDistanceFrontSingleRidges = boxRidgeWidth + boxRidgeWidth + boxRidgeWidth + boxClipFrontWidth + boxRidgeWidth + boxRidgeWidth + boxRidgeWidth;

//draw outer box which pieces will be subtracted from to make ridges
difference(){ //difference1
    roundedBox(boxInteriorWidth+boxWallWidth*2+boxRidgeDepth*2, boxInteriorDepth+boxWallWidth*2+boxRidgeDepth*2, boxInteriorHeight+boxWallWidth*2, boxRoundingRadius);
    
//TODO: union all ridge making voids together, and from that subtract shapes to mae beveled lip aroudn box seam and ridge for clip to close onto and shapes for hinges, but those might be totally an add-on of material
    

    
   //TODO: decide how clip will secure box closed - friction over bottom ridge? articulation on top side that allow sclips to go over bottom ridge and then push top in towards case?

    //union together all the subtraction shapes so we can subtract from that the lip ridge and any other objects (clip ridge, etc)   
    union(){  
        //clip void
        translate([-boxClipFrontWidth/2+(boxInteriorWidth+boxRoundingRadius*2+boxRidgeDepth*2)/2,0,0]){
            cube([boxClipFrontWidth,boxRidgeDepth+boxRoundingRadius,boxInteriorHeight+boxWallWidth*2]);
        }
        //clip pin voids 
        //TODO
         
    if (maxDistanceFront >= minDistanceFrontPairRidges) { //if paired ridges front do fit
        //pairs - consider 3 objects, center the clip, then 1/3 the distance of the corner to clip area (away from corners) place ridge/offset/ridge objects? aaaand then invert that because we are removing material to create voids, not placing objects
    
        if (widthFrontLeft/ridgePlacementRatio > widthRidgePair/2){ //if paired front ridges fit at ratio placement
            //good to go with ridge pair offset from corner
            
            //left ridges
            //void from corner to 1st left ridge
            translate([0,0,0]){
                cube([boxRidgeDepth+boxRoundingRadius+widthFrontLeft/ridgePlacementRatio-widthRidgePair/2,boxRidgeDepth+boxRoundingRadius,boxInteriorHeight+boxWallWidth*2]);
            }
            //void from 1st left ridge to 2nd left ridge
            translate([boxRidgeDepth+boxRoundingRadius+widthFrontLeft/ridgePlacementRatio-widthRidgePair/2+boxRidgeWidth,0,0]){
                cube([boxRidgePairOffset,boxRidgeDepth+boxRoundingRadius,boxInteriorHeight+boxWallWidth*2]);
            }
            //void from 2nd left ridge to clip ridge
            translate([boxRidgeDepth+boxRoundingRadius+widthFrontLeft/ridgePlacementRatio-widthRidgePair/2+boxRidgeWidth+boxRidgePairOffset+boxRidgeWidth,0,0]){
                cube([widthFrontLeft-(widthFrontLeft/ridgePlacementRatio-widthRidgePair/2+boxRidgeWidth+boxRidgePairOffset+boxRidgeWidth),boxRidgeDepth+boxRoundingRadius,boxInteriorHeight+boxWallWidth*2]);
            }
            
            //right ridges
            //TODO change this to count back from rightmost edge of box for slightly neater math (vs adding on from left side)
            //void from clip to 1st right ridge (numbering from left to right)
            translate([boxRidgeDepth+boxRoundingRadius+widthFrontLeft+boxRidgeWidth+boxClipFrontWidth+boxRidgeWidth,0,0]){
                cube([widthFrontRight-(widthFrontRight/ridgePlacementRatio-widthRidgePair/2+boxRidgeWidth+boxRidgePairOffset+boxRidgeWidth),boxRidgeDepth+boxRoundingRadius,boxInteriorHeight+boxWallWidth*2]);
            }
            //void from 1st right ridge to 2nd right ridge (numbering from left to right)
            translate([boxRidgeDepth+boxRoundingRadius+widthFrontLeft+boxRidgeWidth+boxClipFrontWidth+boxRidgeWidth+(widthFrontRight-(widthFrontRight/ridgePlacementRatio-widthRidgePair/2+boxRidgeWidth+boxRidgePairOffset+boxRidgeWidth))+boxRidgeWidth,0,0]){
                cube([boxRidgePairOffset,boxRidgeDepth+boxRoundingRadius,boxInteriorHeight+boxWallWidth*2]);
            }
            //void from 2nd right ridge to corner (numbering from left to right)
    //        translate([(boxInteriorWidth+boxWallWidth*2+boxRidgeDepth*2)-boxRidgeDepth-boxRoundingRadius,0,0]){
            translate([boxRidgeDepth+boxRoundingRadius+widthFrontLeft+boxRidgeWidth+boxClipFrontWidth+boxRidgeWidth+(widthFrontRight-(widthFrontRight/ridgePlacementRatio-widthRidgePair/2+boxRidgeWidth+boxRidgePairOffset+boxRidgeWidth))+boxRidgeWidth+boxRidgePairOffset+boxRidgeWidth,0,0]){
                cube([boxInteriorWidth+boxWallWidth*2+boxRidgeDepth*2-(boxRidgeDepth+boxRoundingRadius+widthFrontLeft+boxRidgeWidth+boxClipFrontWidth+boxRidgeWidth+(widthFrontRight-(widthFrontRight/ridgePlacementRatio-widthRidgePair/2+boxRidgeWidth+boxRidgePairOffset+boxRidgeWidth))+boxRidgeWidth+boxRidgePairOffset+boxRidgeWidth),boxRidgeDepth+boxRoundingRadius,boxInteriorHeight+boxWallWidth*2]);
            }
            
        } else { //else, paired front ridges do NOT fit at ratio placement
            // 1/$ratio of distance is too small, place ridge pair right at edge
            //void from corner to 1st left ridge
            translate([0,0,0]){
                cube([boxRidgeDepth+boxRoundingRadius,boxRidgeDepth+boxRoundingRadius,boxInteriorHeight+boxWallWidth*2]);
            }
            //void from 1st left ridge to 2nd left ridge
            translate([boxRidgeDepth+boxRoundingRadius+boxRidgeWidth,0,0]){
                cube([boxRidgePairOffset,boxRidgeDepth+boxRoundingRadius,boxInteriorHeight+boxWallWidth*2]);
            }
            //void from 2nd left ridge to clip ridge
            translate([boxRidgeDepth+boxRoundingRadius+boxRidgeWidth+boxRidgePairOffset+boxRidgeWidth,0,0]){
                cube([widthFrontLeft-(boxRidgeWidth+boxRidgePairOffset+boxRidgeWidth),boxRidgeDepth+boxRoundingRadius,boxInteriorHeight+boxWallWidth*2]);
            }
            
            //right ridges
            //TODO change this to count back from rightmost edge of box for slightly neater math (vs adding on from left side)
            //void from clip to 1st right ridge (numbering from left to right)
            translate([boxRidgeDepth+boxRoundingRadius+widthFrontLeft+boxRidgeWidth+boxClipFrontWidth+boxRidgeWidth,0,0]){
                cube([widthFrontRight-(boxRidgeWidth+boxRidgePairOffset+boxRidgeWidth),boxRidgeDepth+boxRoundingRadius,boxInteriorHeight+boxWallWidth*2]);
            }
            //void from 1st right ridge to 2nd right ridge (numbering from left to right)
            translate([boxRidgeDepth+boxRoundingRadius+widthFrontLeft+boxRidgeWidth+boxClipFrontWidth+boxRidgeWidth+(widthFrontRight-(boxRidgeWidth+boxRidgePairOffset+boxRidgeWidth))+boxRidgeWidth,0,0]){
                cube([boxRidgePairOffset,boxRidgeDepth+boxRoundingRadius,boxInteriorHeight+boxWallWidth*2]);
            }
            //void from 2nd right ridge to corner (numbering from left to right)
    //        translate([(boxInteriorWidth+boxWallWidth*2+boxRidgeDepth*2)-boxRidgeDepth-boxRoundingRadius,0,0]){
            translate([boxRidgeDepth+boxRoundingRadius+widthFrontLeft+boxRidgeWidth+boxClipFrontWidth+boxRidgeWidth+(widthFrontRight-(boxRidgeWidth+boxRidgePairOffset+boxRidgeWidth))+boxRidgeWidth+boxRidgePairOffset+boxRidgeWidth,0,0]){
                cube([boxInteriorWidth+boxWallWidth*2+boxRidgeDepth*2-(boxRidgeDepth+boxRoundingRadius+widthFrontLeft+boxRidgeWidth+boxClipFrontWidth+boxRidgeWidth+(widthFrontRight-(boxRidgeWidth+boxRidgePairOffset+boxRidgeWidth))+boxRidgeWidth+boxRidgePairOffset+boxRidgeWidth),boxRidgeDepth+boxRoundingRadius,boxInteriorHeight+boxWallWidth*2]);
            }
        } //end if/else paired front ridges fit at ratio placement
    } else if (maxDistanceFront >= minDistanceFrontSingleRidges) { //else-if single ridges front do fit
        //single ridges bc pair ridge too big
        if (widthFrontLeft/ridgePlacementRatio > boxRidgeWidth/2){ //if not fit single ridge ratio
            //good to place single ridge at offset from corner
            //corner to first ridge
            translate([0,0,0]){
                cube([boxRidgeDepth+boxRoundingRadius+widthFrontLeft/ridgePlacementRatio-boxRidgeWidth/2,boxRidgeDepth+boxRoundingRadius,boxInteriorHeight+boxWallWidth*2]);
            }
            //void from left ridge to clip ridge
            translate([boxRidgeDepth+boxRoundingRadius+widthFrontLeft/ridgePlacementRatio-boxRidgeWidth/2+boxRidgeWidth,0,0]){
                cube([widthFrontLeft-(widthFrontLeft/ridgePlacementRatio-boxRidgeWidth/2+boxRidgeWidth),boxRidgeDepth+boxRoundingRadius,boxInteriorHeight+boxWallWidth*2]);
            }
        
            //void from clip to 1st right ridge (numbering from left to right)
            translate([boxRidgeDepth+boxRoundingRadius+widthFrontLeft+boxRidgeWidth+boxClipFrontWidth+boxRidgeWidth,0,0]){
                cube([widthFrontRight-(widthFrontRight/ridgePlacementRatio-boxRidgeWidth/2+boxRidgeWidth),boxRidgeDepth+boxRoundingRadius,boxInteriorHeight+boxWallWidth*2]);
            }
            //void from right ridge to corner
            translate([boxRidgeDepth+boxRoundingRadius+widthFrontLeft+boxRidgeWidth+boxClipFrontWidth+boxRidgeWidth+(widthFrontRight-(widthFrontRight/ridgePlacementRatio-boxRidgeWidth/2+boxRidgeWidth))+boxRidgeWidth,0,0]){
                cube([boxInteriorWidth+boxWallWidth*2+boxRidgeDepth*2-(boxRidgeDepth+boxRoundingRadius+widthFrontLeft+boxRidgeWidth+boxClipFrontWidth+boxRidgeWidth+(widthFrontRight-(widthFrontRight/ridgePlacementRatio-boxRidgeWidth/2+boxRidgeWidth))+boxRidgeWidth),,boxRidgeDepth+boxRoundingRadius,boxInteriorHeight+boxWallWidth*2]);
            }
            
        } else { //else of not fit single ridge ratio     
            // 1/$ratio of distance is too small, place ridge right at the edge
            //void from corner to 1st left ridge
            translate([0,0,0]){
                cube([boxRidgeDepth+boxRoundingRadius,boxRidgeDepth+boxRoundingRadius,boxInteriorHeight+boxWallWidth*2]);
            }
            //void from 2nd left ridge to clip ridge
            translate([boxRidgeDepth+boxRoundingRadius+boxRidgeWidth,0,0]){
                cube([widthFrontLeft-boxRidgeWidth,boxRidgeDepth+boxRoundingRadius,boxInteriorHeight+boxWallWidth*2]);
            }
            
            //right ridges
            //void from clip to 1st right ridge (numbering from left to right)
            translate([boxRidgeDepth+boxRoundingRadius+widthFrontLeft+boxRidgeWidth+boxClipFrontWidth+boxRidgeWidth,0,0]){
                cube([widthFrontRight-(boxRidgeWidth+boxRidgePairOffset+boxRidgeWidth),boxRidgeDepth+boxRoundingRadius,boxInteriorHeight+boxWallWidth*2]);
            }
            //void from 1st right ridge to 2nd right ridge (numbering from left to right)
            translate([boxRidgeDepth+boxRoundingRadius+widthFrontLeft+boxRidgeWidth+boxClipFrontWidth+boxRidgeWidth+(widthFrontRight-(boxRidgeWidth+boxRidgePairOffset+boxRidgeWidth))+boxRidgeWidth,0,0]){
                cube([boxRidgePairOffset,boxRidgeDepth+boxRoundingRadius,boxInteriorHeight+boxWallWidth*2]);
            }
            //void from 2nd right ridge to corner (numbering from left to right)
            translate([boxRidgeDepth+boxRoundingRadius+widthFrontLeft+boxRidgeWidth+boxClipFrontWidth+boxRidgeWidth+(widthFrontRight-(boxRidgeWidth+boxRidgePairOffset+boxRidgeWidth))+boxRidgeWidth+boxRidgePairOffset+boxRidgeWidth,0,0]){
                cube([boxInteriorWidth+boxWallWidth*2+boxRidgeDepth*2-(boxRidgeDepth+boxRoundingRadius+widthFrontLeft+boxRidgeWidth+boxClipFrontWidth+boxRidgeWidth+(widthFrontRight-(boxRidgeWidth+boxRidgePairOffset+boxRidgeWidth))+boxRidgeWidth+boxRidgePairOffset+boxRidgeWidth),boxRidgeDepth+boxRoundingRadius,boxInteriorHeight+boxWallWidth*2]);
            }
        } //end if/else of not fit single ridge ratio
        
        
    } else if (maxDistanceFront >= boxRidgeWidth+boxClipFrontWidth+boxRidgeWidth) {//else-if single ridges front do NOT fit, only clip
        //no room for reinforcing ridges, just have clip ridges
        //void from left corner to clip ridge
        translate([0,0,0]){
            cube([boxRidgeDepth+boxRoundingRadius+widthFrontLeft,boxRidgeDepth+boxRoundingRadius,boxInteriorHeight+boxWallWidth*2]);
        }
        //void from clip ridge to right corner
        translate([boxRidgeDepth+boxRoundingRadius+widthFrontLeft+boxRidgeWidth+boxClipFrontWidth+boxRidgeWidth,0,0]){
            cube([boxRidgeDepth+boxRoundingRadius+widthFrontLeft,boxRidgeDepth+boxRoundingRadius,boxInteriorHeight+boxWallWidth*2]);
        }
            
    } else { //else single ridges front do NOT fit, and clip does NOT fit - error
        assert(false,"ERROR: Box width is smaller than a single ridge on each side of clip. Decrease clip width or ridge widths, or increase width of box");
    } //end if/else-if/else-if/else front single or paired ridges front fit logic
    
    echo("widthFrontLeft = ", widthFrontLeft); //TODO remove debug statements
    
    echo("widthFrontLeft/ridgePlacementRatio = ", widthFrontLeft/ridgePlacementRatio); 
    } //end union of ridge differences

} //end difference1
//whitespace 


//TODO make insets in bottom for rubber feet (or maybe rings?) and make rings on top for stacking

//TODO remove debug statements
echo("maxDistanceFront = ", maxDistanceFront);
echo("minDistanceFrontPairRidges = ", minDistanceFrontPairRidges);
echo("minDistanceFrontSingleRidges = ", minDistanceFrontSingleRidges);
echo("boxRidgeWidth = ", boxRidgeWidth);

echo("boxRidgeWidth/2 = ", boxRidgeWidth/2);
