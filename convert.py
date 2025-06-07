from fontTools.ttLib import TTFont
from fontTools.merge import Merger
import os
import re
from pathlib import Path

dm_mono = Path(os.getenv("DM_MONO"))
scp = Path(os.getenv("SAUCECODE"))
out = Path(os.getenv("out")) / "share" / "fonts" / "truetype"

out.mkdir(parents=True, exist_ok=False)

for p in dm_mono.glob("*.ttf"):
    variant = re.match("DM Mono Nerd Font (.*).ttf", p.name)[1]
    print(variant)
    Merger().merge(
        [
            dm_mono / f"DM Mono Nerd Font {variant}.ttf",
            scp / f"SauceCodeProNerdFontMono-{variant.replace(' ','')}.ttf",
            dm_mono / f"DM Mono Nerd Font {variant}.ttf",
        ]
    ).save(out / f"DM Mono Nerd Font {variant}.ttf")
