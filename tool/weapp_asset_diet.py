# -*- coding: utf-8 -*-
"""weapp_asset_diet — 微信小程序构建期资产瘦身（仅构建流程内原地变换，仓库资产不变）。

mp-flutter 小程序包体硬限：主包/单包 ≤2MB、总包 ≤30MB；app/assets 当前约 94MB，
必须先瘦身才能通过构建（详见 docs/superpowers/plans/2026-10-24-wechat-miniprogram.md M2）。
本脚本只在 CI 的临时 checkout 内运行（在 GitHub Actions 的 build 步骤前执行），
本地如需评估体积请使用 --dry-run，不要把变换结果提交回仓库。

行为：
  1. 剔除 assets/audio/ 下的音频文件（小程序当前无音频，M7 补齐后改为转码回包）；
     目录以空的 .keep 占位，保证 pubspec 中登记的资源目录仍然存在。
  2. PNG 就地重编码：宽度超过档位上限的先降采样，再量化为 256 色调色板 PNG
     （保留透明通道，Floyd-Steinberg 抖动抑制渐变色带）。
  3. --drop-fonts 可同时剔除内置字体子集（字体 A/B 实验的 B 案：改用工具自带 pkg-cjk）。

用法：
  python tool/weapp_asset_diet.py report [--app app]        # 只读报告（不改动任何文件）
  python tool/weapp_asset_diet.py apply  [--app app]        # 原地瘦身（仅限 CI 临时目录）
  python tool/weapp_asset_diet.py check  [--app app]        # 校验瘦身后体积是否达标（超预算非零退出）

依赖 Pillow（量化与缩放）；报告模式仅做尺寸统计，同样需要 Pillow 读取 PNG 头。
"""
import argparse
import sys
from pathlib import Path

try:
    from PIL import Image
except ImportError:  # pragma: no cover - 环境缺依赖时的可读报错
    Image = None

# 各目录的物理宽度上限（px）。应用为 460 逻辑宽的单列布局，
# 1024/768 已覆盖 2x~3x 屏幕密度；其余目录现状均 ≤512，维持原尺寸只做量化。
WIDTH_CAPS = {
    "island": 1024,
    "postcards": 768,
    "ui": 768,
}
DEFAULT_CAP = 512
QUANTIZE_COLORS = 256
# 图片总体积预算（MB）。总包 30MB 需再容纳代码分片、CanvasKit wasm 与 CJK 字体分包。
IMAGE_BUDGET_MB = 20.0
AUDIO_DIR = "audio"
FONTS_DIR = "fonts"
KEEP_NAME = ".keep"


def _png_files(assets: Path):
    return sorted(p for p in assets.rglob("*.png") if p.is_file())


def _dir_key(assets: Path, path: Path) -> str:
    rel = path.relative_to(assets)
    return rel.parts[0] if len(rel.parts) > 1 else "(root)"


def report(assets: Path) -> int:
    """只读统计：各目录文件数、体积与最大宽度。"""
    if Image is None:
        print("需要 Pillow：python -m pip install Pillow", file=sys.stderr)
        return 2
    groups: dict[str, list[int]] = {}
    for p in _png_files(assets):
        with Image.open(p) as img:
            width = img.width
        key = _dir_key(assets, p)
        size, count = groups.get(key, (0, 0))
        groups[key] = (size + p.stat().st_size, count + 1)
    print(f"{'目录':<14}{'文件数':>8}{'MB':>9}")
    total = total_count = 0
    for key, (size, count) in sorted(groups.items(), key=lambda kv: -kv[1][0]):
        print(f"{key:<14}{count:>8}{size / 1048576:>9.1f}")
        total += size
        total_count += count
    print(f"PNG 合计：{total_count} 个 / {total / 1048576:.1f} MB（预算 {IMAGE_BUDGET_MB:.0f} MB）")
    return 0


def _reencode(path: Path, cap: int) -> tuple[int, int]:
    """单张 PNG 降采样+量化重写，返回 (原字节数, 新字节数)。"""
    original = path.stat().st_size
    with Image.open(path) as img:
        img.load()
        if img.width > cap:
            height = round(img.height * cap / img.width)
            img = img.resize((cap, height), Image.LANCZOS)
        if img.mode != "RGBA":
            img = img.convert("RGBA")
        quantized = img.quantize(
            colors=QUANTIZE_COLORS,
            method=Image.Quantize.FASTOCTREE,
            dither=Image.Dither.FLOYDSTEINBERG,
        )
        quantized.save(path, format="PNG", optimize=True)
    return original, path.stat().st_size


