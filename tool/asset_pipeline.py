# -*- coding: utf-8 -*-
"""asset_pipeline — AI 美术资产管线（docs/06 §4 的可执行实现，纯标准库）。

子命令（可组合）：
  validate  校验 assets-src 下的文件命名/尺寸/透明度（对照 06 §3.4 命名规范）
  mirror    由 left.png 生成 right.png（水平镜像）
  manifest  生成 assets_manifest.json（路径/尺寸/SHA256，权属证据链用）
  todo      打印缺失清单（按类别统计，出图进度一览）
  deploy    把通过校验的资产复制进 app/assets/（放入即被 PetSprite 加载）

用法：python tool/asset_pipeline.py <command> [--src <assets-src 目录>] [--app <app 目录>]
"""
import hashlib
import json
import shutil
import struct
import sys
from pathlib import Path

EMOTIONS = ['anxious', 'emo', 'sloth', 'burnout', 'neikao',
            'chaos', 'distract', 'perfect', 'fomo', 'shy']
STAGES = {
    'st2': ['clear'],
    'st3': ['clear'],
    'st4': ['constellation', 'deepcurrent'],
}
DIRS = ['front', 'back', 'left', 'right']  # right 由 mirror 生成后一并部署
SEASONS = ['spring', 'summer', 'autumn', 'winter']
DAYNIGHT = ['day', 'night']
MAZE_TILES = ['floor', 'wall', 'start', 'exit', 'portal', 'door', 'trap',
              'shrine', 'warp', 'key', 'lantern']

PET_SPEC = {}          # 相对路径 -> 目标最长边
for e in EMOTIONS:
    for st, branches in STAGES.items():
        for br in branches:
            for d in DIRS:
                PET_SPEC[f'pets/{e}/{st}_{br}_{d}.png'] = 512
SCENE_SPEC = {
    **{f'island/map_{s}_{t}.png': 2048 for s in SEASONS for t in DAYNIGHT},
    **{f'maze/tile_{t}.png': 256 for t in MAZE_TILES},
}
SOUVENIR_IDS = ['cloudBell', 'windmillLamp', 'rainbowHoop', 'starChartScarf',
                'rainGauge', 'sunnyRainDoll', 'convectionFire', 'auroraVeil',
                'breeze_chime_stand', 'travel_mailbox', 'warm_night_campfire',
                'star_wish_swing', 'lotus_boat', 'fog_lamp_ornament',
                'shell_wind_chime', 'weather_house',
                'rainbow_arch', 'meteor_wishing_pool', 'aurora_curtain',
                'four_seasons_flower_clock']
ZONE_DIRS = ['shocking_storm_knot', 'stagnant_rain_knot', 'lost_fog_knot',
             'heavy_twilight_mist_knot', 'spiral_cloud_knot', 'chaotic_current_knot',
             'scattered_wind_knot', 'strict_frost_knot', 'misplaced_star_knot',
             'shy_sunset_knot']
EXTRA_SPEC = {
    **{f'souvenirs/{sid}.png': 256 for sid in SOUVENIR_IDS},
    **{f'maze/foes/{emotion}.png': 256 for emotion in EMOTIONS},
    **{f'bosses/{z}.png': 512 for z in ZONE_DIRS},
    **{f'travel/{n}.png': 512 for n in ['monsoon_short', 'trade_wind_halfday', 'polar_long']},
    **{f'postcards/{s}.png': 1200 for s in SEASONS},
    **{f'landmarks/{n}.png': 512 for n in [
        'sunny_meadow_flower_hill', 'sunny_meadow_picnic_cloth', 'rain_lake_wooden_pier',
        'rain_lake_lotus_boat', 'fog_forest_round_tree', 'fog_forest_lamp_post',
        'wind_cliff_pinwheel', 'wind_cliff_swing', 'beach_lighthouse', 'beach_shell_cluster']},
    **{f'items/icons/{n}.png': 256 for n in [
        'sun_crystal', 'stardust', 'morning_dew', 'rainbow_crystal', 'mist_dew',
        'warm_front', 'tailwind', 'heart_knot_shard', 'cloud_mica', 'lantern',
        'envelope', 'star_badge']},
    **{f'ui/tabs/{n}.png': 128 for n in ['island', 'todo', 'compendium', 'maze', 'growth']},
    **{f'ui/actions/{n}.png': 128 for n in [
        'complete', 'pin', 'delete', 'focus', 'start', 'undo', 'restart',
        'checkin', 'share', 'settings']},
    **{f'ui/difficulty/{n}.png': 128 for n in ['easy', 'steady', 'challenge']},
    **{f'ui/emotes/{n}.png': 128 for n in ['heart', 'music', 'happy', 'leaf', 'sparkle']},
    **{f'ui/feedback/{n}.png': 128 for n in ['relief', 'calm', 'proud', 'easier']},
    **{f'ui/sections/{n}.png': 128 for n in ['store', 'roam']},
    'ui/app_icon.png': 1024,
}
SPEC = {**PET_SPEC, **SCENE_SPEC, **EXTRA_SPEC}
# 豁免透明度：全出血背景/底砖类
NO_ALPHA_NEEDED = ('island/', 'maze/tile_floor.png', 'maze/tile_wall.png',
                   'postcards/', 'ui/app_icon.png')


