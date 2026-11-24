# Context for Claude

3D-printable accessories for the Battery Daddy battery organizer. The owner is Chris. Read `README.md` first, then `docs/coin-cell-sleeves.md` (the main design reference).

## Status (2026-11-23)
- **AA coin-cell sleeves (LR44, LR621, LR754) are DONE.** v2.6 geometry was printed and confirmed perfect. **Don't change the AA sizing.**
- **D coin-cell sleeves (CR1620, CR2032, CR2025) are DONE.** v2.8 (tube OD 32.968 mm, from the fit test) was printed and confirmed to work. **Don't change the D sizing.**

## Working rules
- Chris prints on a Bambu X1C with AMS: white body (filament 1), blue label (filament 2).
- **Version every output file name** (`BatteryDaddy_CR2032_sleeve_v2.8.3mf`) and put the tube OD in the tube object name (`CR2032_tube_v2.8_OD32.97`). Bump the version on the first line of the `.scad` and add a change-log line there and in `docs/coin-cell-sleeves.md`. `tools/build_all.py` reads the version from line 1.
- **Tube walls must be 0.7 mm or more** or the slicer prints them oversized.
- **Friction = the radial gap between cartridge and tube** (AA 0.2145, D 0.229). To change the OD, move the tube ID, the cartridge, the head and the snap together.
- Before saying a change is done, run `python3 tools/build_all.py`. It checks that every part is watertight, that the cartridge is a single body, and that the tube OD is right.
- Ask Chris before big design changes. He wants quick, concrete iterations with test pieces.

## Git / release
- `build/` is gitignored. Releases are built by `.github/workflows/build.yml` when a `v*` tag is pushed (e.g. `git tag v2.8 && git push --tags`).
- License split: designs are CC BY-SA 4.0 (`LICENSE`); `tools/*.py` are MIT (`tools/LICENSE`). Keep the Ontel trademark disclaimer in the README.

## Ideas / backlog
- More cells: LR41, SR626, and 9V-slot versions (9V slot not measured yet)
- Hollowing the D cartridges' thick back spines to save filament
