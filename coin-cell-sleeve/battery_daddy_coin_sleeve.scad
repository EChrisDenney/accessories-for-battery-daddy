// Battery Daddy coin-cell sleeve: generic, v2.8
// v2.8: D tube OD 33.568 -> 32.968 (fit test: 32.97 cup fits every D slot). D tube ID, cartridge, head and snap
//       moved in by 0.30 mm radius together, so the 0.905 wall and the 0.229 mm friction gap are unchanged. AA unchanged.
// v2.7: added CR2032 and CR2025 (D slot). No geometry changes to the existing sleeves.
// v2.6: v2.5's 0.60 mm AA tube wall printed as ~0.80 (slicer widened it), so OD came out 14.4. Wall restored to
//       0.708 (prints true, per v2.4) and the tube ID + whole AA cartridge (body, head, snap) moved in by 0.1075 mm
//       radius, keeping the tuned 0.2145 mm friction gap. AA tube OD model 14.23 -> prints ~14.20. LR44 side walls
//       end at 72 deg (tips kept >= ~0.42 mm). D sleeve unchanged.
// v2.5: AA tube OD 14.444 -> 14.23 mm (v2.4 printed at 14.41 and was tight in some slots; target ~14.20 as printed).
//       Tube ID unchanged, so cartridge friction is unchanged. AA tube wall 0.71 -> 0.60 mm.
// v2.4: tube sizes baked in from Chris's tuned print (tube scaled XY 101% AA / 100.5% D gave the right friction):
//       tube ID = that printed ID; tube OD = printed OD - 0.1 mm (AA) / - 0.2 mm (D) for loose fit in any slot.
//       Cartridge, head, snap and pockets unchanged. Total height = battery height (AA 50.3, D 61.3) so the
//       cartridge can't slide out when the case is turned over; spare height goes into the solid top section.
//       Print everything at 100%.
// v2.3: bottom disc back to full cartridge diameter (kept 1.8 mm thickness and 0.5 mm lead-in chamfer).
// v2.2: bottom disc 1.2 -> 1.8 mm thick, 0.2 mm smaller radius than the cartridge, 0.5 mm lead-in chamfer;
//       AA tube floor 0.8 -> 0.6 mm to pay for the height.
// v2.1: LR621/LR754/CR1620 side walls cut back to the cell's widest point (cells were sitting in a deep slot).
// One model for any coin/button cell in a Battery Daddy AA or D slot.
// Design = proven LR44 v1.3: pocketed cartridge in a closed-bottom tube, 1.2 mm shelves trimmed at the
// front, solid back spine, snap-on cap (bead into a groove on the cartridge head), stacked blue label.
// Units: mm. Axis = Z. Front (cell exit side) = +Y, back = -Y.
//
// Copyright (c) 2026 Chris Denney. Licensed under CC BY-SA 4.0 (see LICENSE).

/* ---------- selection (override with -D) ---------- */
cell = "LR44";          // "LR44" | "LR621" | "LR754" | "CR1620" | "CR2032" | "CR2025"
part = "core";          // "core" | "tube" | "cap_body" | "cap_text" | "assembly"
n_override = 0;         // 0 = as many cells as fit under the lid
print_orient = true;

/* ---------- presets: [name, dia max, thick max, slot, line1, line2, label letter height] ---------- */
presets = [
    ["LR44",   11.6, 5.40, "AA", "LR", "44",   5.0],
    ["LR621",   6.8, 2.15, "AA", "LR", "621",  3.9],
    ["LR754",   7.9, 5.40, "AA", "LR", "754",  4.1],
    ["CR1620", 16.0, 2.00, "D",  "CR", "1620", 7.2],
    ["CR2032", 20.0, 3.20, "D",  "CR", "2032", 7.2],
    ["CR2025", 20.0, 2.50, "D",  "CR", "2025", 7.2]
];
P = presets[search([cell], presets, 1, 0)[0]];
cell_d = P[1]; cell_h = P[2]; slot = P[3];
label_lines = [P[4], P[5]]; line_h = P[6]; line_gap = (slot=="D") ? 1.8 : 1.0; text_d = 0.6;

/* ---------- Battery Daddy slots ---------- */
slot_d     = (slot=="D") ? 34.2 : 14.9;      // nominal slot size; used for the cap only (cap sits above the slot)
target_h   = (slot=="D") ? 61.3 : 50.3;      // total assembly height = battery height (D 61.5 / AA 50.5 max) - 0.2
// Tube: tuned on real prints (v2.3 tube printed at XY 101% AA / 100.5% D gave the right cartridge friction)
R_in       = (slot=="D") ? 15.579 : 6.407;   // tube ID 31.158 / 12.814
R_out      = (slot=="D") ? 16.484 : 7.115;   // tube OD 32.968 (fit-tested) / 14.23 (prints ~14.20)
wall       = R_out - R_in;                   // 0.905 / 0.708 (>= 0.7 so the slicer prints it true)
core_r     = (slot=="D") ? 15.35 : 6.1925;   // cartridge body (gap to tube 0.229 / 0.2145 mm = tuned friction)

