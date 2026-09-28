# AI 生成台账（强制 · 权属证据链）

> 规范：docs/00 §5、docs/06 §4。**每张资产入库前必须在本表登记**，与 `assets_manifest.json` 交叉校验，缺记录 = 不合格资产。
> 描述真源：docs/08-美术资产描述总表.md（prompt 片段从该文拼装）。

## 工具条款核查记录

| 日期 | 工具 | 版本 | 商用条款要点 | 署名要求 | 核查人 |
|---|---|---|---|---|---|
| （待填） | | | | | |

## 生成记录

### 2026-09-26 · Downloads/picture 首批接入（59 张）

| 项目 | 记录 |
|---|---|
| 接入工具 | tool/intake_picture.py + tool/asset_pipeline.py（validate/mirror/manifest/deploy） |
| 精灵 | canon_views front/side/back → st2_clear_{front,left,back} ×10 情绪（30 张）+ mirror right（10 张） |
| 地图 | scenes/island/maps/seasonal 8 张 → island/map_{season}_{day/night}.png（1536×1024 直拷） |
| 回廊 | corridor_tiles 9 张 + items/corridor key/lantern → maze/tile_*.png（256²） |
| 归档 | canon_sheets 设定图 10 张、表情差分 30 张、地标 10 张（assets-src/canon、_expressions、landmarks） |
| 校验 | validate 59 张合格 0 不合格；manifest SHA256 已生成 |
| 来源 | C:/Users/14376/Downloads/picture（source_map.tsv 为生成器原始索引） |
| 经手人 | 自动管线（用户出图 + Claude 接入） |

### 2026-09-27 · Downloads/picture 第二批全量接入（253 张到位）

| 项目 | 记录 |
|---|---|
| 接入工具 | tool/intake_picture.py（v2 映射）+ asset_pipeline.py |
| 运行时立绘 | spirits/runtime 全量 160 张 → st2_clear/st3_clear/st4_{constellation,deepcurrent} ×4 朝向（sunny/rainbow 统一改名 clear） |
| 纪念品 | items/souvenirs 20 张（挂件 8 + 装饰 8 + 氛围 4）→ souvenirs/{id}.png |
| Boss | scenes/bosses/current 10 尊心结巨灵 → bosses/（迷宫结算展示） |
| 图标 | items/icons 12 + ui/tabs 5 + ui/actions 10 → 道具/Tab 接线 |
| 其他 | 云游航线 3 · 明信片模板 4 · 地标 10（V2 接线） |
| 校验 | validate 全合格；manifest 292 条 SHA256；todo 253/253 |
| 经手人 | 自动管线（用户出图 + Claude 接入） |

### 2026-09-27 · 任务难度图标与 Moodisle 应用图标生成

| 项目 | 记录 |
|---|---|
| 生成工具 | Codex 内置 `image_gen.imagegen`；本次工具未提供可记录的模型版本或 seed |
| 提示词 | `prompts/ui_difficulty_easy.txt`、`ui_difficulty_steady.txt`、`ui_difficulty_challenge.txt`、`ui_app_icon.txt` |
| 原始输出 | `C:/Users/14376/.codex/generated_images/01a0e226-b69c-71b1-9a5d-cb684b4fd6be/` 下 4 张 PNG；difficulty 源为 RGBA，app icon 源为 RGB |
| 入库资产 | `ui/difficulty/{easy,steady,challenge}.png`（透明底 128²）；`ui/app_icon.png`（1024² 母版） |
| 平台派生 | Android mipmap 48/72/96/144/192px；Web 192/512 图标、maskable 192/512 与 64px favicon |
| 后处理 | 难度图裁透明边、方形补透明底并用 Lanczos 缩至 128px；应用图标与平台副本用 Lanczos 等比缩放，未改绘生成主体 |
| 风格验收 | 检查 4 张原始输出：难度图透明通道有效，描边和大色块在小尺寸可辨；应用图标无文字、主体居中并保留海蓝底色 |
| 权属边界 | 本项目新生成，未使用只读参考原型的代码、图片或专有名称 |
| 校验 | `asset_pipeline.py validate/manifest/deploy`：257 项资源全合格；manifest 297 条 SHA256；todo 257/257 |

### 2026-09-27 · 回廊 tile、天气怪物与 UI 贴纸统一绘制

| 项目 | 记录 |
|---|---|
| 生成工具 | Codex 内置 `image_gen.imagegen`；未提供可记录的模型版本或 seed |
| 提示词 | `prompts/maze_tile_atlas.txt`、`prompts/maze_floor_seamless.txt`、`prompts/maze_foe_atlas.txt`、`prompts/ui_sticker_atlas.txt` |
| 原始输出 | `process/maze_tile_atlas.png`、`process/maze_floor_base.png`、`process/maze_foe_atlas.png`、`process/ui_sticker_atlas.png`；保留原始图集副本供追溯 |
| 入库资产 | 11 张 `maze/tile_*.png`、10 张 `maze/foes/{emotion}.png`、5 张 `ui/emotes/*.png`、4 张 `ui/feedback/*.png`、2 张 `ui/sections/*.png` |
| 切片规则 | `process/slice_atlases.py` 按 4×4 行优先确定性切片；透明主体裁边后置中缩放到 256/128px；tile_floor 使用独立无边框底图，floor 与 wall 对边做周期混合 |
| 验收 | 检查图集切片后的角色区别、透明通道和小尺寸辨识度；对 tile_floor 与 tile_wall 检查横纵对边像素一致，减少连续拼接的接缝 |
| 权属边界 | 本项目原创生成，未使用只读参考原型代码或图片；AI 原图保留在 process/，没有改写生成主体 |
| 校验 | `validate`：278 项合格、0 项不合格；`todo`：278/278；`manifest`：322 条 SHA256（包括 4 张 process 原始图集/底图）；`deploy`：278 张进入 `app/assets/` |

## 生成记录（历史）

| 日期 | 资产 ID | 描述来源（08 章节） | 工具 | prompt 指纹/全文链接 | seed | 重摇次数 | 人工后处理 | 经手人 | 验收 |
|---|---|---|---|---|---|---|---|---|---|
| （示例）2026-09-26 | pets/sloth/st2_front | 08 §1.3 + §2.1 晴态 + §2.2 front | Nano Banana | [prompts/sloth_st2_front.txt] | 174823 | 2 | rembg→量化→512² | 张三 | ✅ |
| | | | | | | | | | |

## 过程文件索引（人工创作贡献证据）

| 资产/精灵 | 过程文件（process/ 下） | 说明 |
|---|---|---|
| （示例）雾灵 canon | process/sloth_canon_sketch_v2.png | 手排设定草图第 2 版 |
