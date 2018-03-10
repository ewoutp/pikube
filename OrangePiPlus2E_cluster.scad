bw = 60; // Board width
bh = 94; // Board height
spdw = 53; // Small pin delta width (center to center)
spdh = 73; // Small pin delta height (center to center)
spoh = 3; // Small pin delta (in height direction) from board edge 
spow = (bw-spdw)/2; // Small pin offset Y from board edge 
pow = 4; // Offset from board to  large pin center
poh = 0; // Offset from board to  large pin center
h = 5; // Height of plate
ph = 10; // Pin height
spr = 2.6;

module pin_with_hole(posx, posy) {
  difference() {
    union() {
      translate([posx, posy, 0])
        cylinder(r=8 , h, $fs=.3);
      translate([posx, posy, 0])
        cylinder(r=2.7 ,ph ,$fs=.3);
      translate([posx ,posy, ph], $fs=.3)
        sphere(2.7);
    }
    translate([posx, posy, 0])
      cylinder(r=2.9, h-1, $fs=.3);
  }
}

module small_pin(posx, posy) {
  translate([posx, posy, 0])
    cylinder(r=spr, h+2, $fs=.3);
  translate([posx, posy, 0])
    cylinder(r=1.2, h+5, $fs=.3);
  translate([posx, posy, h+5], $fs=.3)
    sphere(1.2);
}

module cluster() {
    rotate([0,0,-90]) {
        union() {
          pin_with_hole(-pow, -poh);
          pin_with_hole(-pow, bh+poh);
          pin_with_hole(bw+pow, -poh);
          pin_with_hole(bw+pow, bh+poh);

          difference() {
            union() {
              cube([bw, bh, h]);
              small_pin(spow, spoh);
              small_pin(spow, spoh+spdh);
              small_pin(spow+spdw, spoh);
              small_pin(spow+spdw, spoh+spdh);
          }
          beam = spr*2;
          translate([beam, beam, 0])
            cube([bw-beam*2, spoh+spdh-beam*1.5, h+0.1]);
          translate([beam, spoh+spdh+beam*0.5, 0])
            cube([bw-beam*2, bh-(spoh+spdh+beam*1.5), h+0.1]);
          }
        }
    }
}

cluster();