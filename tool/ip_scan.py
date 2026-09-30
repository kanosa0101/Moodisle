# -*- coding: utf-8 -*-
"""ip_scan — 清洁室禁用词全文扫描（docs/00 §4/§8 的 CI 门禁实现）。

用法：python tool/ip_scan.py <项目根目录>
扫描 Moodisle/app 下 lib/ 与 test/ 的 Dart 源码 + docs/ 文案（09 除外），
命中禁用词表即非零退出。美术文件名由 manifest 校验脚本另行把关。
"""
import re
import sys
from pathlib import Path

# docs/00 §4 禁用词表（参考原型的专有表达；大小写不敏感）
BANNED = [
    # 原型精灵名
    "冲冲鼠", "安安獭", "暖暖灵", "专专喵", "理理章", "松松团", "容容獭",
    "定定喵", "朗朗灵", "元元鼠",
    "zippy", "flowisland", "flow_island",
    # 原型系统/道具命名
    "山海经·神兽线", "克苏鲁·深海线", "守护星屑", "心岛微光", "进化精华",
    "远古遗物", "灵感宝箱", "心流疏导链", "心流连击", "flowisland_save_v1",
    "守护者等级", "守护者经验",
]

SKIP_DIRS = {"build", ".dart_tool", "node_modules", ".git", "heartfly"}

def iter_files(root: Path):
    for sub in ("app/lib", "app/test", "docs", "assets-src"):
        d = root / sub
        if not d.exists():
            continue
        for p in d.rglob("*"):
            if not p.is_file():
                continue
            if any(part in SKIP_DIRS for part in p.parts):
                continue
            if p.suffix.lower() in {".dart", ".md", ".yaml", ".json", ".py"}:
                yield p

def main() -> int:
    root = Path(sys.argv[1] if len(sys.argv) > 1 else ".").resolve()
    hits = []
    pattern = re.compile("|".join(re.escape(w) for w in BANNED), re.IGNORECASE)
    for f in iter_files(root):
        try:
            text = f.read_text(encoding="utf-8")
        except Exception:
            continue
        for i, line in enumerate(text.splitlines(), 1):
            m = pattern.search(line)
            if m:
                # 合法上下文：本脚本自身、禁用词表定义文档
                if f.name == "ip_scan.py" or "00-版权" in str(f):
                    continue
                hits.append(f"{f.relative_to(root)}:{i}: {m.group(0)}")
    if hits:
        print(f"[ip_scan] FAIL — {len(hits)} 处命中禁用词：")
        for h in hits:
            print("  " + h)
        return 1
    print("[ip_scan] PASS — 无禁用词命中（清洁室检查通过）")
    return 0

if __name__ == "__main__":
    sys.exit(main())
