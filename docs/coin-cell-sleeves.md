# Coin-cell sleeves: family overview (v2.8)

Source: [`coin-cell-sleeve/battery_daddy_coin_sleeve.scad`](../coin-cell-sleeve/battery_daddy_coin_sleeve.scad), one parametric model for every cell. Set `cell = "LR44" | "LR621" | "LR754" | "CR1620" | "CR2032" | "CR2025"`. The cell count is worked out automatically from the target height; `n_override` forces a count. The design history of the earlier LR44-only model is in [`history/`](history/).

**Print everything at 100%.** Files are named with their version, and tube objects carry their outside diameter in the name (e.g. `CR1620_tube_v2.8_OD32.97`).

**Status (2026-11-23):**
- **AA sleeves are DONE** (v2.6): LR44, LR621 and LR754 are printed and confirmed to fit perfectly.
- **D fit test:** of the test cups at 33.37 / 33.17 / 32.97 / 32.77 OD, **32.97 was perfect**. The Battery Daddy D slots seem to taper, narrower at the bottom.
- **D sleeves are DONE** (v2.8): CR1620, CR2032 and CR2025 use a 32.968 OD tube; all three are printed and confirmed to work.

## Lessons
- **Keep tube walls at 0.7 mm or more** (0.4 nozzle). A 0.708 wall prints true; 0.60 printed as about 0.80 and grew the OD by about 0.17.
- **Friction is set by the radial gap between cartridge and tube** (0.2145 AA / 0.229 D). To change the OD, move the ID and the cartridge together.
- The printer (Bambu X1C) runs about 0.03 mm under on the OD when the wall is printable.
- Give every file a version in its name, so an old download can't be mistaken for a new one.
- The Battery Daddy slots vary from slot to slot and may taper. Settle the OD with full-depth test cups, stepping 0.2 mm at a time.

## Design principles
- A pocketed cartridge slides out of a closed-bottom tube. One cell per pocket, with 1.2 mm shelves between them so cells never touch.
- The shelves are trimmed at the front, about 17% of the cell diameter past the cell centre. The back spine is solid, with no push slot: cells tip out by gravity.
- **The walls never go past the cell's widest point.** The front half of every cell is exposed.
- **Bottom disc:** full cartridge diameter and 1.8 mm thick, with a 0.5 mm lead-in chamfer. Don't shrink its diameter.
- Snap-on cap: the cartridge head (core_r + 0.4) rests on the tube rim and has a groove; the cap's slotted skirt has a bead with 0.15 mm interference.
- Stacked label in a second color on the cap, printed face-down.
- The cartridge prints lying on its back. The tube prints upright.
- **Assembly height = battery height** (AA about 50.5, D about 61.5, minus 0.2), so the cartridge can't slide out when the case is inverted.

## Final fits
| | AA (v2.6, proven) | D (v2.8, proven) |
|---|---|---|
| Tube OD (model) | 14.23 (prints about 14.20) | 32.968 |
| Tube ID | 12.814 | 31.158 |
| Tube wall | 0.708 | 0.905 |
| Cartridge body dia | 12.385 | 30.70 |
| Cartridge-to-tube gap | 0.2145 radial | 0.229 radial |
| Head dia / on rim | 13.185 / 0.185 | 31.50 / 0.171 |
| Cap OD | 14.9 | 34.2 |

## Cells
| Cell | Size (dia × thick, max) | Slot | Cells | Total height | Label | Back spine |
|---|---|---|---|---|---|---|
| LR44 / AG13 / 357 | 11.6 × 5.4 | AA | 6 | 50.3 mm | LR / 44, 5.0 mm | 0.74 (e = 0.5, walls to 72°) |
| LR621 / AG1 / 364 | 6.8 × 2.15 | AA | 11 | 50.3 mm | LR / 621, 3.9 mm | 5.3 |
| LR754 / AG5 / 393 | 7.9 × 5.4 | AA | 6 | 50.3 mm | LR / 754, 4.1 mm | 4.2 |
| CR1620 | 16.0 × 2.0 | D | 15 | 61.3 mm | CR / 1620, 7.2 mm | 14.4 |
| CR2032 | 20.0 × 3.2 | D | 11 | 61.3 mm | CR / 2032, 7.2 mm | 10.4 |
| CR2025 | 20.0 × 2.5 | D | 13 | 61.3 mm | CR / 2025, 7.2 mm | 10.4 |

## Change log
- **v2.8:** The D tube OD went from 33.568 to 32.968 (fit-tested). The D tube ID, cartridge, head and snap moved in by 0.30 mm radius together; the wall (0.905) and the friction gap (0.229) are unchanged. The AA sleeves are unchanged, which was checked against the v2.6 meshes.
- **D fit test:** four test cups at 0.2 mm OD steps; 32.97 fit.
- **v2.7:** Added CR2032 and CR2025 (D slot).
- **v2.6:** The AA wall is back to 0.708 mm. The AA tube ID and the cartridge moved in by 0.1075 mm radius. This is the final AA version.
- **v2.5:** The AA OD went to 14.23 by thinning the wall to 0.60. This failed: it printed at about 0.8.
- **v2.4:** The tube fit is built in (no slicer scaling). Total height went to 50.3 (AA) / 61.3 (D).
- **v2.3:** The bottom disc is back to the full diameter, keeping 1.8 mm thickness and the chamfer.
- **v2.2:** The bottom disc went to 1.8 mm with a chamfer. The AA tube floor went to 0.6. The cartridge is one solid.
- **v2.1:** The LR621, LR754 and CR1620 side walls are cut back to the cell centre.
- **v2.0:** First generic model.

## Sources for cell dimensions
- Ansmann coin-cell datasheet: LR621 6.8 × 2.1, LR754 7.9 × 5.4, LR44 11.6 × 5.4
- Conrad/Voltcraft LR621 datasheet: maximum 6.8 × 2.15
- Farnell CR1620 datasheet: 15.7 to 16.0 dia × 1.8 to 2.0
- CR2032 / CR2025: standard 20 × 3.2 / 20 × 2.5

## Output files
`tools/build_all.py` (and the release workflow) produces:
- `BatteryDaddy_<CELL>_sleeve_v<X.Y>.3mf`: one Bambu plate per cell, with cartridge, tube and cap. The cap body uses filament 1 and the text uses filament 2.
- `stl/<CELL>_{core,tube,cap_body,cap_text}.stl`: plain STLs in print orientation.

## Ideas
- More cells: LR41, SR626, and 9V-slot versions
- Hollowing the thick back spine of the D cartridges to save filament
