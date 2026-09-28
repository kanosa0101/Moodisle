# 收藏、云游与专注界面改版实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [x]`) syntax for tracking.

**Goal:** 放大伙伴图鉴详情，增加 20 件装扮与纪念品图鉴，重排云游卡，并让专注和常用语义图标统一成 Moodisle 贴纸风。

**Architecture:** 在现有图鉴入口内增加伙伴/藏品切换；角色详情改为自适应横向大画册，藏品页复用当前 `kSouvenirs` 和存档数量。云游与专注保持现有业务状态，只调整共享 Flutter UI 和资产显示。

**Tech Stack:** Flutter/Dart、项目 `tool/asset_pipeline.py`、AI 生成 PNG、Web 与 Android 共用 assets。

> QA 状态（2026-09-28）：代码改动和 Web 构建记录已完成；宽屏细节、最终 Android 设备表现与回廊进入状态仍需按 docs/09 复核。

---

## 文件地图

- Modify `app/lib/presentation/pages/dex_page.dart`：伙伴与藏品入口；横向/纵向详情弹窗；形态选中态。
- Create `app/lib/presentation/widgets/collectible_catalog.dart`：藏品筛选网格与藏品详情。
- Modify `app/lib/presentation/widgets/roam_card.dart`：横向大幅路线插画卡。
- Modify `app/lib/presentation/pages/island_page.dart`：商店、货币、岛屿表情接入贴纸资源。
- Modify `app/lib/presentation/pages/tasks_page.dart`：复盘反馈图标接入贴纸资源。
- Modify `app/lib/presentation/pages/focus_page.dart`：品牌主按钮与开始图标。
- Modify `app/lib/presentation/widgets/game_icons.dart`：为新增语义贴纸提供小型图片组件。
- Modify `app/pubspec.yaml`：登记新增 UI 子目录。
- Create the 11 UI PNGs from `assets-src/process/ui_sticker_atlas.png`, using the shared prompt `assets-src/prompts/ui_sticker_atlas.txt`.
- Deploy those 11 PNGs to matching `app/assets/ui/` paths through the asset pipeline.
- Modify `tool/asset_pipeline.py`、`docs/08-美术资产描述总表.md`、`docs/06-AI美术资产管线.md`、`assets-src/ledger.md`：规范和记录新增图标。

## Task 1: Build the responsive companion detail and collection switch

**Files:** `app/lib/presentation/pages/dex_page.dart`

- [x] **Step 1: Add a two-section selector without changing bottom navigation.** Convert `DexPage` to `StatefulWidget` with a local `bool _showCollectibles`; keep the existing AnimatedBuilder around content and replace the single header with a segmented `伙伴` / `装扮与纪念品` selector. When false, render the existing 10-pet grid; when true, render `CollectibleCatalog(controller: widget.controller)`.
- [x] **Step 2: Make the form detail stateful and width constrained.** Convert `_DexDetail` to `StatefulWidget`; keep its data derivation from `PetRecord`. Use `LayoutBuilder` to select a 2-column `Row` at widths ≥680px and a vertical `Column` below that. Constrain Web dialog width to `min(740, viewportWidth - 32)` and height to `min(82% of viewport, content height)`.

```dart
final wide = constraints.maxWidth >= 680;
final dialogWidth = constraints.maxWidth.clamp(0.0, 740.0).toDouble();
return SizedBox(
  width: dialogWidth,
  child: wide ? Row(children: [hero, details]) : Column(children: [hero, details]),
);
```
- [x] **Step 3: Promote the chosen form to the large hero.** Keep the four states `(stage, branch, label, found)`; initialize the selected state from the owned record (or clear form if undiscovered). Tapping a form card updates `selectedStage` / `selectedBranch`; render a `PetSprite` at up to 250px on wide screens and scale to available width on narrow screens. Each undiscovered state remains grayscale and labeled `未发现`.
- [x] **Step 4: Preserve existing cultivation behavior.** Keep the existing `controller.cultivate(emotion)` button, dew availability check, collection count, bond level, and progress copy in the information column. Do not change engine rules.
- [x] **Step 5: Format and analyze.** Run `dart format lib/presentation/pages/dex_page.dart` and `flutter analyze --no-pub` from `app/`; expect `No issues found!`.

## Task 2: Add the complete 20-item catalog

**Files:** Create `app/lib/presentation/widgets/collectible_catalog.dart`; modify `app/lib/presentation/pages/dex_page.dart`.

- [x] **Step 1: Derive membership from the current game catalog.** Import `kSouvenirs`, `kDecorShop`, and `kRoamRoutes`. Define filters `全部`, `伙伴挂件`, `岛屿装饰`, `云游纪念品`; calculate source sets from current configuration. `伙伴挂件` uses `SouvenirDef.pendant`; `岛屿装饰` uses `!pendant`; cloud-roam membership is a separate source filter.

```dart
final roamIds = kRoamRoutes
    .expand((route) => route.pool.map((entry) => entry.$1))
    .toSet();
final shopIds = kDecorShop.map((entry) => entry.souvenirId).toSet();
final ownedCount = controller.state.roam.souvenirs[def.id] ?? 0;
```
- [x] **Step 2: Render all assets at useful size.** Iterate `kSouvenirs.values` (not only owned inventory). Read owned count from `controller.state.roam.souvenirs[def.id] ?? 0`; render `SouvenirIcon(def.id, size: 76)` in a square card with `BoxFit.contain`, name, category/source badges, rarity, and `已拥有 ×N` or `未发现`. Apply the same alpha-preserving grayscale treatment as undiscovered pet forms to unowned icons.
- [x] **Step 3: Add a detail sheet.** On card tap, open a paper-styled dialog with a 180px image, name, pendant/decor type, rarity, current count and available source labels (`装扮商店`, `伙伴云游`). Keep unknown acquisition details hidden when an item has no source.
- [x] **Step 4: Check data boundaries.** Ensure total count is 20; filters do not remove any item from `全部`; no new save fields or reward logic are introduced.
- [x] **Step 5: Format and analyze.** Run `dart format` on both Dart files and `flutter analyze --no-pub`; expect no analyzer issues.

