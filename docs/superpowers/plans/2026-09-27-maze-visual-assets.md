# 回廊地砖与怪物美术统一实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [x]`) syntax for tracking.

**Goal:** 统一回廊的地面、栅栏、机关和十种天气怪物插画，并保证连续格子的边缘相接、战斗信息仍清楚。

**Architecture:** 保留迷宫生成、地图格子、胜负和奖励逻辑；渲染器先画通用地面，再按格类型画墙或透明主题覆盖层。普通/精英怪按回廊情绪加载一张小型原创立绘，Boss 使用已有对应回廊立绘，等级与状态作为独立徽记绘制。

**Tech Stack:** Flutter `CustomPainter`、`dart:ui.Image`、AI 生成透明 PNG、`tool/asset_pipeline.py`。

---

## 文件地图

- Replace `assets-src/maze/tile_{floor,wall,start,exit,portal,door,trap,shrine,warp,key,lantern}.png` with a coordinated set of 256px tiles.
- Create 10 256px transparent foes at `assets-src/maze/foes/{anxious,emo,sloth,burnout,neikao,chaos,distract,perfect,fomo,shy}.png`.
- Deploy matching files to `app/assets/maze/` through the asset pipeline.
- Modify `app/lib/presentation/pages/maze_page.dart`: load tile/foe images, draw floor-first overlays, and replace circle enemy rendering with image rendering plus compact level/status badges.
- Modify `tool/asset_pipeline.py`, `app/pubspec.yaml`, `docs/08-美术资产描述总表.md`, `docs/06-AI美术资产管线.md`, `assets-src/ledger.md` for validation, bundling, and provenance.

## Task 1: Generate a connected 11-piece tile set

**Files:** Replace 11 PNGs under `assets-src/maze/`; create matching prompts under `assets-src/prompts/`.

- [x] **Step 1: Generate a common ground base.** Generate the tile atlas from `assets-src/prompts/maze_tile_atlas.txt`, then replace the framed floor cell with the standalone seamless image from `assets-src/prompts/maze_floor_seamless.txt`. Keep an opaque 256×256 top-down warm-beige floor tile whose four edges match exactly when repeated.
- [x] **Step 2: Generate the wall/fence base.** Create `tile_wall.png` as a 256×256 opaque cell with the same ground palette, a rounded wooden fence whose horizontal and vertical rails reach all four image edges at matching heights, and identical outline/shadow thickness to the ground art. Neighboring copies must form continuous rails without visible gaps.
- [x] **Step 3: Generate transparent feature overlays.** Create alpha PNGs `tile_start`, `tile_exit`, `tile_portal`, `tile_door`, `tile_trap`, `tile_shrine`, `tile_warp`, `tile_key`, and `tile_lantern`. Each has the same top-down perspective, centered within the 256×256 cell safe area, with no ground square behind it. Decorative floor features use restrained detail so the underlying tile remains visible.
- [x] **Step 4: Normalize, inspect, and replace sources.** Crop transparent margins consistently, preserve alpha on the nine overlays, keep every file at or below 256px, and visually compare the complete 11-image set at both native size and 48px tile size. Reject any image with perspective, stroke, palette, or shadow direction that differs from the set.

## Task 2: Generate ten illustrated weather foes

**Files:** Create `assets-src/maze/foes/{anxious,emo,sloth,burnout,neikao,chaos,distract,perfect,fomo,shy}.png` by slicing the first ten cells of `assets-src/process/maze_foe_atlas.png`; preserve its prompt at `assets-src/prompts/maze_foe_atlas.txt`.

- [x] **Step 1: Keep one stable identity per mood zone.** Slice one full-body small heart-knot creature per `Emotion` in `kZoneEmotions` order. The designs are distinct from the companion pet and have readable weather silhouettes; no gore, text, or frightening anatomy.
- [x] **Step 2: Match the common icon scale.** Use transparent 256×256 canvases, one centered subject, warm-brown rounded outline, pastel two-tone fill, and enough contrast to read at 32–44px. Keep a clear silhouette and small separated limbs/details.
- [x] **Step 3: Inspect all ten as a sprite sheet.** Check common outline weight and visual scale, distinct silhouettes at small size, valid transparency, no accidental circles or generic blob-only designs. Regenerate outliers before wiring them.
- [x] **Step 4: Reuse current Boss art.** Use `assets/bosses/{existing zone boss id}.png` for `FoeKind.boss` inside the maze and the existing result dialog; do not duplicate boss assets.

## Task 3: Register and deploy maze assets

**Files:** Modify `tool/asset_pipeline.py`, `app/pubspec.yaml`, `docs/08-美术资产描述总表.md`, `docs/06-AI美术资产管线.md`, `assets-src/ledger.md`.

