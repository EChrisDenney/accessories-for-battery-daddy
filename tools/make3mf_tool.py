"""Build Bambu-friendly 3MF plates: each object = one or more parts; cap = white body + blue text.

Copyright (c) 2026 Chris Denney. MIT License (see tools/LICENSE).
"""
import sys, zipfile, numpy as np, trimesh

def mesh_xml(m):
    v = "\n".join(f'<vertex x="{a:.4f}" y="{b:.4f}" z="{c:.4f}"/>' for a, b, c in m.vertices)
    t = "\n".join(f'<triangle v1="{a}" v2="{b}" v3="{c}"/>' for a, b, c in m.faces)
    return f"<mesh><vertices>\n{v}\n</vertices><triangles>\n{t}\n</triangles></mesh>"

def build(path, objects):
    """objects: list of (name, x, y, [(part_name, stl, extruder), ...])"""
    res, items, cfg = [], [], []
    oid = 1
    for name, x, y, parts in objects:
        meshes = [trimesh.load(stl) for _, stl, _ in parts]
        allv = np.vstack([m.vertices for m in meshes])
        cx, cy = (allv[:, 0].max() + allv[:, 0].min()) / 2, (allv[:, 1].max() + allv[:, 1].min()) / 2
        zmin = allv[:, 2].min()
        part_ids = []
        for (pname, _, ext), m in zip(parts, meshes):
            m = m.copy(); m.apply_translation([-cx, -cy, -zmin])
            res.append(f'<object id="{oid}" name="{pname}" type="model">{mesh_xml(m)}</object>')
            part_ids.append((oid, pname, ext)); oid += 1
        comps = "".join(f'<component objectid="{pid}"/>' for pid, _, _ in part_ids)
        res.append(f'<object id="{oid}" name="{name}" type="model"><components>{comps}</components></object>')
        items.append(f'<item objectid="{oid}" transform="1 0 0 0 1 0 0 0 1 {x} {y} 0" printable="1"/>')
        pcfg = "".join(
            f'<part id="{pid}" subtype="normal_part"><metadata key="name" value="{pn}"/>'
            f'<metadata key="extruder" value="{ex}"/></part>' for pid, pn, ex in part_ids)
        cfg.append(f'<object id="{oid}"><metadata key="name" value="{name}"/>'
                   f'<metadata key="extruder" value="1"/>{pcfg}</object>')
        oid += 1
    model = ('<?xml version="1.0" encoding="UTF-8"?>\n'
             '<model unit="millimeter" xml:lang="en-US" xmlns="http://schemas.microsoft.com/3dmanufacturing/core/2015/02">'
             '<metadata name="Title">Battery Daddy coin-cell sleeve</metadata>'
             f'<resources>{"".join(res)}</resources><build>{"".join(items)}</build></model>')
    ct = ('<?xml version="1.0" encoding="UTF-8"?>\n<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
          '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>'
          '<Default Extension="model" ContentType="application/vnd.ms-package.3dmanufacturing-3dmodel+xml"/>'
          '<Default Extension="config" ContentType="text/xml"/></Types>')
    rels = ('<?xml version="1.0" encoding="UTF-8"?>\n<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
            '<Relationship Target="/3D/3dmodel.model" Id="rel0" Type="http://schemas.microsoft.com/3dmanufacturing/2013/01/3dmodel"/></Relationships>')
    conf = '<?xml version="1.0" encoding="UTF-8"?>\n<config>' + "".join(cfg) + '</config>'
    with zipfile.ZipFile(path, "w", zipfile.ZIP_DEFLATED) as z:
        z.writestr("[Content_Types].xml", ct); z.writestr("_rels/.rels", rels)
        z.writestr("3D/3dmodel.model", model); z.writestr("Metadata/model_settings.config", conf)


# ---------------------------------------------------------------------------
# Workflow used for the Battery Daddy sleeves (see docs/coin-cell-sleeves.md).
# tools/build_all.py automates all of this for every cell.
#   1. Export parts with OpenSCAD (apt install openscad; xvfb-run for PNG renders):
#        openscad -o CR2032_core.stl     -D 'cell="CR2032"' -D 'part="core"'     battery_daddy_coin_sleeve.scad
#        openscad -o CR2032_tube.stl     -D 'cell="CR2032"' -D 'part="tube"'     battery_daddy_coin_sleeve.scad
#        openscad -o CR2032_cap_body.stl -D 'cell="CR2032"' -D 'part="cap_body"' battery_daddy_coin_sleeve.scad
#        openscad -o CR2032_cap_text.stl -D 'cell="CR2032"' -D 'part="cap_text"' battery_daddy_coin_sleeve.scad
#      (parts come out in print orientation; add -D print_orient=false for use orientation)
#   2. Build a plate (cap text -> filament 2 = blue). Put the version and the tube OD in names:
#        build("BatteryDaddy_CR2032_sleeve_vX.Y.3mf", [
#          ("CR2032_cartridge_vX.Y", 90, 128, [("CR2032_cartridge_vX.Y", "CR2032_core.stl", 1)]),
#          ("CR2032_tube_vX.Y_OD32.97", 135, 128, [("CR2032_tube_vX.Y_OD32.97", "CR2032_tube.stl", 1)]),
#          ("CR2032_cap_vX.Y", 180, 128, [("cap_body", "CR2032_cap_body.stl", 1), ("cap_text_CR2032", "CR2032_cap_text.stl", 2)])])
#   3. Verify: watertight, cartridge one body, tube OD/ID in the 3MF, no part overlap on the plate.
