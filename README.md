# 心晴屿 Moodisle

心晴屿是一款以“情绪即天气”为主题的 Flutter 应用：真实待办召唤天气精灵，完成后收服并陪伴专注。当前处于测试打磨阶段；Web 与 Android 共用 `app/` 中的 Dart/Flutter 实现。iOS 工程目录存在，但本仓库没有当前 iOS 构建或真机验收记录。

## 项目结构

| 路径 | 内容 |
|---|---|
| `app/` | Flutter 应用源码、运行时美术资源和测试 |
| `docs/` | 产品、版权、系统、架构、美术与验收文档 |
| `assets-src/` | 美术源文件、生成台账、提示词、流程图和 SHA256 manifest |
| `tool/` | 资源接入、manifest、覆盖率与原创性扫描工具 |

从 [文档索引](docs/README.md) 开始阅读；新贡献者请先读 [版权与原创性策略](docs/00-版权与原创性策略.md)。

## 本地运行

需要 Flutter/Dart SDK（`app/pubspec.yaml` 要求 Dart `>=3.3.0 <4.0.0`）。

```bash
cd app
flutter pub get
flutter run -d chrome       # Web
flutter run                 # 已连接 Android 设备或模拟器
```

常用检查与构建命令：

```bash
cd app
flutter test
flutter analyze
flutter build web --release --pwa-strategy=none
flutter build apk --release
```

需要在仓库根目录运行资源或原创性工具：

```bash
python tool/asset_pipeline.py todo
python tool/asset_pipeline.py validate
python tool/ip_scan.py .
```

## 当前状态与证据边界

- 当前资产目录含 278 张运行时 PNG 与 2 个中文子集字体（SIL OFL 授权，`tool/subset_font.py` 生成）；`assets-src/assets_manifest.json` 登记 322 项，其中另含 30 张未接入运行时的表情差分、10 张 canon 设定图和 4 张过程图。逐资产来源台账 322/322 覆盖（`tool/generate_ledger_per_asset.py audit`）。
- 当前有 18 个 Flutter 测试文件、109 条测试声明；2026-10-02 全量回归 109/109，迷宫属性测试覆盖 10 区 × 1000 种子。domain 行覆盖 92.6% 为开发机记录；迷宫性能门禁与台账工具单测已纳入 CI，2026-10-03 远程首跑通过（本机基准数据受负载波动，见 [验收指南](docs/09-验收指南.md) §6）。GitHub Actions 执行 analyze、Flutter 测试、迷宫性能门禁、台账工具单测、资产校验、清洁室扫描与台账审计。
- Web Release 构建于 2026-09-28 成功，并已在真实浏览器完成引导、回廊、图鉴、专注与云游的交互验收（截图见 `docs/qa/2026-09-28-web-验收/`）。Android 设备验收由用户于 2026-10-01 完成；生成目录不纳入 Git。
- 音频播放器、静音控制、生命周期、页面事件及 13 项音频资源已接入；音频已于 2026-10-01 在 Web 与 Android 实测通过，BGM 为用户 AI 生成（权利口径经用户确认）。暗色主题、通知、Android 桌面组件、iOS Live Activity、触感与 V2 素材接入为后续范围；详见 [架构](docs/05-多端技术架构.md) 与 [验收指南](docs/09-验收指南.md)。

## 授权

项目没有附带开源许可证。版权与素材来源约束见 `docs/00-版权与原创性策略.md`；不要将仓库内容当作可自由再分发素材。