## Task 3: Redesign cloud roam cards and focus call to action

**Files:** Modify `app/lib/presentation/widgets/roam_card.dart`, `app/lib/presentation/pages/focus_page.dart`, `app/lib/presentation/widgets/game_icons.dart`.

- [x] **Step 1: Promote each route illustration to a scene card.** Replace `_routeImage`'s 42×36 image with a route-artwork widget about 180×105 on Web, constrained by card width, with a stable aspect ratio and a clipping radius. Use the existing 512px `assets/travel/{monsoon_short,trade_wind_halfday,polar_long}.png` artwork and preserve its composition with `BoxFit.cover`.
- [x] **Step 2: Apply one horizontal information hierarchy.** Dispatch cards place artwork left and route name/description/duration/selected companion/action right. In-progress cards place artwork left and route, companion, due/remaining state, collected count and `迎接` action right. At narrow widths, stack artwork above content. Keep route timers and `dispatchRoam` / `claimRoam` calls untouched.
- [x] **Step 3: Style the focus CTA with Moodisle tokens.** Replace the default green `FilledButton.icon` with a 48px-or-taller orange button using paper background, warm-brown outline, 4px offset shadow, and `assets/ui/actions/start.png`; retain disabled `先选择一位伙伴` state and existing callback.

```dart
Container(
  decoration: BoxDecoration(
    color: MoodisleColors.orange,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: MoodisleColors.ink, width: 1.5),
    boxShadow: const [
      BoxShadow(color: MoodisleColors.shadow, offset: Offset(0, 4)),
    ],
  ),
  child: FilledButton.icon(
    icon: Image.asset('assets/ui/actions/start.png', width: 22, height: 22),
    style: FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(48),
      backgroundColor: Colors.transparent,
      foregroundColor: MoodisleColors.paper,
      shadowColor: Colors.transparent,
      elevation: 0,
    ),
    onPressed: onPressed,
    label: Text(label),
  ),
)
```
- [x] **Step 4: Use existing authored assets for covered actions.** Use `assets/ui/actions/{complete,delete,pin,focus,start}.png` for matching action semantics; replace shop sun/star Material symbols with `ItemIcon(ItemId.sunnyCrystal/stardust)`.
- [x] **Step 5: Format and analyze.** Run `dart format` on changed Dart files and `flutter analyze --no-pub`; expect no analyzer issues.

## Task 4: Redraw the remaining product-semantic icons

**Files:** Create 11 source PNGs under `assets-src/ui/{emotes,feedback,sections}/` from the preserved UI atlas; modify `app/lib/presentation/pages/island_page.dart`, `app/lib/presentation/pages/tasks_page.dart`, `app/lib/presentation/widgets/game_icons.dart`, `app/pubspec.yaml`, `tool/asset_pipeline.py`, `docs/08-美术资产描述总表.md`, `docs/06-AI美术资产管线.md`, `assets-src/ledger.md`.

- [x] **Step 1: Generate and slice the 11 semantic stickers.** Use `assets-src/prompts/ui_sticker_atlas.txt` for one 4×4 atlas; split the first eleven cells row-major into the 5 emotes, 4 feedback marks, and 2 section illustrations. Keep Chinese labels and event kinds unchanged.
- [x] **Step 4: Wire each icon through a small shared image helper.** Replace only product-semantic Material icons covered by these resources. Keep structural controls (close, arrows, keyboard directions, timers) as standard controls. Existing tab, action, difficulty, and currency assets remain the source for their matching meanings.
- [x] **Step 5: Extend the pipeline and register folders.** Add each path to `EXTRA_SPEC`, list `assets/ui/emotes/`, `assets/ui/feedback/`, and `assets/ui/sections/` in `app/pubspec.yaml`, then run `python tool/asset_pipeline.py validate manifest deploy` from the project root. Expect zero invalid assets and all 11 UI stickers copied to the app assets.
- [x] **Step 6: Update the art source of truth and ledger.** Add exact 11 descriptions and sizes to §5.3 of `docs/08-美术资产描述总表.md`; update current totals in `docs/06-AI美术资产管线.md`; record prompts, generated outputs, post-processing, and visual acceptance in `assets-src/ledger.md`.
- [x] **Step 7: Format and analyze.** Run `dart format` on touched Dart files and `flutter analyze --no-pub`; expect no analyzer issues.

## Final validation

- [x] Run `flutter build web --release --pwa-strategy=none` from `app/`; expect a successful `build/web` output.
- [x] Run `flutter build apk --release` from `app/`; expect a successful `build/app/outputs/flutter-apk/app-release.apk` output.
- [x] Confirm the running Web host serves the refreshed `index.html` and `main.dart.js` with HTTP 200; inspect the narrow companion detail, collection detail, and all 20 gray-state catalog entries.
- [ ] Visually inspect the desktop-wide companion detail, enlarged route illustrations, and focus start CTA on a save that owns a companion.
- [ ] Recheck Web maze entry after the current gray-entry report. Reproduce with a save that meets the displayed entry requirements and record the disabled-state cause before closing this item.

