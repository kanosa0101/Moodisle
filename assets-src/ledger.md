# 资产来源与生成台账（权属证据链）

> 规范要求见 docs/00 §5、docs/06 §4。**当前状态（2026-09-29）：本台账含批次摘要，尚未覆盖每一项资产的独立记录，也没有与 `assets_manifest.json` 自动交叉校验；工具条款核查表仍待填写。不能据此宣称全资产来源和授权已核清。**缺口与后续动作见 docs/07 §3。
> 描述真源：docs/08-美术资产描述总表.md（prompt 片段从该文拼装）。

> 未提供的模型、prompt、日期或授权信息均保留为“未提供”；用户提供的 BGM 授权信息未确认。现有 `tool/ip_scan.py` PASS 只代表禁用词扫描通过，不代表资产版权或台账完整性通过。

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

### 2026-09-28 · 中文子集字体随包分发

| 项目 | 记录 |
|---|---|
| 字体来源 | Noto Sans SC（SIL OFL 1.0，允许再分发与子集化）；授权全文入库 `fonts/OFL.txt` |
| 下载方式 | Google Fonts CSS API 直链（curl + 代理环境），两个字重各约 10.5 MB，存档为 `fonts/NotoSansSC-{400,700}-full.ttf` 供追溯与再生成 |
| 处理工具 | `tool/subset_font.py`（fonttools/pyftsubset；字符集 = app/lib + docs + app/test + 根 README 全文 + 可打印 ASCII + 常用中文标点） |
| 产物 | `app/assets/fonts/NotoSansSC-Regular-Subset.ttf`、`NotoSansSC-Bold-Subset.ttf`（各 0.44 MB / 1742 字形；字符集存档 `process/font_charset.txt`） |
| 接线 | pubspec 声明 `MoodisleSans` 族（Bold 挂 700/800/900）；主题全局引用；迷宫画布文字显式引用 |
| 验收 | FreeType 渲染通过；Web 构建 FontManifest 含该字族且文件 200 加载；对照实验：主题文本使用包内字体（无效族名对照下 gstatic 回退切片 9 → 21） |
| 权属边界 | 字体为 SIL OFL 开源授权，非 AI 生成；未使用参考原型任何素材 |
| 经手人 | Claude（ZCode 会话，2026-09-28） |

### 2026-09-28 · 背景音乐与交互音效

| 项目 | 记录 |
|---|---|
| BGM 原件 | 用户提供 `Barefoot_on_the_Lawn.mp3`、`Through_the_Orchard_Gate.mp3`、`Running_Toward_The_Horizon.mp3`，保留于 `audio/original/`；分别暂映射晴朗、薄雾、夜晚 |
| BGM 规格 | 原件 44.1 kHz stereo MP3，时长 177.498 s、182.521 s、177.629 s；运行时仅重命名，三组源/运行时 SHA-256 一致 |
| BGM 来源边界 | 文件含 C2PA 元数据，签名字符串含 Google LLC；未提供具体工具/模型、prompt、生成日期和授权条款，因此不作推断，详见 `audio/manifest.csv` |
| SFX 制作 | `tool/generate_audio_sfx.py` 使用 Python 标准库离线合成 10 个短音效；每个声音使用固定 seed，无第三方采样；源 WAV 与运行时副本 SHA-256 一致 |
| SFX 规格 | PCM WAV、44.1 kHz、16-bit、mono，时长 75–960 ms；所有参数、seed 与哈希见 `audio/manifest.csv` |
| 权属与验收 | 用户提供音乐和项目自制合成音效均未混用参考原型素材；音乐授权信息未提供。文件格式、时长与哈希已核对；循环、音量、BGM 情绪映射及 Android/Web 播放经 2026-10-01 用户实测正常，音乐授权信息仍待补充 |

## 逐资产生成记录模板（当前尚未覆盖全部历史资产）

| 日期 | 资产 ID | 描述来源（08 章节） | 工具 | prompt 指纹/全文链接 | seed | 重摇次数 | 人工后处理 | 经手人 | 验收 |
|---|---|---|---|---|---|---|---|---|---|
| 待补录 | 待填资产 ID | docs/08 对应段落 | 待填工具及版本 | prompt 文件路径或“不适用” | 实际 seed/参数或“未提供” | 待填 | 实际后处理步骤 | 待填经手人 | 待验收 |

## 过程文件索引（人工创作贡献证据）

| 资产/精灵 | 过程文件（process/ 下） | 说明 |
|---|---|---|
| 待补录资产/过程 | process/ 下的实际文件名 | 说明人工创作贡献 |
