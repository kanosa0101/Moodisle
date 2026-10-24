# 微信小程序分支实施计划

## 目标

以 Android 端已验收体验（2026-10-01 设备验收）为基准，把现有 Flutter 应用经 mp-flutter（`flutter_miniprogram` 0.3.2）编译为微信小程序，多端体验保持一致。用户已确认两项决策：音频先无音跑通、但必须以后续里程碑补齐；验收使用已注册的小程序 AppID 做真机预览（AppID 不入仓库，经 workflow 输入/Secret 注入）。全程只在 `feat/wechat-miniprogram` 分支提交，`main` 与 `ci.yml` 不动。

## 结构决策

- 构建只能在 CI：mp-flutter 构建 CLI 仅支持 macOS/Linux，Windows 开发机不做构建，只做开发者工具验收；构建统一走 `wechat-miniprogram-spike.yml`（ubuntu + Flutter 3.41.9，mp-flutter 官方验证版本）。
- 包体硬限：主包/单包 ≤2MB、总包 ≤30MB。当前 `app/assets` 94MB，瘦身是构建通过的前置条件；瘦身为构建期原地变换（CI 全新 checkout），不改仓库资产与 `assets-src/` 台账。
- 存储走现有降级链：小程序构建不注入 `SqliteGameRepository`（drift 无 wasm/worker 垫片），由 `SaveStore` 的 web 路径落到 localStorage 垫片（`wx.*StorageSync` 承载，单键 1MB/总量 10MB）。
- 平台分支统一用 `--dart-define=MOODISLE_MP=1` 门控，避免新增条件导入面。
- 专注生命周期在小程序与 web 同语义（切后台暂停、无锁屏信号），文案按平台三分支如实表述；此为记录在案的边界，不做伪造对齐。

## 执行步骤（里程碑）

1. **M0 交接固定**：前任工作区改动（工具依赖、字体子集、字符集、spike 工作流）原样提交；本计划入库。
2. **M1 构建摸底**：推送触发 spike workflow，记录真实失败证据（预期包体超限退出码 2）与各分包体积，入 docs/qa。
3. **M2 资产瘦身**：`tool/weapp_asset_diet.py` 构建期压缩（PNG 限宽+量化，目标图片 ≤20MB；暂剔除 audio 13MB）；字体 A/B 实验（内置 MoodisleSans 916KB vs 工具自带 pkg-cjk）截图择优；脚本带 Python 单测；验收 workflow 全绿、总包 ≤30MB、主包 ≤2MB。
4. **M3 模拟器冒烟**：开发者工具 CLI 打开 build/weapp；重点验证启动、存档跨重启持久化、460px 布局渲染、onHide/onShow→专注暂停、剪贴板行为；产出冒烟清单与阻塞项。
5. **M4 平台适配层**：MOODISLE_MP 门控不注入 SQLite 仓库；满状态导出 JSON 体积测量（近 1MB 则 writeSave 分片）；音频构造若炸启动则 no-op 工厂；`focus_lifecycle_channel` 补 catch PlatformException；grow_page 四处剪贴板加 try-catch + SelectableText 降级；如 localStorage 垫片不生效则运行时探测 `wx` 显式路由；专注页文案三分支。全程 110 条测试绿 + 新增单测 + analyze 干净。
6. **M5 真机验收**：workflow 增加 appid 注入（dispatch 输入 + `WECHAT_APPID` Secret，默认 touristappid）；真实 AppID 构建 → 开发者工具预览二维码 → 手机走查（docs/09 §3 九步改编 + 进程杀死恢复 + 冷启动时长）；证据入 docs/qa。
7. **M6 对齐收尾**：安卓 APK 与小程序逐页截图对比，修可修差异、立不可对齐边界；新增 `docs/12-微信小程序适配.md`，更新 docs/05/07/09 与 README。
8. **M7 音频补齐**（必做）：实现 `JustAudioPlatform` 的 wx 实现（`wx.createInnerAudioContext` 经 dart:js_interop 桥接），在 Moodisle_MP 构建下全局注入，服务层与 UI 零改动；10 个 WAV 转 AAC/MP3（预计 13MB→2-4MB）回包，瘦身脚本由剔除改转码；BGM 循环/切后台暂停/静音开关模拟器+真机逐项验证。后备：MpVideo 组件承载音频。

## 验收标准

- spike/构建 workflow 全绿，产物 `app/build/weapp/` 可被微信开发者工具打开（基础库 ≥3.15.0）。
- 模拟器与真机走查通过 docs/09 §3 改编清单：引导、待办闭环、图鉴、专注切后台暂停、回廊、存档导入导出（降级路径可用）、窄屏、音频边界。
- 存档在小程序内跨重启持久；`flutter test` 全绿、`flutter analyze` 无告警；main 分支零改动。
- M7 完成后真机 BGM/音效可听、切后台暂停恢复正确。

## 风险和处理

- 瘦身压不进 30MB：逐档收紧参数；仍不足则提请裁减非核心资源集（postcards/差分表情），需用户确认。
- drift/just_audio 启动即炸或挂起：M4 的 dart-define 门控直接绕开注入路径。
- localStorage 垫片与预期不符：`save_store_web` 运行时探测 `wx` 全局显式路由到 wx 存储。
- M7 wx 音频桥不可达：后备 MpVideo；再不可行与用户重议音频边界。
- 真机基础库或性能不达标：先确认基础库版本；性能用工具的 perf-hud/preload 开关调优。
- CI 迭代慢：失败靠日志分类；workflow 保持手动触发为主，控制构建用量（沿用 iOS 构建的省配额惯例）。

## 执行记录

- 2026-10-24 M0：前任工作区改动原样提交（`ee4e985`），本计划入库。
