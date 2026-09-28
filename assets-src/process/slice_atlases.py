"""Deterministically split the three AI-generated 4x4 sprite atlases."""
from pathlib import Path

from PIL import Image, ImageOps

ROOT = Path(__file__).resolve().parents[1]
PROCESS = ROOT / "process"

TILE_NAMES = [
    "floor", "wall", "start", "exit",
    "portal", "door", "trap", "shrine",
    "warp", "key", "lantern",
]
FOE_NAMES = [
    "anxious", "emo", "sloth", "burnout", "neikao",
    "chaos", "distract", "perfect", "fomo", "shy",
]
ICON_PATHS = [
    "emotes/heart", "emotes/music", "emotes/happy", "emotes/leaf",
    "emotes/sparkle", "feedback/relief", "feedback/calm", "feedback/proud",
    "feedback/easier", "sections/store", "sections/roam",
]


def cells(path: Path):
    image = Image.open(path).convert("RGBA")
    if image.width < 4 or image.height < 4:
        raise ValueError(f"Invalid atlas size: {path}")
    bounds = [round(i * image.width / 4) for i in range(5)]
    ybounds = [round(i * image.height / 4) for i in range(5)]
    for row in range(4):
        for col in range(4):
            yield image.crop((bounds[col], ybounds[row], bounds[col + 1], ybounds[row + 1]))


def contain(cell: Image.Image, size: int, max_fraction: float = 0.9) -> Image.Image:
    bbox = cell.getchannel("A").getbbox()
    canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    if bbox is None:
        return canvas
    subject = cell.crop(bbox)
    limit = round(size * max_fraction)
    subject.thumbnail((limit, limit), Image.Resampling.LANCZOS)
    canvas.alpha_composite(
        subject,
        ((size - subject.width) // 2, (size - subject.height) // 2),
    )
    return canvas


def make_periodic(image: Image.Image, band: int = 5) -> Image.Image:
    """Blend opposite borders so adjacent copies have identical edge pixels."""
    image = image.convert("RGBA")
    source = image.copy()
    pixels = image.load()
    original = source.load()
    size = image.width

    def blend(a, b, amount):
        return tuple(round(x * (1 - amount) + y * amount) for x, y in zip(a, b))

    for y in range(size):
        edge = blend(original[0, y], original[size - 1, y], 0.5)
        for offset in range(band):
            amount = (band - offset) / band
            pixels[offset, y] = blend(original[offset, y], edge, amount)
            pixels[size - 1 - offset, y] = blend(
                original[size - 1 - offset, y], edge, amount
            )
    source = image.copy()
    original = source.load()
    pixels = image.load()
    for x in range(size):
        edge = blend(original[x, 0], original[x, size - 1], 0.5)
        for offset in range(band):
            amount = (band - offset) / band
            pixels[x, offset] = blend(original[x, offset], edge, amount)
            pixels[x, size - 1 - offset] = blend(
                original[x, size - 1 - offset], edge, amount
            )
    return image


def save_tiles():
    atlas = list(cells(PROCESS / "maze_tile_atlas.png"))
    out = ROOT / "maze"
    out.mkdir(parents=True, exist_ok=True)
    floor_color = (239, 226, 192, 255)
    floor = Image.open(PROCESS / "maze_floor_base.png").convert("RGBA")
    floor = ImageOps.fit(floor, (256, 256), method=Image.Resampling.LANCZOS)
    make_periodic(floor).save(out / "tile_floor.png")

    wall_cell = atlas[1]
    wall_base = Image.new("RGBA", wall_cell.size, floor_color)
    wall_base.alpha_composite(wall_cell)
    wall = ImageOps.fit(wall_base, (256, 256), method=Image.Resampling.LANCZOS)
    make_periodic(wall).save(out / "tile_wall.png")

    for index, name in enumerate(TILE_NAMES[2:], start=2):
        contain(atlas[index], 256, 0.88).save(out / f"tile_{name}.png")


def save_foes():
    atlas = list(cells(PROCESS / "maze_foe_atlas.png"))
    out = ROOT / "maze" / "foes"
    out.mkdir(parents=True, exist_ok=True)
    for index, name in enumerate(FOE_NAMES):
        contain(atlas[index], 256, 0.92).save(out / f"{name}.png")


def save_icons():
    atlas = list(cells(PROCESS / "ui_sticker_atlas.png"))
    out = ROOT / "ui"
    for index, path in enumerate(ICON_PATHS):
        target = out / path
        target.parent.mkdir(parents=True, exist_ok=True)
        contain(atlas[index], 128, 0.90).save(target.with_suffix(".png"))


if __name__ == "__main__":
    save_tiles()
    save_foes()
    save_icons()
    print("Sliced 11 maze tiles, 10 foes, and 11 UI stickers.")
