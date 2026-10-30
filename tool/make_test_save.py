"""生成「基本全收集」测试存档夹具（moodisle_save_v2 JSON）。

用途：在成长页 → 存档 → 导入（读取剪贴板）粘贴本文件内容，即可跳过长期养成
直接测试全收集形态下的各页面（图鉴觉醒双线、装扮商店、回廊全解锁、成就墙等）。

生成规则与 app/lib/data/save_codec.dart（moodisle_save_v2）及
app/lib/domain/engine/social_engine.dart 的明信片码编码逐位一致，
并由 app/test/data/test_save_fixture_test.dart 守护：codec 变更会令测试红。

用法（仓库根目录）：
    python tool/make_test_save.py                    # 按 ANCHOR 日期生成（默认确定性）
    python tool/make_test_save.py --today 2026-11-05 # 以指定日期为锚刷新相对日期

仅用标准库。
"""

from __future__ import annotations

import argparse
import datetime as dt
import json
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
OUTPUT = REPO_ROOT / "app" / "test" / "fixtures" / "test_save_v2.json"

# 夹具的默认日期锚（与生成时的真实日期一致；重跑 --today 可整体前移）
ANCHOR = dt.date(2026, 10, 30)

# —— SocialEngine 编码常量（与 Dart 实现保持逐字一致） ——
_ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
_BASE36 = "0123456789abcdefghijklmnopqrstuvwxyz"

# Emotion.values 顺序（app/lib/domain/entities/emotion.dart）
EMOTIONS = [
    "anxious", "emo", "sloth", "burnout", "neikao",
    "chaos", "distract", "perfect", "fomo", "shy",
]


def _postcard_code(island_name: str, pet_index: int) -> str:
    """MDSL-<BODY>-<CHECK4>；BODY = 每个 UTF-16 码元 × 4 个 Base32 字符。"""
    payload = f"{island_name}|{pet_index}"
    body_parts = []
    for ch in payload:
        v = ord(ch)  # 夹具只用 BMP 字符，ord 即 UTF-16 码元
        digits = []
        for _ in range(4):
            digits.append(_ALPHABET[v % 32])
            v //= 32
        body_parts.append("".join(reversed(digits)))
    body = "".join(body_parts)
    checksum = 0
    for ch in body:
        checksum = (checksum * 31 + ord(ch)) % 1299709
    b36 = ""
    n = checksum
    while True:
        b36 = _BASE36[n % 36] + b36
        n //= 36
        if n == 0:
            break
    check = b36.rjust(4, "0")[:4].upper()
    return f"MDSL-{body}-{check}"


def _stage(count: int) -> str:
    if count >= 10:
        return "awakened"
    if count >= 5:
        return "rainbow"
    return "clear"


def _d(date: dt.date) -> str:
    return date.isoformat()


def _ms(anchor: dt.date, hour: int, minute: int) -> int:
    """锚定日某时刻的毫秒时间戳（本地语义；夹具只用于展示/24h 链窗口）。"""
    moment = dt.datetime(
        anchor.year, anchor.month, anchor.day, hour, minute,
        tzinfo=dt.datetime.now().astimezone().tzinfo,
    )
    return int(moment.timestamp() * 1000)


