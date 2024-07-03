//icosahedron without external dependencies

phi=0.5*(sqrt(5)+1); // golden ratio

// create an icosahedron by intersecting 3 orthogonal golden-ratio rectangles
module icosahedron(edge_length) {
   st=0.0001;  // microscopic sheet thickness
   hull() {
       cube([edge_length*phi, edge_length, st], true);
       rotate([90,90,0]) cube([edge_length*phi, edge_length, st], true);
       rotate([90,0,90]) cube([edge_length*phi, edge_length, st], true);
   }
}

// display the 3 internal sheets alongside the icosahedron
edge=10;


icosahedron(edge);