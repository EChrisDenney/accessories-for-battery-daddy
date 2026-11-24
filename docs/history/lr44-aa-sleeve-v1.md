# LR44 sleeve for the AA slot: design notes (v1.x, history)

> **History only.** This is the early LR44-only design that the generic v2.x model grew out of. Current design: [../coin-cell-sleeves.md](../coin-cell-sleeves.md).

v1.3: slide version, snap-on cap, trimmed shelves (2026-11-22). Source: [`lr44_aa_sleeve_v1.3.scad`](lr44_aa_sleeve_v1.3.scad).

## Decisions
- **The slide version is chosen.** A pocketed cartridge pulls out of a closed-bottom tube by its cap. It is easier to print and more durable. The twist version (a rotating shell) is shelved: its 0.75 mm windowed shell warped on the v1 test print.
- **Cells never touch.** Each LR44 sits in its own pocket with a plastic shelf between neighbours.
- **No rear push slot.** The cells tip out by gravity or a light shake (tested on v1). Dropping the slot leaves a solid back spine that makes the cartridge stronger.
- **Stacked label.** The cap reads "LR" over "44", with 5 mm letters.
- **Snap-on cap, no glue (v1.2).** The cartridge has a 13.4 mm head that rests on the tube rim, with a groove around it. The cap has a slotted skirt (4 slits) with an inner bead that clicks into the groove: 0.15 mm interference, 45° on both sides.
- **Trimmed shelves (v1.3).** The shelves stop 2.5 mm in front of the axis, about 2 mm past the cell centre, instead of being full discs. That gives a shorter lever arm and a shorter fin when printed. Each shelf still covers about two-thirds of the cell, which is enough to keep cells apart.
- **The side walls can't be lengthened.** The cell (11.6 mm) has to slide out the front, and the tube limits how big the cartridge can be (12.6 mm). Past about 80° the walls drop below 0.45 mm thick (0.37 mm at 90°), so extending them adds nothing useful. Shelf strength comes from the back spine plus the shorter shelves.

## Test print findings
- v1: the 0.6 mm shelves broke easily. They are 1.2 mm from v1.1.
- v1: the twist shell warped.
- v1.1: the peg-and-socket cap needed glue. Replaced by the snap in v1.2.

## v1.3 key numbers
| Item | Value |
|---|---|
| Cells | 6 |
| Shelf | 1.2 mm thick, trimmed at y = +2.5 with 1 mm rounded corners |
| Pocket | 11.9 mm dia × 5.8 mm, offset 0.5 mm toward front |
| Cartridge body | 12.6 mm OD, solid back spine (0.7 to 0.85 mm), side walls to 80°, base 1.2 mm, top 0.8 mm |
| Head | 13.4 mm OD × 3.0 mm, groove 0.25 mm deep, 0.5 mm lead-in chamfer |
| Tube | 14.4 mm OD, 0.75 mm wall, 0.8 mm floor, 43.8 mm tall |
| Cap | 14.9 mm OD; face 1.2 mm with a 0.6 mm blue inlay; skirt 2.9 mm × 0.65 mm wall |
| Total height | 48.0 mm (limit about 48.8; 49.4 to the lid) |

**Note:** the print flat (y = -6.15) also trims the head at the back. About 47° of the snap ring has no groove there, and the other ~313° engages.

## Tuning knobs
- `shelf_front`: how far the shelves reach forward
- `bead_r`: smaller makes the snap tighter
- `groove_r`: deeper gives more retention
- `slits` / `slit_w`: more or wider slits make the cap's skirt flex more easily