def build_save(anchor: dt.date) -> dict:
    pets = {
        # emotion: (count, branch, bondMinutes)  stage 由 count 推导，保持一致
        "anxious": (14, "constellation", 2400),
        "emo": (12, "deepcurrent", 1500),
        "sloth": (9, None, 640),
        "burnout": (7, None, 320),
        "neikao": (11, "constellation", 1050),
        "chaos": (13, "deepcurrent", 1850),
        "distract": (6, None, 160),
        "perfect": (4, None, 90),
        "fomo": (8, None, 610),
        "shy": (3, None, 40),
    }
    pets_json = {
        name: {
            "count": count,
            "stage": _stage(count),
            "branch": branch,
            "bondMinutes": bond,
        }
        for name, (count, branch, bond) in pets.items()
    }

    items = {
        "sunnyCrystal": 88,
        "stardust": 64,
        "morningDew": 12,
        "prismCrystal": 9,
        "mistDew": 5,
        "warmFront": 3,
        "tailwind": 4,
        "knotShard": 7,
        "cloudMica": 2,
        "lantern": 1,
    }

    souvenirs = {
        # 云游纪念品
        "cloudBell": 3,
        "windmillLamp": 2,
        "rainbowHoop": 2,
        "starChartScarf": 1,
        "rainGauge": 4,
        "sunnyRainDoll": 2,
        "convectionFire": 3,
        "auroraVeil": 1,
        # 装扮商店
        "breeze_chime_stand": 1,
        "travel_mailbox": 1,
        "warm_night_campfire": 1,
        "star_wish_swing": 1,
        "lotus_boat": 1,
        "fog_lamp_ornament": 1,
        "shell_wind_chime": 1,
        "weather_house": 1,
        "rainbow_arch": 1,
        "meteor_wishing_pool": 1,
        "aurora_curtain": 1,
        "four_seasons_flower_clock": 1,
    }

    achievements = [
        "first", "sunny3", "sunny7", "dex", "rainbow", "awakened",
        "constellation", "deepcurrent", "clear100", "chain3", "chain5",
        "maze10", "dew20", "deep5", "bond10", "collector", "penpal", "visitor",
    ]

    buckets = []
    for offset, (done, focus_min) in enumerate(
        [(2, 0), (4, 25), (1, 0), (5, 50), (3, 15), (6, 25), (2, 25)]
    ):
        buckets.append(
            {"date": _d(anchor - dt.timedelta(days=6 - offset)),
             "done": done, "focusMin": focus_min}
        )

    monday = anchor - dt.timedelta(days=anchor.weekday())
    tasks = [
        {"id": 5, "text": "给朋友回消息", "emotion": "shy", "difficulty": 1,
         "status": "pending", "createdOn": _d(anchor), "pinned": False},
        {"id": 4, "text": "整理本周周报", "emotion": "neikao", "difficulty": 2,
         "status": "pending", "createdOn": _d(anchor), "pinned": True},
        {"id": 3, "text": "跑步 30 分钟", "emotion": "emo", "difficulty": 3,
         "status": "pending", "createdOn": _d(anchor - dt.timedelta(days=1)),
         "pinned": False},
        {"id": 2, "text": "完成一次 25 分钟专注", "emotion": "fomo", "difficulty": 2,
         "status": "done", "createdOn": _d(anchor - dt.timedelta(days=1)),
         "pinned": False},
        {"id": 1, "text": "读完一章书", "emotion": "sloth", "difficulty": 1,
         "status": "done", "createdOn": _d(anchor - dt.timedelta(days=2)),
         "pinned": False},
    ]

    return {
        "version": 2,
        "nextTaskId": 6,
        "clearing": 96.5,
        "energy": 23,
        "warmFrontTurns": 2,
        "tailwindTurns": 1,
        "stats": {
            "totalDone": 87,
            "totalFocusSessions": 22,
            "totalFocusMinutes": 530,
            "mazeRuns": 60,  # ≥55：十区全部解锁
            "mistDewCollected": 47,
            "deepDives": 8,
        },
        "achievements": achievements,
        "roam": {
            "slots": [],
            "souvenirs": souvenirs,
            "pendant": "starChartScarf",
        },
        "social": {
            "myName": "测试屿",
            "visitingPet": None,
            "visitingExpireMs": None,
            "postcards": [
                {
                    "code": _postcard_code("晴风屿", EMOTIONS.index("shy")),
                    "friendName": "晴风屿",
                    "friendPet": "shy",
                    "receivedAtMs": _ms(anchor - dt.timedelta(days=1), 18, 0),
                },
                {
                    "code": _postcard_code("星野", EMOTIONS.index("fomo")),
                    "friendName": "星野",
                    "friendPet": "fomo",
                    "receivedAtMs": _ms(anchor - dt.timedelta(days=2), 21, 30),
                },
            ],
        },
        "lastReportWeek": _d(monday),
        "onboarded": True,
        "streak": {"sunnyDays": 12, "lastSunny": _d(anchor)},
        "keeper": {"level": 12, "exp": 60},
        "resonance": {
            "last": "shy",
            "len": 3,
            "best": 6,
            "lastAtMs": _ms(anchor, 9, 30),
        },
        "climate": {
            "fog": 12.0,
            "tier": "sunny",
            "tierHoldDays": 0,
            "zeroDoneStreak": 0,
            "buckets": buckets,
        },
        "focus": {
            "todayMin": 25,
            "weekMin": 140,
            "weekStart": _d(monday),
            "glancesToday": 1,
        },
        "session": None,
        "daily": {
            "date": _d(anchor),
            "checkinDays": 9,
            "checkinBest": 21,
            "checkedToday": False,
            "lastCheckin": _d(anchor - dt.timedelta(days=1)),
            "lastGreet": _d(anchor),
            "mazeToday": 0,
            "companion": "anxious",
            "quests": {
                "do3": {"prog": 2, "claimed": False},
                "focus1": {"prog": 1, "claimed": True},
                "chain3": {"prog": 3, "claimed": False},
            },
        },
        "tasks": tasks,
        "pets": pets_json,
        "items": items,
        "activeMazeRun": None,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--today", type=dt.date.fromisoformat, default=None,
        help="日期锚（YYYY-MM-DD）；省略则使用脚本内置默认锚，保证产物确定性",
    )
    args = parser.parse_args()
    anchor = args.today or ANCHOR
    save = build_save(anchor)
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text(
        json.dumps(save, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    print(f"written: {OUTPUT} (anchor={anchor})")
    for pc in save["social"]["postcards"]:
        print(f"  postcard: {pc['friendName']} -> {pc['code']}")


if __name__ == "__main__":
    main()
