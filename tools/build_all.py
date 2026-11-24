#!/usr/bin/env python3
"""Render every coin-cell sleeve to STL and build Bambu 3MF plates, then sanity-check the meshes.

Usage:
    python3 tools/build_all.py                 # all cells -> build/
    python3 tools/build_all.py CR2032 LR44     # just these cells
    OPENSCAD=/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD python3 tools/build_all.py

Needs: OpenSCAD on PATH (or $OPENSCAD), the DejaVu Sans font, and `pip install trimesh numpy`.

Copyright (c) 2026 Chris Denney. MIT License (see tools/LICENSE).
"""
import os, re, subprocess, sys
from pathlib import Path

import trimesh

sys.path.insert(0, str(Path(__file__).resolve().parent))
from make3mf_tool import build  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
SCAD = ROOT / "coin-cell-sleeve" / "battery_daddy_coin_sleeve.scad"
OUT = ROOT / "build"
OPENSCAD = os.environ.get("OPENSCAD", "openscad")

CELLS = {  # cell -> slot (must match the presets in the .scad)
    "LR44": "AA", "LR621": "AA", "LR754": "AA",
    "CR1620": "D", "CR2032": "D", "CR2025": "D",
}
TUBE_OD = {"AA": "14.23", "D": "32.97"}  # goes into the tube object name
PARTS = ["core", "tube", "cap_body", "cap_text"]


def version():
    m = re.search(r"v(\d+\.\d+)", SCAD.read_text().splitlines()[0])
    if not m:
        sys.exit("Could not find a version (vX.Y) on the first line of the .scad")
    return m.group(1)


def render(cell, part):
    stl = OUT / "stl" / f"{cell}_{part}.stl"
    stl.parent.mkdir(parents=True, exist_ok=True)
    cmd = [OPENSCAD, "-o", str(stl), "-D", f'cell="{cell}"', "-D", f'part="{part}"', str(SCAD)]
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode != 0 or not stl.exists():
        sys.exit(f"OpenSCAD failed for {cell} {part}:\n{r.stderr}")
    return stl


def check(cell, slot, stls):
    problems = []
    for part, stl in stls.items():
        m = trimesh.load(stl)
        if not m.is_watertight:
            problems.append(f"{cell} {part}: not watertight")
        if part == "core" and len(m.split(only_watertight=False)) != 1:
            problems.append(f"{cell} cartridge: not a single body")
        if part == "tube":
            od = m.extents[0]
            want = float(TUBE_OD[slot])
            if abs(od - want) > 0.02:
                problems.append(f"{cell} tube OD {od:.3f} != {want}")
    return problems


def main():
    cells = sys.argv[1:] or list(CELLS)
    unknown = [c for c in cells if c not in CELLS]
    if unknown:
        sys.exit(f"Unknown cell(s): {unknown}. Known: {list(CELLS)}")
    v = version()
    (OUT / "3mf").mkdir(parents=True, exist_ok=True)
    problems = []
    for cell in cells:
        slot = CELLS[cell]
        print(f"[{cell}] rendering v{v} ...", flush=True)
        stls = {p: render(cell, p) for p in PARTS}
        problems += check(cell, slot, stls)
        tube_name = f"{cell}_tube_v{v}_OD{TUBE_OD[slot]}"
        build(str(OUT / "3mf" / f"BatteryDaddy_{cell}_sleeve_v{v}.3mf"), [
            (f"{cell}_cartridge_v{v}", 83, 128, [(f"{cell}_cartridge_v{v}", stls["core"], 1)]),
            (tube_name, 128, 128, [(tube_name, stls["tube"], 1)]),
            (f"{cell}_cap_v{v}", 173, 128, [("cap_body", stls["cap_body"], 1),
                                            (f"cap_text_{cell}", stls["cap_text"], 2)]),
        ])
    if problems:
        print("\nPROBLEMS:\n  " + "\n  ".join(problems))
        sys.exit(1)
    print(f"\nOK: {len(cells)} sleeve(s) in {OUT.relative_to(ROOT)}/ (STL in stl/, Bambu plates in 3mf/)")


if __name__ == "__main__":
    main()
