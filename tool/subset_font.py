#!/usr/bin/env python3
"""打包中文子集字体：收集工程实际用字，用 fonttools 把全量 Noto Sans SC 裁成子集。

背景：Flutter Web 缺字时会按需从 fonts.gstatic.com 下载回退字体，完全离线的
首次访问会显示方块。把应用内实际用到的字符打成子集随包分发后，界面文本不再
依赖网络；用户输入的集外字符仍走系统/在线回退，不影响功能。

用法（项目根目录）：
    python tool/subset_font.py            # 收集用字并生成子集到 app/assets/fonts/
    python tool/subset_font.py --check    # 仅打印用字与覆盖统计，不写文件

前置：pip install fonttools；
全量字体 assets-src/fonts/NotoSansSC-{400,700}-full.ttf（SIL OFL 1.0 授权，
可再分发与子集化；下载方式见 docs/06-AI美术资产管线.md 字体小节）。
"""

from __future__ import annotations

import sys
from pathlib import Path

from fontTools import subset

ROOT = Path(__file__).resolve().parent.parent
SRC_DIRS = [ROOT / "app" / "lib", ROOT / "docs", ROOT / "app" / "test"]
SRC_FILES = [ROOT / "README.md", ROOT / "app" / "README.md"]

# 全量字体 → 子集输出（family 声明见 app/pubspec.yaml）
FONTS = [
    (ROOT / "assets-src/fonts/NotoSansSC-400-full.ttf",
     ROOT / "app/assets/fonts/NotoSansSC-Regular-Subset.ttf"),
    (ROOT / "assets-src/fonts/NotoSansSC-700-full.ttf",
     ROOT / "app/assets/fonts/NotoSansSC-Bold-Subset.ttf"),
]
CHARSET_OUT = ROOT / "assets-src/process/font_charset.txt"

# 界面中会出现的标点、符号与全角形态（源码扫描之外的兜底）
EXTRA_CHARS = (
    "，。、！？：；…—·「」『』（）《》〈〉【】“”‘’～"
    "×★☆✓✗←→↑↓％＋－＝℃℃°①②③④⑤⑥⑦⑧⑨⑩"
)


def collect_chars() -> str:
    chars: set[str] = set(EXTRA_CHARS)
    files: list[Path] = []
    for d in SRC_DIRS:
        files += sorted(p for p in d.rglob("*.dart") if p.is_file())
        files += sorted(p for p in d.rglob("*.md") if p.is_file())
    files += [p for p in SRC_FILES if p.is_file()]
    for path in files:
        try:
            chars |= set(path.read_text(encoding="utf-8"))
        except (OSError, UnicodeDecodeError) as exc:
            print(f"[skip] {path}: {exc}")
    chars |= {chr(c) for c in range(0x20, 0x7F)}  # 可打印 ASCII 全量保留
    chars.discard("\n")
    chars.discard("\r")
    chars.discard("\t")
    return "".join(sorted(chars))


def build_subset(src: Path, dst: Path, text: str) -> tuple[int, int]:
    options = subset.Options()
    options.name_IDs = ["*"]
    options.name_legacy = True
    options.name_languages = ["*"]
    options.notdef_outline = True
    options.glyph_names = False
    options.hinting = True

    font = subset.load_font(str(src), options)
    ss = subset.Subsetter(options=options)
    ss.populate(text=text)
    ss.subset(font)
    dst.parent.mkdir(parents=True, exist_ok=True)
    subset.save_font(font, str(dst), options)
    return font["maxp"].numGlyphs, dst.stat().st_size


def main() -> int:
    check_only = "--check" in sys.argv
    text = collect_chars()
    cjk = sum(1 for ch in text if ord(ch) > 0x2E7F)
    print(f"用字统计：共 {len(text)} 个唯一字符（其中 CJK 约 {cjk} 个）")
    CHARSET_OUT.parent.mkdir(parents=True, exist_ok=True)
    CHARSET_OUT.write_text(text, encoding="utf-8")

    if check_only:
        return 0
    for src, dst in FONTS:
        if not src.is_file():
            print(f"[缺文件] {src} — 先按 docs/06 下载全量字体")
            return 1
        glyphs, size = build_subset(src, dst, text)
        src_mb = src.stat().st_size / 1_048_576
        dst_mb = size / 1_048_576
        print(
            f"[ok] {dst.name}: {glyphs} 字形, {dst_mb:.2f} MB"
            f"（全量 {src_mb:.1f} MB → {dst_mb / src_mb:.0%}）"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