/* ---------- pockets ---------- */
pocket_r = cell_d/2 + 0.15;
pocket_h = cell_h + 0.4;
shelf    = 1.2; base_h = 1.8; top_min = 0.8;     // top_h (solid section under the head) is set below
base_r   = core_r;           // bottom disc: full cartridge diameter (v2.3)
base_ch  = 0.5;              // lead-in chamfer on the bottom edge
// LR44 keeps its v1.3 values; smaller cells sit forward so the back spine is thick
e        = (cell=="LR44") ? 0.5 : core_r - pocket_r;
rail_max = (cell=="LR44") ? 72 : 180;        // 180 = walls wrap right up to the exit path
shelf_front = (cell=="LR44") ? 2.5 : e + 0.17*cell_d;
flat_y   = -(core_r - 0.15);                 // print flat on the back
floor_h  = (slot=="D") ? 0.8 : 0.6; floor_gap = 0.2;

/* ---------- snap joint (scaled from the tube) ---------- */
head_r   = core_r + 0.40;  // 6.5925 / 15.75; rests on the tube rim (overlap 0.1855 / 0.171)
head_h   = 3.0; head_ch = 0.5;
groove_z0 = 0.2; groove_z1 = 1.2; groove_r = head_r - 0.25;
cap_r    = slot_d/2;
skirt_ri = head_r + 0.10;
skirt_gap = 0.1;
bead_r   = head_r - 0.15;  // 0.15 mm snap interference
face_t   = 1.2;
slits    = (slot=="D") ? 6 : 4; slit_w = 0.8;

fixed_h = floor_h + floor_gap + base_h + top_min + head_h + face_t;
n_fit   = floor((target_h - fixed_h + shelf) / (pocket_h + shelf));
n       = (n_override > 0) ? n_override : n_fit;
top_h   = target_h - (fixed_h - top_min) - (n*pocket_h + (n-1)*shelf);   // spare height goes here
max_height = target_h;

core_top = base_h + n*pocket_h + (n-1)*shelf + top_h;
tube_h   = floor_h + floor_gap + core_top;
total_h  = tube_h + head_h + face_t;
skirt_h  = head_h - skirt_gap;

$fn = (slot=="D") ? 180 : 120;

/* ---------- cartridge ---------- */
module pocket_cut2d() {
    translate([0,e]) circle(r=pocket_r);
    translate([-pocket_r, e]) square([2*pocket_r, 40]);
    // v2.1: side walls stop at the cell's widest point, so the front half of every cell is exposed (as on the LR44)
    if (cell != "LR44") translate([-50, e]) square([100, 50]);
    if (rail_max < 180) {
        s = 60;
        polygon([[0,0],[ s*sin(rail_max), -s*cos(rail_max)],[ s, s],[-s, s],[-s*sin(rail_max), -s*cos(rail_max)]]);
    }
}
module spine2d() { difference() { circle(r=core_r); pocket_cut2d(); } }
module shelf2d() {
    offset(r=1) offset(delta=-1)
        intersection() { circle(r=core_r); translate([-40,-40]) square([80, 40+shelf_front]); }
}
function pz(i) = base_h + i*(pocket_h+shelf);
ov = 0.01;

module head() {
    rotate_extrude() polygon([
        [0,0], [head_r,0], [head_r,groove_z0],
        [groove_r, groove_z0+0.25], [groove_r, groove_z1-0.25], [head_r, groove_z1],
        [head_r, head_h-head_ch], [head_r-head_ch, head_h], [0, head_h]]);
}
module core() {
    intersection() {
        union() {
            cylinder(r1=base_r-base_ch, r2=base_r, h=base_ch);
            translate([0,0,base_ch]) cylinder(r=base_r, h=base_h-base_ch);
            for (i=[0:n-1]) {
                // small overlaps (ov) keep stacked pieces fused into one solid
                translate([0,0,pz(i)-ov]) linear_extrude(pocket_h+2*ov) spine2d();
                if (i<n-1) translate([0,0,pz(i)+pocket_h-ov]) linear_extrude(shelf+2*ov) shelf2d();
            }
            translate([0,0,core_top-top_h-ov]) cylinder(r=core_r, h=top_h+ov);
            translate([0,0,core_top]) head();
        }
        translate([-50, flat_y, -1]) cube([100, 100, core_top+head_h+2]);
    }
}

/* ---------- tube ---------- */
module tube() {
    difference() {
        cylinder(r=R_out, h=tube_h);
        translate([0,0,floor_h]) cylinder(r=R_in, h=tube_h);
    }
}

/* ---------- cap (z = 0 at skirt bottom) ---------- */
module cap_solid() {
    bz = groove_z0 + 0.1 - skirt_gap;
    difference() {
        rotate_extrude() polygon([
            [skirt_ri, 0], [cap_r-0.3, 0], [cap_r, 0.3],
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

echo(str("CELL=", cell, " N=", n, " TOTAL_HEIGHT=", total_h, " LIMIT=", max_height,
         " E=", e, " SPINE_BACK=", core_r-(pocket_r-e), " CELL_FRONT_GAP=", R_in-(e+cell_d/2)));

if (part=="core")          { if (print_orient) print_core(); else core(); }
else if (part=="tube")     tube();
else if (part=="cap_body") { if (print_orient) print_cap() cap_body(); else cap_body(); }
else if (part=="cap_text") { if (print_orient) print_cap() cap_text(); else cap_text(); }
else if (part=="assembly") assembly();