- [x] **Step 1: Add ten foe paths to validation.** Add `maze/foes/{emotion}.png` with a 256px max edge to `EXTRA_SPEC`. Preserve the alpha requirement for all foe sprites and all nine feature overlays; only the fully opaque floor and fence base can be in `NO_ALPHA_NEEDED`.
- [x] **Step 2: Bundle the nested Flutter directory.** Add `- assets/maze/foes/` to the asset list in `app/pubspec.yaml`; the existing `assets/maze/` entry remains for top-level tile images.
- [x] **Step 3: Record the visual spec.** Update the existing §4.3 rows for the 11 connected tiles and add §4.6 with the ten foe IDs, emotional silhouettes, resolution and transparent-background rule.
- [x] **Step 4: Record generation and totals.** Add the tile, standalone floor, foe atlas and UI atlas prompt files to `assets-src/ledger.md` with image tool, seed availability, processing and small-size acceptance. Update current art-pipeline totals in `docs/06-AI美术资产管线.md` after the pipeline reports actual counts.
- [x] **Step 5: Validate and deploy.** Run `python tool/asset_pipeline.py validate manifest deploy` from the project root. Expect zero invalid assets, a regenerated `assets-src/assets_manifest.json`, and matching PNGs under `app/assets/maze/`.

## Task 4: Draw base tiles, overlays, and foe illustrations

**Files:** Modify `app/lib/presentation/pages/maze_page.dart`.

- [x] **Step 1: Load all visual resources once per board state.** Load 11 `assets/maze/tile_*.png`, the current zone's foe at `assets/maze/foes/${kZoneEmotions[zoneIndex].name}.png`, and the zone Boss art already used by the result dialog. Rebuild the painter when any decoded image changes.
- [x] **Step 2: Draw every cell in two layers.** For non-wall cells, draw `tile_floor` first. For a wall, draw `tile_wall`. Then draw transparent `start`, `exit`, `door`, and `portal` overlays when the corresponding cell matches. Continue drawing reachability and fog overlays after tile art so the gameplay signals stay visible.

```dart
final base = t == MazeTile.wall ? tileImages['wall'] : tileImages['floor'];
if (base != null) _drawTile(canvas, base, rect);
if (x == f.start.x && y == f.start.y) _drawTile(canvas, tileImages['start'], rect);
if (x == f.exit.x && y == f.exit.y) _drawTile(canvas, tileImages['exit'], rect);
if (t == MazeTile.door) _drawTile(canvas, tileImages['door'], rect);
if (f.portals.containsKey(k)) _drawTile(canvas, tileImages['portal'], rect);
```
- [x] **Step 3: Draw collectible and hazard art over the base.** Draw key, lantern, trap, shrine, warp, and power markers from transparent images centered in the cell; do not replace the ground tile with a square-backed image.
- [x] **Step 4: Replace all enemy body circles.** In `_foe`, draw the zone foe image for normal/elite and the zone Boss image for boss, fitted within `cell * 0.78`. Draw `Lv.N` in a small readable paper badge below the sprite; use a small star badge for elite and a boss mark for Boss. Use no circle as a body fallback; until image loading finishes, display only the compact level badge.

```dart
final image = foe.kind == FoeKind.boss ? bossImages[zoneIndex] : foeImages[zoneIndex];
if (image != null) {
  canvas.drawImageRect(
    image,
    Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
    Rect.fromCenter(center: Offset(cx, cy - cell * 0.08), width: cell * 0.78, height: cell * 0.78),
    Paint()..filterQuality = FilterQuality.medium,
  );
}
_drawLevelBadge(canvas, cx, cy + cell * 0.29, foe.level, beatable);
if (foe.kind == FoeKind.elite) _drawEliteBadge(canvas, cx + cell * 0.25, cy - cell * 0.32);
```
- [x] **Step 5: Preserve combat readability and behavior.** Retain the existing level and beatable-state color semantics through badge colors; do not change `MazeFoe`, generation seed/fingerprint, battle levels, movement or rewards.
- [x] **Step 6: Format and analyze.** Run `dart format lib/presentation/pages/maze_page.dart` and `flutter analyze --no-pub` from `app/`; expect no analyzer issues.

## Final validation

- [x] Run `flutter build web --release --pwa-strategy=none` and `flutter build apk --release` from `app/`; both should complete successfully with the new assets bundled.
- [ ] Open the Web maze and inspect mixed floor/wall layouts for continuous fence edges; inspect all ten zone themes at cell size, and confirm ordinary, elite and Boss sprites are illustrations rather than circles while level/status labels remain readable. The latest Web feedback says the maze entry stays gray; reproduce with an eligible save and record why it is disabled before closing this item.
- [x] Compare the generated source count and manifest with the updated totals in `docs/06-AI美术资产管线.md` and `assets-src/assets_manifest.json`.