def _clear_dir_keep_placeholder(directory: Path) -> int:
    """清空目录内文件并留 .keep 占位，返回删除的字节数。"""
    removed = 0
    if not directory.is_dir():
        return 0
    for entry in sorted(directory.rglob("*")):
        if entry.is_file():
            removed += entry.stat().st_size
            entry.unlink()
    keep = directory / KEEP_NAME
    if not keep.exists():
        keep.write_bytes(b"")
    return removed


def _strip_optional_dirs(assets: Path, dirs: list[tuple[str, str]], dry_run: bool) -> None:
    """剔除可选目录（音频/字体），dry_run 只打印不删除。"""
    for name, label in dirs:
        directory = assets / name
        if not directory.is_dir():
            continue
        if dry_run:
            removed = sum(f.stat().st_size for f in directory.rglob("*") if f.is_file())
            print(f"[dry-run] 将剔除{label} {name}/：-{removed / 1048576:.1f} MB")
        else:
            removed = _clear_dir_keep_placeholder(directory)
            print(f"剔除{label} {name}/：-{removed / 1048576:.1f} MB（保留 {KEEP_NAME} 占位）")


def apply(assets: Path, *, keep_audio: bool, drop_fonts: bool, dry_run: bool) -> int:
    """原地瘦身（dry_run 时只打印预估不写文件）。返回 0 表示正常结束。"""
    if Image is None:
        print("需要 Pillow：python -m pip install Pillow", file=sys.stderr)
        return 2
    if not assets.is_dir():
        print(f"资源目录不存在：{assets}", file=sys.stderr)
        return 2

    optional: list[tuple[str, str]] = []
    if not keep_audio:
        optional.append((AUDIO_DIR, "音频"))
    if drop_fonts:
        optional.append((FONTS_DIR, "字体"))
    _strip_optional_dirs(assets, optional, dry_run)

    per_dir: dict[str, list[int]] = {}
    total_before = total_after = 0
    downscaled = 0
    for png in _png_files(assets):
        key = _dir_key(assets, png)
        cap = WIDTH_CAPS.get(key, DEFAULT_CAP)
        if dry_run:
            with Image.open(png) as img:
                if img.width > cap:
                    downscaled += 1
            before = after = png.stat().st_size
        else:
            before, after = _reencode(png, cap)
        size_before, size_after = per_dir.get(key, (0, 0))
        per_dir[key] = (size_before + before, size_after + after)
        total_before += before
        total_after += after

    print(f"{'目录':<14}{'原 MB':>9}{'新 MB':>9}{'压缩比':>8}")
    for key, (b, a) in sorted(per_dir.items(), key=lambda kv: -kv[1][0]):
        print(f"{key:<14}{b / 1048576:>9.1f}{a / 1048576:>9.1f}{(a / b if b else 0):>8.0%}")
    if dry_run:
        print(f"[dry-run] {downscaled} 张将降采样；量化收益需 apply 后才能准确测量，"
              f"当前 PNG 总量 {total_after / 1048576:.1f} MB（预算 {IMAGE_BUDGET_MB:.0f} MB）")
    else:
        print(f"PNG 实际合计：{total_before / 1048576:.1f} MB -> {total_after / 1048576:.1f} MB"
              f"（预算 {IMAGE_BUDGET_MB:.0f} MB）")
    return 0


def check(assets: Path) -> int:
    """体积门禁：PNG 总量超预算时非零退出（供 CI 在 apply 后调用）。"""
    total = sum(p.stat().st_size for p in _png_files(assets))
    mb = total / 1048576
    print(f"PNG 总量 {mb:.1f} MB / 预算 {IMAGE_BUDGET_MB:.0f} MB")
    if mb > IMAGE_BUDGET_MB:
        print("超出图片体积预算", file=sys.stderr)
        return 1
    return 0


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(description="微信小程序构建期资产瘦身")
    parser.add_argument("command", choices=["report", "apply", "check"])
    parser.add_argument("--app", default="app", help="应用目录（默认 app）")
    parser.add_argument("--keep-audio", action="store_true",
                        help="保留音频（M7 音频回包后使用）")
    parser.add_argument("--drop-fonts", action="store_true",
                        help="同时剔除内置字体子集（字体 B 案实验）")
    parser.add_argument("--dry-run", action="store_true", help="不写任何文件，仅打印预估")
    args = parser.parse_args(argv)

    assets = Path(args.app) / "assets"
    if args.command == "report":
        return report(assets)
    if args.command == "check":
        return check(assets)
    return apply(assets, keep_audio=args.keep_audio,
                 drop_fonts=args.drop_fonts, dry_run=args.dry_run)


if __name__ == "__main__":
    sys.exit(main())
