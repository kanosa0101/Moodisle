# 心晴屿 Moodisle

心晴屿是一款以“情绪即天气”为主题的 Flutter 应用：真实待办召唤天气精灵，完成后收服并陪伴专注。当前处于测试打磨阶段；Web、Android 与 iOS 共用 `app/` 中的 Dart/Flutter 实现。iOS 已配置 Windows → GitHub Actions 的手动构建入口，并完成首次无签名 Release 编译；签名和真机验收仍待完成。

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

iOS 必须在 macOS/Xcode 环境构建。Windows 开发机在同一提交的 Linux CI 通过后，前往 GitHub 的 **Actions → iOS Build → Run workflow**，默认选择 `unsigned-app` 做一次无签名 Release 编译。该产物不能安装到 iPhone；真机包需按 [验收指南](docs/09-验收指南.md) 配置 Apple 证书与描述文件后选择 `signed-ipa`。工作流不会随 push 或 pull request 自动运行。

需要在仓库根目录运行资源或原创性工具：

```bash
python tool/asset_pipeline.py todo
python tool/asset_pipeline.py validate
python tool/ip_scan.py .
python tool/check_platform_consistency.py
```

## 当前状态与证据边界

- 当前资产目录含 278 张运行时 PNG 与 2 个中文子集字体（SIL OFL 授权，`tool/subset_font.py` 生成）；`assets-src/assets_manifest.json` 登记 322 项，其中另含 30 张未接入运行时的表情差分、10 张 canon 设定图和 4 张过程图。逐资产来源台账 322/322 覆盖（`tool/generate_ledger_per_asset.py audit`）。
- 当前有 18 个 Flutter 测试文件、110 条测试声明；2026-10-14 全量回归 110/110，迷宫属性测试覆盖 10 区 × 1000 种子。domain 行覆盖 92.6% 为历史开发机记录；迷宫性能门禁、台账工具单测与三端一致性检查已纳入 CI（本机性能数据受负载波动，见 [验收指南](docs/09-验收指南.md) §6）。
- 2026-10-14 已基于 `0.1.0+1` 重建 Web 与 Android Release；Android APK SHA-256 为 `BEA1106109DEE1F60C21B697356C6C78BFFBA1B454D21F8A158913F2C9B426E7`。Web Release 在 390×844 与 844×390 下冒烟通过并修复窄屏标题截断；Android 设备验收仍来自 2026-10-01。iOS 首次无签名构建已通过，修订版本的最终 iOS 编译与签名真机验收按 [验收指南](docs/09-验收指南.md) 执行。
- 音频播放器、静音控制、生命周期、页面事件及 13 项音频资源已接入；音频已于 2026-10-01 在 Web 与 Android 实测通过，BGM 为用户 AI 生成（权利口径经用户确认）。暗色主题、通知、Android 桌面组件、iOS Live Activity、触感与 V2 素材接入为后续范围；详见 [架构](docs/05-多端技术架构.md) 与 [验收指南](docs/09-验收指南.md)。

## 授权

项目没有附带开源许可证。版权与素材来源约束见 `docs/00-版权与原创性策略.md`；不要将仓库内容当作可自由再分发素材。
