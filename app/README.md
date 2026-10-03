# app/ · Flutter 应用

本文记录当前代码结构与可复现命令。项目处于 Web/Android 测试打磨阶段；不要把历史检查结果当作当前版本的验证结论。

## 环境与命令

需要 Flutter SDK；pubspec.yaml 要求 Dart >=3.3.0 <4.0.0。

    cd app
    flutter pub get
    flutter run -d chrome
    flutter run                 # 需要已连接的 Android 设备或模拟器
    flutter analyze
    flutter test
    flutter build web --release
    flutter build apk --release

从仓库根目录运行美术工具：

    cd ..
    python tool/asset_pipeline.py todo
    python tool/asset_pipeline.py validate
    python tool/asset_pipeline.py manifest
    python tool/ip_scan.py .

## 当前实现

- lib/main.dart：MaterialApp、共享页面框架、五项底部导航和首次引导。成长页从右上角进入。
- lib/domain/：游戏状态、规则、经济、气候、专注、生态与回廊内核。
- lib/application/：GameController（ChangeNotifier 门面、计时心跳和约 2 秒延迟合并保存）与 GameCore 协作。
- lib/data/：JSON v2 编解码和 SaveStore；原生平台使用应用文档目录，Web 使用 localStorage，保留有效备份。
- lib/presentation/pages/：心屿、待办、图鉴、回廊、专注、成长和引导页面。
- lib/shared/：主题 token（含 MoodisleSans 字体族）、共用 UI 和应用级音频播放器。
- assets/：278 张当前运行时 PNG 与 2 个中文子集字体（tool/subset_font.py 生成）。
- test/：18 个测试文件、109 条测试。

运行时第三方依赖为 path_provider 与 just_audio。音频播放器、静音、生命周期、页面事件与 13 项音频资源已接入；Web/Android Release 构建通过，实际播放已于 2026-10-01 经用户在两端实测。桌面小组件、iOS Live Activity、通知、触感反馈和暗色主题目前不是已交付能力；平台状态见 [架构文档](../docs/05-多端技术架构.md)。

## 验证状态

- 2026-09-28：全量回归记录为 106/106 通过，`flutter analyze` 无问题，`tool/ip_scan.py` PASS。
- 2026-09-30（音频接入后）：全量重跑 106/106 通过，`flutter analyze` 无问题，`tool/ip_scan.py` PASS。重跑时修复三类测试环境问题（just_audio 平台替身、日期敏感夹具、临时目录清理），见 [验收指南](../docs/09-验收指南.md) §6。
- 2026-10-01：用户实测 Web 与 Android 音频输出正常，音频实听验收通过；同日用户完成 Android 设备实机验收。BGM 为用户 AI 生成，权利口径经用户确认（与美术资源一致）。
- 2026-10-01：迷宫属性测试扩至 10 区 × 1000 种子（10,000 组）后全量重跑 106/106，`flutter analyze` 无问题；`dart run benchmark/maze_benchmark.dart` 性能基准达标（最差 16.43 ms / 回放 1000 局 4.43 s）；`flutter test --coverage` 记录 domain 行覆盖 92.6%、lib 整体 69.7%；GitHub Actions CI 建立。
- 2026-10-01：当前工作区 Release APK 重建成功，144.1 MiB，SHA-256 `FF347E0BF396399CA4AD40D5565EB4B015AEE4F1B31F450E86EB2031DD9A1669`；Android Debug 签名，仅用于本地验收。该重建包未再次安装到设备，既有实机验收包哈希未记录。
- 2026-10-02：逐资产台账审计增加表头、行数、重复/额外路径、空格变形路径和完整字段检查；台账工具单测 6/6 通过并纳入 GitHub Actions（2026-10-03 远程首跑通过）。
- 2026-10-02：迷宫性能基准改为三次回放取中位数，超预算返回非零；本机三次为 4498/4627/4490 ms，中位数 4498 ms，复测受负载影响可达 6–8 s（docs/09 §6）。新增 3 个 Flutter 门禁单测后全量回归 109/109；性能门禁和台账单测纳入 CI，2026-10-03 远程首跑通过。
- Web Release 构建（`--pwa-strategy=none`）于 2026-09-28 成功，并在真实浏览器完成引导、回廊、图鉴、专注与云游的交互验收（截图见 `docs/qa/2026-09-28-web-验收/`）。
- 此前 Web 反馈的“引导第三步无法输入”与“回廊入口灰显”均未在当前构建复现，复核结论见 [验收指南](../docs/09-验收指南.md) §4。
- iOS 目录存在，但没有当前构建或设备验收记录（前置条件：Mac 与 Apple 开发者账号）。

更多项目约束与验证边界见仓库根目录的 [README](../README.md)。
