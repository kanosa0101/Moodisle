"""Fail when shared release metadata or packaged shell assets drift by platform."""

from __future__ import annotations

import hashlib
import json
import plistlib
import re
import struct
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
APP = ROOT / "app"
DISPLAY_NAME = "心晴屿 Moodisle"
SHORT_NAME = "心晴屿"
FLUTTER_VERSION = "3.47.5"


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def png_size(path: Path) -> tuple[int, int]:
    header = path.read_bytes()[:24]
    require(header[:8] == b"\x89PNG\r\n\x1a\n", f"not a PNG: {path}")
    return struct.unpack(">II", header[16:24])


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def check_version() -> tuple[str, str]:
    pubspec = read(APP / "pubspec.yaml")
    match = re.search(r"(?m)^version:\s*(\d+\.\d+\.\d+)\+(\d+)\s*$", pubspec)
    require(match is not None, "pubspec version must include name and integer build number")
    return match.group(1), match.group(2)


def check_android() -> None:
    gradle = read(APP / "android/app/build.gradle.kts")
    manifest = read(APP / "android/app/src/main/AndroidManifest.xml")
    require('versionCode = flutter.versionCode' in gradle, "Android versionCode drift")
    require('versionName = flutter.versionName' in gradle, "Android versionName drift")
    require(f'android:label="{DISPLAY_NAME}"' in manifest, "Android display name drift")

    expected = {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}
    for density, size in expected.items():
        icon = APP / f"android/app/src/main/res/mipmap-{density}/ic_launcher.png"
        require(png_size(icon) == (size, size), f"Android {density} icon size drift")


def check_ios() -> None:
    with (APP / "ios/Runner/Info.plist").open("rb") as source:
        info = plistlib.load(source)
    require(info["CFBundleDisplayName"] == DISPLAY_NAME, "iOS display name drift")
    require(info["CFBundleShortVersionString"] == "$(FLUTTER_BUILD_NAME)", "iOS version name drift")
    require(info["CFBundleVersion"] == "$(FLUTTER_BUILD_NUMBER)", "iOS build number drift")

    project = read(APP / "ios/Runner.xcodeproj/project.pbxproj")
    require(
        "PRODUCT_BUNDLE_IDENTIFIER = dev.moodisle.moodisleApp;" in project,
        "iOS bundle identifier drift",
    )

    icon_dir = APP / "ios/Runner/Assets.xcassets/AppIcon.appiconset"
    contents = json.loads(read(icon_dir / "Contents.json"))
    for image in contents["images"]:
        filename = image.get("filename")
        if not filename:
            continue
        width = float(image["size"].split("x", 1)[0]) * float(image["scale"].removesuffix("x"))
        expected = int(width)
        require(png_size(icon_dir / filename) == (expected, expected), f"iOS icon size drift: {filename}")

    master = APP / "assets/ui/app_icon.png"
    ios_master = icon_dir / "Icon-App-1024x1024@1x.png"
    require(sha256(master) == sha256(ios_master), "iOS marketing icon differs from app master")


def check_web() -> None:
    manifest = json.loads(read(APP / "web/manifest.json"))
    require(manifest["name"] == DISPLAY_NAME, "Web display name drift")
    require(manifest["short_name"] == SHORT_NAME, "Web short name drift")
    require("orientation" not in manifest, "Web alone must not force an orientation")
    for icon in manifest["icons"]:
        size = int(icon["sizes"].split("x", 1)[0])
        require(png_size(APP / "web" / icon["src"]) == (size, size), f"Web icon size drift: {icon['src']}")


def check_shared_assets() -> None:
    pubspec = read(APP / "pubspec.yaml")
    require("- assets/audio/" in pubspec, "audio assets are not declared")
    require(len(list((APP / "assets/audio").glob("*.wav"))) == 10, "expected 10 WAV effects")
    require(len(list((APP / "assets/audio").glob("*.mp3"))) == 3, "expected 3 MP3 tracks")
    require(len(list((APP / "assets/fonts").glob("*.ttf"))) == 2, "expected 2 bundled fonts")


def check_workflows() -> None:
    versions = []
    workflows = (
        ROOT / ".github/workflows/ci.yml",
        ROOT / ".github/workflows/ios-build.yml",
        ROOT / ".github/workflows/wechat-miniprogram-spike.yml",
    )
    for path in workflows:
        versions.extend(re.findall(r"flutter-version:\s*['\"]?([^'\"\s]+)", read(path)))
    require(
        versions == [FLUTTER_VERSION] * len(workflows),
        f"workflow Flutter versions drifted: {versions}",
    )


def main() -> int:
    try:
        version_name, build_number = check_version()
        check_android()
        check_ios()
        check_web()
        check_shared_assets()
        check_workflows()
    except (KeyError, OSError, ValueError, json.JSONDecodeError, plistlib.InvalidFileException) as error:
        print(f"Cross-platform consistency: FAIL: {error}", file=sys.stderr)
        return 1
    print(f"Cross-platform consistency: PASS (v{version_name}+{build_number}, Android/iOS/Web)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
