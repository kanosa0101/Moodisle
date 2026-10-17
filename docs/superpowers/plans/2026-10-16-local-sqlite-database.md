# 本地 SQLite 数据库实施计划

## 目标

把 Moodisle 的运行时持久化从 JSON 整档迁移到 SQLite，同时保持离线单机运行、Web/Android/iOS 共用领域模型，并继续支持 JSON v2 手动导入导出。旧 JSON/备份只在数据库首次初始化时读取，成功迁移后由 SQLite 成为自动保存的唯一来源。

## 结构决策

- 使用 Drift 管理跨平台 SQLite、类型化表、事务和 schema migration；领域层不依赖 Drift。
- 以单例玩家档案、待办、伙伴、库存、统计/气候/专注/每日进度、云游与明信片、成就及迷宫运行状态建立关系表；枚举 ID 作为稳定键，外键保护实体引用。
- 仅存储源数据。伙伴形态和羁绊等级、迷宫地形均由现有规则/种子推导。
- 一次完整状态写入使用单事务，避免部分表先后写入造成不一致。
- Drift schema 版本独立于 JSON 导出格式版本；旧 JSON v2 解码复用现有 `SaveCodec`。
- Web 使用与锁定的 Drift 版本匹配的 WASM/worker 资源；Android/iOS 使用 Drift 原生连接器。

## 执行步骤

1. 增加 Drift 表、外键、检查约束、索引、单例初始化及 schema migration；生成类型化代码。
2. 实现 `GameState`/`MazeRun` 与关系表之间的 repository 映射；全状态事务保存与读取。
3. 在控制器启动时先读取数据库；无数据库档案时验证并迁移旧 JSON/备份，若无旧档则保存新档；JSON 手动导入后写入 SQLite。
4. 配置 Web WASM/worker 资源及包锁版本；保持旧 JSON 文件作为迁移期恢复来源，不再双写。
5. 同步更新内部架构/存档文档和可执行资源清单，运行静态分析与目标平台构建检查；推送后运行 Linux CI，不手动触发 iOS 工作流以减少 macOS 构建次数。

## 验收标准

- 所有现有 `GameState` 和正在进行的 `MazeRun` 字段都能经关系表往返，不丢游戏进度。
- 首次启动可以从有效主 JSON 或损坏时的有效备份完成一次性迁移；后续启动只从 SQLite 恢复。
- 单次状态持久化在一个数据库事务内；外键和约束保护关键引用和值域。
- Flutter Web、Android 可在本机完成对应构建检查；iOS 通过共享 Dart/SQLite 接入静态检查，实际签名与真机验收仍走现有 GitHub Actions/Apple 流程。
- 保留 JSON v2 导入导出兼容；数据库 schema 迁移版本独立维护。

## 风险和处理

- Web SQLite 要求 WASM、worker 与 Drift 版本兼容：锁定版本并将配套资源纳入 `web/`，避免运行时下载。
- 初次切换时既有 Web localStorage 与原生 JSON 路径不同：使用现有 `SaveStore.load()` 作只读迁移源；迁移成功才写入玩家档案。
- Web 存储和多标签安全性取决于浏览器能力及安全响应头：Drift 可选择 OPFS/IndexedDB，也可能退到内存或不适合多标签同步的实现。目标浏览器（含隐私模式、Android Chrome 若需覆盖）必须单独验收；不把一次 Release 构建当作持久化验收。

## 执行记录（2026-10-16）

- 完成 29 张关系表、目录外键、关键值检查约束、索引、WASM/worker 配套资源和 Drift 生成代码；保留 JSON v2 导入/导出及旧存档首次迁移/故障降级路径。
- 完成 `GameState` 与 `MazeRun` 映射。待办和成就保存原有列表位置；回廊撤销快照、格子状态与奖励分行存储；形态、羁绊等级和地图地形继续由领域规则推导。
- `dart run build_runner build` 完成；`flutter analyze --no-pub` 无问题。
- `flutter build web --release --pwa-strategy=none` 成功；`flutter build apk --debug --target-platform android-arm64` 成功，APK 内确认包含 `lib/arm64-v8a/libsqlite3.so`。未运行测试套件、未触发 GitHub Actions；iOS 签名和真机验收仍需 Apple/macOS 流程。
- Android Debug 引擎依赖通过命令级 `FLUTTER_STORAGE_BASE_URL` 从 Flutter 镜像获取；未更改项目仓库配置。
