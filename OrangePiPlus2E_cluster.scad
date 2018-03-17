bw = 60; // Board width
bh = 94; // Board height
spdw = 53; // Small pin delta width (center to center)
spdh = 73; // Small pin delta height (center to center)
spoh = 3; // Small pin delta (in height direction) from board edge 
spow = (bw-spdw)/2; // Small pin offset Y from board edge 
h = 4; // Height of plate
ph = 23; // Pin height
pr = 4; // Large pin radius
pbr = pr*1.7; // Large pin base radius
pow = pbr/2; // Offset from board to  large pin center
poh = pbr/2; // Offset from board to  large pin center
spr = 2.6; // Small pin radius
sph = 4; // Small pin height
xbs = 2; // Extra board size
beam = spr*2;
antd = 5; // antenne diameter
antl = 22; // antenna length

module pin_with_hole(posx, posy,goUp) {
  difference() {
    r = pbr;
    r1 = pr;
    r2 = r1*0.6;
    union() {
      translate([posx, posy, 0])
        cylinder(r=r, h, $fs=.3);
      if (goUp) {
        translate([posx, posy, h])
          cylinder(r=r1, ph, $fs=.3);
        translate([posx ,posy, ph+h], $fs=.3)
          cylinder(r=r2, h, $fs=.3);
      } else {
        translate([posx ,posy, h], $fs=.3)
          cylinder(r=r1, h, $fs=.3);        
      }
    }
    // Create hole for upper pin to fit in
    translate([posx, posy, 0])
      cylinder(r=r2+0.2, h, $fs=.3);
  }
}

module small_pin(posx, posy) {
  translate([posx, posy, 0])
    cylinder(r=spr, h+sph, $fs=.3);
  translate([posx, posy, 0])
    cylinder(r=1.3, h+sph+5, $fs=.3);
}

module frame() {
  translate([-xbs,-xbs,0]) {
    translate([0,0,0])
      cube([beam+xbs, bh+xbs*2, h]);
    translate([bw+xbs*2-(beam+xbs),0,0])
      cube([beam+xbs, bh+xbs*2, h]);
    translate([0,0,0])
      cube([bw+xbs*2, beam+xbs, h]);
    translate([0,bh+xbs*2-(beam+xbs),0])
      cube([bw+xbs*2, beam+xbs, h]);
  }
}

module pinGaps() {
  r = pbr;
  union() {
    translate([-pow, -poh, 0]) cylinder(r=r, h, $fs=.3);
    translate([-pow, bh+poh, 0]) cylinder(r=r, h, $fs=.3);
    translate([bw+pow, -poh, 0]) cylinder(r=r, h, $fs=.3);
    translate([bw+pow, bh+poh, 0]) cylinder(r=r, h, $fs=.3);
  }
}

module cluster() {
    rotate([0,0,-90]) {
        union() {
          difference() {
            union() {
              // Outside frame
              frame();
              // Crossbar
              translate([-xbs,spoh+spdh-((beam+xbs)/2),0])
                cube([bw+xbs*2, beam+xbs, h]);
              // Small PCB pins
              small_pin(spow, spoh);
              small_pin(spow, spoh+spdh);
              small_pin(spow+spdw, spoh);
              small_pin(spow+spdw, spoh+spdh);
            }
            // Ensure bottom has right holes
            pinGaps();
          }
          // High pins
          pin_with_hole(-pow, -poh, true);
          pin_with_hole(-pow, bh+poh, true);
          pin_with_hole(bw+pow, -poh, true);
          pin_with_hole(bw+pow, bh+poh, true);
          // Antenna holder
          translate([-1*(xbs+h+antd), bw*0.7, 0])
            union() {
              translate([0,0,0])
                cube([h/2, antl, h*1.5]);
              translate([h/2,0,0])
                cube([antd, antl, h/3]);
              translate([h/2+antd,0,0])
                cube([h/2, antl, h*1.5]);
            }

        }
    }
}

module top() {
    rotate([0,0,-90]) {
        union() {
          difference() {
            union() {
              // Outside frame
              frame();
              // Cross
              l = norm([bw,bh,0]);
              c = atan2(bh,bw);
              translate([bw/2,bh/2,h/4])
                rotate([0,0,c]) 
                  cube([l,beam,h/2],true);
              translate([bw/2,bh/2,h/4])
                rotate([0,0,-c]) 
                  cube([l,beam,h/2],true);
            }
            // Ensure bottom has right holes
            pinGaps();
          }
          // Low pins
          pin_with_hole(-pow, -poh, false);
          pin_with_hole(-pow, bh+poh, false);
          pin_with_hole(bw+pow, -poh, false);
          pin_with_hole(bw+pow, bh+poh, false);
        }
    }
}

cluster();
rotate([0,0,180]) 
  translate([pow*10,bw,0])
    top();