def png_info(path: Path):
    """纯标准库读 PNG：返回 (宽, 高, 是否带 alpha) 或 None（非 PNG/损坏）。"""
    try:
        data = path.read_bytes()
        if data[:8] != b'\x89PNG\r\n\x1a\n':
            return None
        w, h = struct.unpack('>II', data[16:24])
        color_type = data[25]
        return (w, h, color_type in (4, 6))
    except Exception:
        return None


def cmd_validate(src: Path) -> int:
    bad, ok = [], 0
    for rel, max_edge in SPEC.items():
        f = src / rel
        if not f.exists():
            continue
        info = png_info(f)
        if info is None:
            bad.append(f'{rel}: 不是有效 PNG')
            continue
        w, h, alpha = info
        if max(w, h) > max_edge:
            bad.append(f'{rel}: {max(w,h)}px 超过目标 {max_edge}px（先缩放再部署）')
            continue
        needs_alpha = not any(rel.startswith(pre) or rel == pre
                              for pre in NO_ALPHA_NEEDED)
        if needs_alpha and not alpha:
            bad.append(f'{rel}: 无透明通道（需要 RGBA 抠底）')
            continue
        ok += 1
    print(f'[validate] {ok} 张合格，{len(bad)} 张不合格')
    for b in bad:
        print('  ✗ ' + b)
    return 0 if not bad else 1


def cmd_mirror(src: Path) -> int:
    """right = left 水平镜像。需要 Pillow；未安装则提示。"""
    try:
        from PIL import Image
    except ImportError:
        print('[mirror] 需要 Pillow：pip install pillow')
        return 1
    n = 0
    for rel in PET_SPEC:
        if not rel.endswith('_left.png'):
            continue
        left = src / rel
        if not left.exists():
            continue
        right = src / rel.replace('_left.png', '_right.png')
        if right.exists():
            continue
        Image.open(left).transpose(Image.FLIP_LEFT_RIGHT).save(right)
        n += 1
    print(f'[mirror] 生成 {n} 张 right 镜像')
    return 0


def cmd_manifest(src: Path) -> int:
    entries = []
    for f in sorted(src.rglob('*.png')):
        rel = f.relative_to(src).as_posix()
        info = png_info(f)
        data = f.read_bytes()
        entries.append({
            'path': rel,
            'size': [info[0], info[1]] if info else None,
            'bytes': len(data),
            'sha256': hashlib.sha256(data).hexdigest(),
        })
    out = src / 'assets_manifest.json'
    out.write_text(json.dumps({'generatedBy': 'tool/asset_pipeline.py',
                               'count': len(entries), 'assets': entries},
                              ensure_ascii=False, indent=1), encoding='utf-8')
    print(f'[manifest] 已写入 {out}（{len(entries)} 张）')
    return 0


def cmd_deploy(src: Path, app: Path) -> int:
    n = 0
    for rel in SPEC:
        f = src / rel
        if not f.exists():
            continue
        info = png_info(f)
        if info is None:
            continue
        needs_alpha = not any(rel.startswith(pre) or rel == pre
                              for pre in NO_ALPHA_NEEDED)
        if needs_alpha and not info[2]:
            continue  # 不合格不部署
        dst = app / 'assets' / rel
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(f, dst)
        n += 1
    print(f'[deploy] {n} 张已复制进 app/assets/（PetSprite 即时生效）')
    return 0


def cmd_todo(src: Path) -> int:
    groups = {}
    for rel in SPEC:
        cat = rel.split('/')[0]
        groups.setdefault(cat, [0, 0])
        groups[cat][1] += 1
        if (src / rel).exists():
            groups[cat][0] += 1
    total_have = sum(g[0] for g in groups.values())
    total_all = sum(g[1] for g in groups.values())
    print('[todo] 出图进度：')
    for cat, (have, allc) in sorted(groups.items()):
        bar = '█' * (have * 20 // allc if allc else 0)
        print(f'  {cat:<8} {have:>3}/{allc:<3} {bar}')
    print(f'  合计     {total_have}/{total_all}')
    # 缺失明细（前 12 条）
    missing = [rel for rel in SPEC if not (src / rel).exists()]
    for m in missing[:12]:
        print('  · ' + m)
    if len(missing) > 12:
        print(f'  … 还有 {len(missing) - 12} 张')
    return 0


def main() -> int:
    args = sys.argv[1:]
    if not args:
        print(__doc__)
        return 1
    cmd = args[0]
    def opt(flag, default):
        return Path(args[args.index(flag) + 1]) if flag in args else default
    here = Path(__file__).resolve().parent.parent  # Moodisle/
    src = opt('--src', here / 'assets-src')
    app = opt('--app', here / 'app')
    code = 0
    if cmd == 'validate':
        code = cmd_validate(src)
    elif cmd == 'mirror':
        code = cmd_mirror(src)
    elif cmd == 'manifest':
        code = cmd_manifest(src)
    elif cmd == 'deploy':
        code = cmd_deploy(src, app)
    elif cmd == 'todo':
        code = cmd_todo(src)
    elif cmd == 'all':
        code = cmd_validate(src)
        cmd_mirror(src)
        cmd_manifest(src)
        cmd_deploy(src, app)
    else:
        print(__doc__)
        code = 1
    return code


if __name__ == '__main__':
    sys.exit(main())
