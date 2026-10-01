#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""逐资产台账生成与交叉核对（docs/00 §版权卫生 要求）。

generate 模式：按 assets_manifest.json 的 322 项资产，依据 ledger.md 各批次
记录与 tool/intake_picture.py 的映射规则，推导出逐资产的来源字段，
写入 assets-src/ledger_per_asset.csv。
audit 模式：核对既有 CSV 覆盖 manifest 全部路径且字段完整，缺漏即非零退出。

用法：
    python tool/generate_ledger_per_asset.py generate
    python tool/generate_ledger_per_asset.py audit
"""
import csv
import json
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
MANIFEST = REPO / "assets-src" / "assets_manifest.json"
CSV_PATH = REPO / "assets-src" / "ledger_per_asset.csv"

HEADER = [
    "path", "batch_date", "batch_title", "source", "tool_or_model",
    "prompt_ref", "seed_or_parameters", "postprocess", "operator",
]

INTAKE = {
    "source": "用户提供图（Downloads/picture）+ 自动管线接入",
    "tool_or_model": "tool/intake_picture.py（改名/缩放）+ tool/asset_pipeline.py（validate/manifest/deploy）",
    "prompt_ref": "不适用（用户提供原图，非本项目 AI 生成）",
    "seed_or_parameters": "不适用",
    "operator": "自动管线（用户出图 + Claude 接入）",
}
IMAGEGEN = {
    "source": "本项目 AI 生成（Codex 内置 image_gen.imagegen）",
    "tool_or_model": "Codex 内置 image_gen.imagegen；tool/slice_atlases.py 切片；tool/asset_pipeline.py 校验部署",
    "prompt_ref": "见 assets-src/prompts/ 对应文件",
    "seed_or_parameters": "未提供（工具未返回可记录 seed）",
    "operator": "自动管线（Claude 生成接入）",
}


def batch_for(path: str) -> dict:
    first = path.split("/")[0]
    rest = path.split("/", 1)[1] if "/" in path else ""
    if first == "maze":
        return {
            "batch_date": "2026-09-27", "batch_title": "回廊 tile、天气怪物统一绘制",
            "prompt_ref": "prompts/maze_tile_atlas.txt、maze_floor_seamless.txt、maze_foe_atlas.txt",
            "postprocess": "slice_atlases.py 4×4 行优先切片，裁边置中缩放；floor/wall 对边周期混合",
            **IMAGEGEN,
        }
    if first == "ui" and rest.startswith("difficulty/"):
        return {
            "batch_date": "2026-09-27", "batch_title": "任务难度图标生成",
            "prompt_ref": "prompts/ui_difficulty_easy.txt、ui_difficulty_steady.txt、ui_difficulty_challenge.txt",
            "postprocess": "裁透明边、方形补透明底、Lanczos 缩至 128px",
            **IMAGEGEN,
        }
    if first == "ui" and rest == "app_icon.png":
        return {
            "batch_date": "2026-09-27", "batch_title": "Moodisle 应用图标生成",
            "prompt_ref": "prompts/ui_app_icon.txt",
            "postprocess": "Lanczos 缩放并派生 Android mipmap 与 Web 图标",
            **IMAGEGEN,
        }
    if first == "ui":
        return {
            "batch_date": "2026-09-27", "batch_title": "回廊批次 UI 贴纸（emotes/feedback/sections/tabs/actions）",
            "prompt_ref": "prompts/ui_sticker_atlas.txt",
            "postprocess": "slice_atlases.py 切片，裁边置中缩放 128px",
            **IMAGEGEN,
        }
    if first == "pets" and "/st2_clear_" in path:
        return {
            "batch_date": "2026-09-26", "batch_title": "首批接入（canon_views 三视图 + 镜像）",
            "postprocess": "改名映射 + mirror 生成 right 视图；尺寸规格校验",
            **INTAKE,
        }
    if first == "pets":
        return {
            "batch_date": "2026-09-27", "batch_title": "第二批接入（spirits/runtime 立绘全量）",
            "postprocess": "改名映射（sunny/rainbow → clear），尺寸规格校验",
            **INTAKE,
        }
    if first == "island":
        return {
            "batch_date": "2026-09-26", "batch_title": "首批接入（四季昼夜岛图直拷）",
            "postprocess": "1536×1024 原尺寸直拷",
            **INTAKE,
        }
    if first == "canon":
        return {
            "batch_date": "2026-09-26", "batch_title": "首批归档（canon_sheets 设定图）",
            "postprocess": "原样归档于 assets-src/canon/（V2 接线前不进运行时）",
            **INTAKE,
        }
    if first in ("bosses", "souvenirs", "items", "travel", "postcards", "landmarks"):
        return {
            "batch_date": "2026-09-27", "batch_title": "第二批接入（纪念品/Boss/图标/航线/明信片/地标）",
            "postprocess": "按 intake 映射改名并缩放（souvenirs 256、bosses 512、postcards 原尺寸）",
            **INTAKE,
        }
    if first == "process":
        return {
            "batch_date": "2026-09-27", "batch_title": "回廊批次过程图留档（图集原图/无缝底图）",
            "prompt_ref": "prompts/maze_tile_atlas.txt、maze_floor_seamless.txt",
            "postprocess": "原始图集副本，供追溯",
            **IMAGEGEN,
        }
    return {
        "batch_date": "未知", "batch_title": "未匹配批次（需人工补录）",
        "prompt_ref": "待补", "postprocess": "待补",
        "source": "待补", "tool": "待补", "seed": "待补", "operator": "待补",
    }


def generate() -> int:
    assets = json.loads(MANIFEST.read_text(encoding="utf-8"))["assets"]
    unknown = []
    with CSV_PATH.open("w", newline="", encoding="utf-8-sig") as fh:
        writer = csv.DictWriter(fh, fieldnames=HEADER)
        writer.writeheader()
        for asset in assets:
            row = batch_for(asset["path"])
            if row["batch_date"] == "未知":
                unknown.append(asset["path"])
            writer.writerow({"path": asset["path"], **row})
    print(f"[ledger_per_asset] 已写入 {len(assets)} 行 → {CSV_PATH.relative_to(REPO)}")
    if unknown:
        print(f"[ledger_per_asset] 未匹配批次 {len(unknown)} 项：{unknown[:5]}")
        return 1
    print("[ledger_per_asset] 全部资产已匹配到批次")
    return 0


def audit() -> int:
    assets = json.loads(MANIFEST.read_text(encoding="utf-8"))["assets"]
    with CSV_PATH.open(encoding="utf-8-sig") as fh:
        rows = {r["path"]: r for r in csv.DictReader(fh)}
    missing = [a["path"] for a in assets if a["path"] not in rows]
    incomplete = [
        p for p, r in rows.items()
        if any(not str(v).strip() for v in r.values())
    ]
    print(f"[ledger_audit] manifest {len(assets)} 项，CSV {len(rows)} 行；"
          f"缺失 {len(missing)}，字段不完整 {len(incomplete)}")
    if missing or incomplete:
        for p in (missing + incomplete)[:10]:
            print(f"  - {p}")
        print("[ledger_audit] FAIL")
        return 1
    print("[ledger_audit] PASS — 逐资产台账覆盖全部 manifest 资产且字段完整")
    return 0


def main() -> None:
    mode = sys.argv[1] if len(sys.argv) > 1 else "audit"
    sys.exit(generate() if mode == "generate" else audit())


if __name__ == "__main__":
    main()
