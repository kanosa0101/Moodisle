# -*- coding: utf-8 -*-
"""intake v2 — 运行时立绘全量 + 纪念品/Boss/图标/航线/明信片 接入。

命名映射（生成名 → 项目规范）：
  spirits/runtime/{nn}_{en}/st2_sunny_{dir}      → pets/{e}/st2_clear_{dir}.png
  spirits/runtime/{nn}_{en}/st3_rainbow_{dir}    → pets/{e}/st3_clear_{dir}.png
  spirits/runtime/{nn}_{en}/st4_{branch}_{dir}   → pets/{e}/st4_{branch}_{dir}.png
  items/souvenirs/{kind}/{snake}.png             → souvenirs/{id}.png（resize 256）
  scenes/bosses/current/{snake}_knot.png         → bosses/{snake}_knot.png（resize 512）
  scenes/travel_routes/current/*.png             → travel/（名同 SPEC）
  scenes/postcard_templates/{s}.png              → postcards/{s}.png（原尺寸）
  items/icons/{snake}.png                        → items/icons/{snake}.png（256）
  ui/icons/{tabs,actions}/{n}.png                → ui/{tabs,actions}/{n}.png（128）
"""
import sys
from pathlib import Path
from PIL import Image

SRC = Path(r'C:/Users/14376/Downloads/picture')
DST = Path(__file__).resolve().parent.parent / 'assets-src'

EMOTION_BY_NAME = {
    'zappy': 'anxious', 'drippy': 'emo', 'misty': 'sloth', 'hazy': 'burnout',
    'nimbus': 'neikao', 'swirly': 'chaos', 'breezy': 'distract',
    'frosty': 'perfect', 'starry': 'fomo', 'rosy': 'shy',
}

SOUVENIR_MAP = {
    'cloud_bell': 'cloudBell', 'pinwheel_lamp': 'windmillLamp',
    'rainbow_ring': 'rainbowHoop', 'star_chart_scarf': 'starChartScarf',
    'rain_gauge_cup': 'rainGauge', 'sun_rain_doll': 'sunnyRainDoll',
    'cloud_campfire': 'convectionFire', 'aurora_gauze': 'auroraVeil',
    'breeze_chime_stand': 'breeze_chime_stand', 'travel_mailbox': 'travel_mailbox',
    'warm_night_campfire': 'warm_night_campfire', 'star_wish_swing': 'star_wish_swing',
    'lotus_boat': 'lotus_boat', 'lotus_boat_ornament': 'lotus_boat', 'fog_lamp_ornament': 'fog_lamp_ornament',
    'shell_wind_chime': 'shell_wind_chime', 'weather_house': 'weather_house',
    'rainbow_arch': 'rainbow_arch', 'meteor_wishing_pool': 'meteor_wishing_pool',
    'aurora_curtain': 'aurora_curtain', 'four_seasons_flower_clock': 'four_seasons_flower_clock',
}

def square_resize(img: Image.Image, edge: int) -> Image.Image:
    img = img.convert('RGBA')
    bbox = img.getbbox()
    if bbox:
        img = img.crop(bbox)
    side = max(img.size)
    sq = Image.new('RGBA', (side, side), (0, 0, 0, 0))
    sq.paste(img, ((side - img.width) // 2, (side - img.height) // 2))
    return sq.resize((edge, edge), Image.LANCZOS)

def save(img: Image.Image, rel: str, edge: int | None = None) -> None:
    out = DST / rel
    out.parent.mkdir(parents=True, exist_ok=True)
    if edge is None:
        img.convert('RGBA').save(out)
    else:
        square_resize(img, edge).save(out)

def main() -> int:
    n = 0
    # 1. 运行时立绘全量（160）
    runtime = SRC / 'spirits/runtime'
    for folder in sorted(runtime.iterdir()):
        if not folder.is_dir():
            continue
        en = folder.name.split('_', 1)[-1]
        emotion = EMOTION_BY_NAME.get(en)
        if emotion is None:
            print(f'  ! 未知：{folder.name}')
            continue
        for f in sorted(folder.glob('st*_*.png')):
            stem = f.stem.replace('sunny', 'clear').replace('rainbow', 'clear')
            save(Image.open(f), f'pets/{emotion}/{stem}.png', 512)
            n += 1
    # 2. 纪念品（20）
    for kind_dir in ('pendants', 'decorations', 'atmosphere'):
        d = SRC / 'items/souvenirs' / kind_dir
        if not d.exists():
            continue
        for f in sorted(d.glob('*.png')):
            sid = SOUVENIR_MAP.get(f.stem)
            if sid is None:
                print(f'  ! 未知纪念品：{f.name}')
                continue
            save(Image.open(f), f'souvenirs/{sid}.png', 256)
            n += 1
    # 3. Boss（10）
    bosses = SRC / 'scenes/bosses/current'
    if bosses.exists():
        for f in sorted(bosses.glob('*.png')):
            save(Image.open(f), f'bosses/{f.name}', 512)
            n += 1
    # 4. 云游航线（3）
    travel = SRC / 'scenes/travel_routes/current'
    if travel.exists():
        for f in sorted(travel.glob('*.png')):
            save(Image.open(f), f'travel/{f.name}', 512)
            n += 1
    # 5. 明信片模板（4）
    pc = SRC / 'scenes/postcard_templates'
    if pc.exists():
        for f in sorted(pc.glob('*.png')):
            save(Image.open(f), f'postcards/{f.name}', None)
            n += 1
    # 6. 地标（10）
    marks = SRC / 'scenes/landmarks/current'
    if marks.exists():
        for f in sorted(marks.glob('*.png')):
            save(Image.open(f), f'landmarks/{f.name}', 512)
            n += 1
    # 7. 道具图标（12）
    icons = SRC / 'items/icons'
    if icons.exists():
        for f in sorted(icons.glob('*.png')):
            save(Image.open(f), f'items/icons/{f.name}', 256)
            n += 1
    # 8. UI 图标（15）
    for sub in ('tabs', 'actions'):
        d = SRC / 'ui/icons' / sub
        if not d.exists():
            continue
        for f in sorted(d.glob('*.png')):
            save(Image.open(f), f'ui/{sub}/{f.name}', 128)
            n += 1
    print(f'[intake-v2] 共接入 {n} 张')
    return 0

if __name__ == '__main__':
    sys.exit(main())
