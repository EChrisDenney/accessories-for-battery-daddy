// HISTORY ONLY: superseded by coin-cell-sleeve/battery_daddy_coin_sleeve.scad (v2.x). Kept for reference.
// Battery Daddy AA-slot coin-cell sleeve: LR44, v1.3 (slide version)
// v1.3: shelves trimmed at the front (shorter lever arm, shorter fins when printed lying down).
// v1.2: snap-on cap. The cartridge has a head that rests on the tube rim, with a groove around it;
//       the cap's slotted skirt has an inner bead that clicks into the groove (no glue).
// v1.1: 6 cells, 1.2 mm shelves, solid back spine, stacked "LR/44" label.
// Units: mm. Axis = Z. Front (cell exit side) = +Y, back = -Y.
//
// Copyright (c) 2026 Chris Denney. Licensed under CC BY-SA 4.0 (see LICENSE).

/* ---------- selection ---------- */
part = "core";          // "core" | "tube" | "cap_body" | "cap_text" | "assembly"
n    = 6;               // number of cells
print_orient = true;

/* ---------- cell / label ---------- */
cell_d = 11.6; cell_h = 5.4;
label_lines = ["LR", "44"];
line_h = 5.0; line_gap = 1.0; text_d = 0.6;

/* ---------- Battery Daddy AA slot ---------- */
slot_d = 14.9;
max_height = 49.4 - 0.6;      // to the clear lid, minus margin

/* ---------- body ---------- */
R_out  = 7.2;   wall = 0.75;  R_in = R_out - wall;   // tube 14.4 OD
core_r = 6.30;                 // 0.15 radial clearance in tube
pocket_r = 5.95; e = 0.50; pocket_h = 5.8;
shelf = 1.2; base_h = 1.2; top_h = 0.8;
rail_max = 80;
shelf_front = 2.5;   // shelves stop this far in front of the axis (cell centre is at y = e)
flat_y = -6.15;                // print flat on the back of the cartridge
floor_h = 0.8; floor_gap = 0.2;

/* ---------- snap joint ---------- */
head_r   = 6.70;   // head OD 13.4, rests on the tube rim (rim spans 6.45..7.2)
head_h   = 3.0;
head_ch  = 0.5;    // lead-in chamfer on top of head
groove_z0 = 0.2; groove_z1 = 1.2; groove_r = 6.45;   // groove on head (head-relative z)
cap_r    = 7.45;   // cap OD 14.9
skirt_ri = 6.80;   // 0.1 radial clearance over head
skirt_gap = 0.1;   // skirt bottom sits this far above head bottom (head carries the load)
bead_r   = 6.55;   // bead tip: 0.15 interference with head, 0.10 clear of groove floor
face_t   = 1.2;    // cap face over the head (label inlaid 0.6)
slits    = 4; slit_w = 0.8;

core_top = base_h + n*pocket_h + (n-1)*shelf + top_h;   // top of the in-tube body
tube_h   = floor_h + floor_gap + core_top;              // rim height
total_h  = tube_h + head_h + face_t;
skirt_h  = head_h - skirt_gap;

$fn = 120;

/* ---------- cartridge ---------- */
module pocket_cut2d() {
    translate([0,e]) circle(r=pocket_r);
    translate([-pocket_r, e]) square([2*pocket_r, 20]);
    s = 30;
    polygon([[0,0],[ s*sin(rail_max), -s*cos(rail_max)],[ s, s],[-s, s],[-s*sin(rail_max), -s*cos(rail_max)]]);
}
module spine2d() { difference() { circle(r=core_r); pocket_cut2d(); } }
module shelf2d() { offset(r=1) offset(delta=-1) intersection() { circle(r=core_r); translate([-10,-10]) square([20, 10+shelf_front]); } }
function pz(i) = base_h + i*(pocket_h+shelf);

module head() {   // revolved profile, z = 0 at the tube rim
    rotate_extrude() polygon([
        [0,0], [head_r,0], [head_r,groove_z0],
        [groove_r, groove_z0+0.25], [groove_r, groove_z1-0.25], [head_r, groove_z1],
        [head_r, head_h-head_ch], [head_r-head_ch, head_h], [0, head_h]]);
}

module core() {
    intersection() {
        union() {
            cylinder(r=core_r, h=base_h);
            for (i=[0:n-1]) {
                translate([0,0,pz(i)]) linear_extrude(pocket_h) spine2d();
                if (i<n-1) translate([0,0,pz(i)+pocket_h]) linear_extrude(shelf) shelf2d();
            }
            translate([0,0,core_top-top_h]) cylinder(r=core_r, h=top_h);
            translate([0,0,core_top]) head();
        }
        translate([-20, flat_y, -1]) cube([40, 40, core_top+head_h+2]);
    }
}

/* ---------- tube ---------- */
module tube() {
    difference() {
        cylinder(r=R_out, h=tube_h);
        translate([0,0,floor_h]) cylinder(r=R_in, h=tube_h);
    }
}

/* ---------- cap (z = 0 at skirt bottom, use orientation) ---------- */
module cap_solid() {
    bz = groove_z0 + 0.1 - skirt_gap;    // bead centred in the groove
    difference() {
        rotate_extrude() polygon([
            [skirt_ri, 0], [cap_r-0.3, 0], [cap_r, 0.3],           // small chamfer = fingernail edge
            [cap_r, skirt_h+face_t], [0, skirt_h+face_t], [0, skirt_h],
            [skirt_ri, skirt_h],
            [skirt_ri, bz+0.85], [bead_r, bz+0.60], [bead_r, bz+0.40], [skirt_ri, bz+0.15]]);
        for (k=[0:slits-1]) rotate(45 + k*360/slits)
            translate([skirt_ri-1, -slit_w/2, -1]) cube([cap_r-skirt_ri+2, slit_w, skirt_h+1]);
    }
}
module label_text() {
    nl = len(label_lines);
    translate([0,0,skirt_h+face_t-text_d]) linear_extrude(text_d+0.01)
        for (k=[0:nl-1]) translate([0, ((nl-1)/2 - k)*(line_h+line_gap)])
            resize([0, line_h], auto=true)
                text(label_lines[k], font="DejaVu Sans:style=Bold", halign="center", valign="center");
}
module cap_body() { difference() { cap_solid(); label_text(); } }
module cap_text() { intersection() { cap_solid(); label_text(); } }

/* ---------- assembly / print ---------- */
module assembly() {
    color("white", 0.5) tube();
    color("white") translate([0,0,floor_h+floor_gap]) core();
    translate([0,0,tube_h+skirt_gap]) { color("white") cap_body(); color("royalblue") cap_text(); }
}
module print_core() { translate([0,0,-flat_y]) rotate([90,0,0]) core(); }
module print_cap()  { translate([0,0,skirt_h+face_t]) rotate([180,0,0]) children(); }

echo(str("TOTAL_HEIGHT=", total_h, " TUBE_H=", tube_h, " CORE_TOP=", core_top, " LIMIT=", max_height));

if (part=="core")          { if (print_orient) print_core(); else core(); }
else if (part=="tube")     tube();
else if (part=="cap_body") { if (print_orient) print_cap() cap_body(); else cap_body(); }
else if (part=="cap_text") { if (print_orient) print_cap() cap_text(); else cap_text(); }
else if (part=="assembly") assembly();
