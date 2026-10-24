# -*- coding: utf-8 -*-
"""weapp_asset_diet 单测：python -m unittest tool.test_weapp_asset_diet

覆盖：音频剔除与 .keep 占位、字体可选剔除、PNG 降采样与量化重编码、
透明通道保留、dry-run 不写文件、check 体积门禁退出码。
"""
import tempfile
import unittest
from contextlib import redirect_stdout
from io import StringIO
from pathlib import Path

from PIL import Image

from tool import weapp_asset_diet as diet


class WeappAssetDietTests(unittest.TestCase):
    def setUp(self):
        self.temp_dir = tempfile.TemporaryDirectory()
        root = Path(self.temp_dir.name)
        self.assets = root / "app" / "assets"
        self.assets.mkdir(parents=True)

    def tearDown(self):
        self.temp_dir.cleanup()

    @staticmethod
    def write_png(path: Path, size=(64, 32), mode="RGBA") -> None:
        path.parent.mkdir(parents=True, exist_ok=True)
        Image.new(mode, size, (255, 0, 0, 128)).save(path, format="PNG")

    def test_apply_removes_audio_and_keeps_placeholder(self):
        audio = self.assets / "audio" / "bgm_sunny.mp3"
        audio.parent.mkdir(parents=True)
        audio.write_bytes(b"x" * 16)
        self.write_png(self.assets / "pets" / "a.png")

        code = diet.apply(self.assets, keep_audio=False, drop_fonts=False,
                          dry_run=False)
        self.assertEqual(code, 0)
        self.assertFalse(audio.exists())
        self.assertTrue((self.assets / "audio" / diet.KEEP_NAME).exists())

    def test_apply_keep_audio_preserves_files(self):
        audio = self.assets / "audio" / "s.wav"
        audio.parent.mkdir(parents=True)
        audio.write_bytes(b"x" * 16)
        diet.apply(self.assets, keep_audio=True, drop_fonts=False, dry_run=False)
        self.assertTrue(audio.exists())

    def test_apply_drop_fonts_removes_ttf(self):
        font = self.assets / "fonts" / "Noto.ttf"
        font.parent.mkdir(parents=True)
        font.write_bytes(b"x" * 16)
        diet.apply(self.assets, keep_audio=True, drop_fonts=True, dry_run=False)
        self.assertFalse(font.exists())
        self.assertTrue((self.assets / "fonts" / diet.KEEP_NAME).exists())

    def test_apply_downscales_and_quantizes_large_png(self):
        # island 档位 1024：造一张 1200 宽的图，应用后应被降采样并量化为调色板模式。
        path = self.assets / "island" / "map.png"
        self.write_png(path, size=(1200, 300))
        before = path.stat().st_size

        with redirect_stdout(StringIO()):
            diet.apply(self.assets, keep_audio=True, drop_fonts=False,
                       dry_run=False)

        with Image.open(path) as img:
            self.assertEqual(img.width, diet.WIDTH_CAPS["island"])
            self.assertEqual(img.mode, "P")  # 量化后的调色板模式
            self.assertIn("transparency", img.info)  # 透明通道保留

    def test_apply_keeps_small_png_dimensions(self):
        # 小于档位的图不改变像素尺寸，只做量化重编码。
        path = self.assets / "souvenirs" / "s.png"
        self.write_png(path, size=(100, 100))
        with redirect_stdout(StringIO()):
            diet.apply(self.assets, keep_audio=True, drop_fonts=False,
                       dry_run=False)
        with Image.open(path) as img:
            self.assertEqual(img.size, (100, 100))

    def test_dry_run_writes_nothing(self):
        audio = self.assets / "audio" / "a.wav"
        audio.parent.mkdir(parents=True)
        audio.write_bytes(b"x" * 16)
        png = self.assets / "island" / "map.png"
        self.write_png(png, size=(1200, 300))
        before_bytes = png.read_bytes()

        with redirect_stdout(StringIO()):
            code = diet.apply(self.assets, keep_audio=False, drop_fonts=True,
                              dry_run=True)

        self.assertEqual(code, 0)
        self.assertTrue(audio.exists())
        self.assertEqual(png.read_bytes(), before_bytes)

    def test_check_exit_code_respects_budget(self):
        png = self.assets / "pets" / "a.png"
        self.write_png(png)
        with redirect_stdout(StringIO()):
            self.assertEqual(diet.check(self.assets), 0)  # 远低于预算

        original_budget = diet.IMAGE_BUDGET_MB
        diet.IMAGE_BUDGET_MB = 0.0
        try:
            with redirect_stdout(StringIO()):
                self.assertEqual(diet.check(self.assets), 1)  # 超预算非零退出
        finally:
            diet.IMAGE_BUDGET_MB = original_budget


if __name__ == "__main__":
    unittest.main()
