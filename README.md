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
flutter build web --release
flutter build apk --release
```

需要在仓库根目录运行资源或原创性工具：

```bash
python tool/asset_pipeline.py todo
python tool/asset_pipeline.py validate
python tool/ip_scan.py .
```

## 当前状态与证据边界

- 当前资产目录含 278 张运行时 PNG；`assets-src/assets_manifest.json` 登记 322 项，其中另含 30 张未接入运行时的表情差分、10 张 canon 设定图和 4 张过程图。
- 测试目录现有 17 个测试文件、103 条测试声明。最近一次已记录的全量通过结果是旧版 89 项；103 项尚未在最近 UI 修改后重跑。
- Web Release 构建于 2026-09-28 成功。Android APK 和设备测试应在最新源码上重新构建、验收；生成目录不纳入 Git。
- 当前 Web 测试还反馈引导第三步无法输入、回廊入口持续灰显；复现和原因待确认，见 [验收指南](docs/09-验收指南.md)。
- Android 桌面组件、iOS Live Activity、通知、音频、触感和暗色主题未作为当前已交付能力宣称；详见 [架构](docs/05-多端技术架构.md) 与 [验收指南](docs/09-验收指南.md)。

## 授权

项目没有附带开源许可证。版权与素材来源约束见 `docs/00-版权与原创性策略.md`；不要将仓库内容当作可自由再分发素材。
