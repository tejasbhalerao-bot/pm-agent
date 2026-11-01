#!/usr/bin/env python3
"""Bundle the Truemeds design system for a Claude artifact.

Artifacts cannot load local files, so the CSS, the font, the icon helper and the logo must be inlined.
Usage:  python3 scripts/ds_bundle.py <out_dir>
Writes: tm.css              truemeds.css with the Plus Jakarta Sans font inlined as a data URI
        tm-icons.js         design-system/icons/icons.js, unchanged
        logo-data-uri.txt   design-system/logo/truemeds-logo.svg as a data URI (the file itself is never edited)
Nothing in design-system/ is modified.
"""
import base64
import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
DS = REPO / "design-system"


def main(out):
    out = Path(out)
    out.mkdir(parents=True, exist_ok=True)

    css = (DS / "truemeds.css").read_text()
    font = base64.b64encode((DS / "fonts" / "plus-jakarta-sans-latin-wght-normal.woff2").read_bytes()).decode()
    css, n = re.subn(
        r'url\("fonts/plus-jakarta-sans-latin-wght-normal\.woff2"\)',
        f'url("data:font/woff2;base64,{font}")',
        css,
    )
    assert n == 1, "normal font face not found in truemeds.css"
    # the italic face is not used by the portal and would add 40 KB
    css = re.sub(r'@font-face \{[^}]*plus-jakarta-sans-latin-wght-italic\.woff2[^}]*\}\n?', "", css)
    (out / "tm.css").write_text(css)

    (out / "tm-icons.js").write_text((DS / "icons" / "icons.js").read_text())

    logo = base64.b64encode((DS / "logo" / "truemeds-logo.svg").read_bytes()).decode()
    (out / "logo-data-uri.txt").write_text(f"data:image/svg+xml;base64,{logo}")
    print(f"wrote {out}/tm.css ({len(css) // 1024} KB), tm-icons.js, logo-data-uri.txt")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    main(sys.argv[1])
