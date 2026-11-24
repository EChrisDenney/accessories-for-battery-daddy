# Battery Daddy case: reference dimensions

Case: Battery Daddy, double-sided, 180 cells (76 AA, 72 AAA, 8 9V, 10 C, 8 D, 12 coin).

## Slots (first measurements, from the red plastic surface)
| Slot | Diameter | Depth | Notes |
|---|---|---|---|
| D | 34.2 mm | 39.5 mm | Probably a little off: tubes at 33.77 mm OD were too snug |
| AA | 14.9 mm | 28.2 mm | Varies from slot to slot (manufacturing tolerance); 14.54 mm OD tubes were snug in some |
| 9V | not measured yet | | |

The gap from the red surface to the clear cover was measured as 21.2 mm. That is probably low: a 50.5 mm AA standing in a 28.2 mm slot would reach 22.3 mm.

## What actually fits (from real prints)
- **Height:** use the battery's own height as the total sleeve height (AA about 50.5, D about 61.5; design at minus 0.2). Shorter sleeves (48.4 mm) let the cartridge slide out when the case was turned over.
- **AA tube OD:** 14.23 mm model, prints about 14.20 (v2.6). Earlier 14.41 to 14.54 mm prints were snug in some slots.
- **D tube OD:** 32.968 mm (v2.8, from a fit test with 0.2 mm steps). 33.77 mm was too snug.
- **Cartridge-in-tube friction:** about 0.21 to 0.23 mm radial clearance feels right. See [coin-cell-sleeves.md](coin-cell-sleeves.md).

## Sleeve concept
A "sleeve of cookies" holder for coin cells that goes in a D, AA or 9V slot. Pull it out, open it, take one cell, close it, put it back. The cell name is printed in a second color on top (blue on a white body) so it can be read through the clear lid.
