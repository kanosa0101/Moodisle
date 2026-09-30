# Moodisle 音频接入设计

日期：2026-09-28  
状态：用户已批准；10 个音效按本文件离线合成，3 首 BGM 由用户提供；本文件不代表两端实听已验收。

## 目标与范围

为 Web 和 Android 接入项目既有规格中的 10 种音效与 3 首背景音乐。用户已提供 3 首长音乐；由于当前没有可调用的音效生成模型，10 个短音效由项目 Python 标准库脚本确定性合成。实现负责资源校验、播放器接入、交互触发、生命周期管理和来源记录。

不修改游戏领域规则、存档格式或专注计时，不接入远程音频流，不引用第三方音效采样。

## 素材交付

音效和音乐沿用 `docs/08-美术资产描述总表.md` §6 的声音描述与命名：

| 类型 | 文件名 | 交付规格 |
|---|---|---|
| 音效 | `tap.wav`、`add.wav`、`complete.wav`、`capture.wav`、`evolve.wav`、`light.wav`、`loot.wav`、`levelup.wav`、`error.wav`、`glance.wav` | Python 标准库离线确定性合成；PCM WAV，44.1 kHz，16-bit，mono；短促、柔和、无开头长静音，固定每个音效的随机种子以便复现 |
| BGM | `bgm_sunny.mp3`、`bgm_mist.mp3`、`bgm_night.mp3` | 用户提供的 MP3 原样复制，不转码：44.1 kHz，stereo，约 192 kbps，时长约 177–183 秒；循环首尾待实听验收 |

原始音频放在 `assets-src/audio/original/`，运行时副本放在 `app/assets/audio/`。3 首 BGM 按文件名暂映射为 `Barefoot_on_the_Lawn`→晴朗、`Through_the_Orchard_Gate`→薄雾、`Running_Toward_The_Horizon`→夜晚；这是基于标题的暂定映射，实听确认后可调整。BGM 原件保留用户给出的名称，运行时副本只做重命名且字节一致。

`tool/generate_audio_sfx.py` 只用 Python 标准库生成 10 个 WAV 原件及运行时副本，参数和固定种子写入 `assets-src/audio/manifest.csv`。清单与 `assets-src/ledger.md` 记录 source、工具/模型、提示词或“不适用”、seed/参数、日期、权利/授权信息及 SHA-256。用户提供音乐缺少的模型、提示词和授权字段如实记为“未提供”；不从文件签名推断模型或授权。

## 播放架构

- 使用 `just_audio` 的 Android/Web 共同能力播放应用内资源。依赖版本须兼容 `app/pubspec.yaml` 当前声明的 Dart `>=3.3.0`；不为音频接入提高最低 Dart 版本。
- 在 `app/lib/shared/audio/` 新增 `MoodisleAudioService`，由 `AppShell` 持有并释放。音乐与音效使用独立播放实例；音效按队列顺序播放，避免任务完成、收服、进化和升级提示互相截断。
- 服务只负责播放，不进入 `GameController` 或领域层，也不写入游戏存档。
- 顶栏增加一个统一静音按钮，控制 BGM 和音效；选择只在当前应用运行期间生效，应用重启后恢复默认开启。
- Web 端受浏览器用户手势策略限制：在首次有效用户操作后启动 BGM；若浏览器拒绝播放，不阻断页面交互，后续用户操作时重试。
- 应用进入 `inactive`、`paused` 或 `detached` 时暂停 BGM；回到 `resumed` 时，在未静音且此前已启用播放的情况下恢复。保留现有专注与存档生命周期处理。

## BGM 选择

使用本地时间 18:00–06:00 播放 `bgm_night`，与心屿当前日/夜地图切换时段一致。其余时段中，气候档位为薄雾或浓雾时播放 `bgm_mist`，晴朗时播放 `bgm_sunny`。只在目标曲目改变时切换，不因普通界面重建反复重启曲目。

曲目在首个用户手势之后才开始。Web 端循环点存在轻微间隙的可能，素材应让首尾留有相容的环境氛围，并在 Web 浏览器实听确认。

## 音效触发

| 音效 | 触发条件 |
|---|---|
| `tap` | 底部主导航切换；不覆盖文字输入、滚动和每个普通卡片点击 |
| `add` | 待办成功加入后 |
| `complete` | 待办成功完成后 |
| `capture` | 完成待办并收服伙伴，且本次未进化 |
| `evolve` | 收服结果同时发生形态进化；替代 `capture`，避免叠音 |
| `light` | 回廊成功获得/增加提灯时 |
| `loot` | 回廊成功拾取奖励或领取云游归还奖励时 |
| `levelup` | 看岛人等级或伙伴羁绊等级提升时 |
| `error` | 回廊移动被阻挡或操作被规则拒绝时 |
| `glance` | 点击心屿上的天气伙伴时 |

一次结果同时产生多个提示时按事件顺序排队；进化和收服只播放一个主提示，升级提示随后播放。声音失败、素材缺失或 Web 自动播放被拒绝不得改变游戏状态或显示阻断性错误。

## 验收

播放器服务、静音控制、页面事件和 13 项资源已接入；资源格式、时长、哈希、pubspec 声明、`flutter analyze` 及 Web/Android Release 构建已有通过记录。当前未完成的是 Web/Android 实际听音验收，包括静音、BGM 情绪映射与循环、前后台恢复及 10 个音效触发。音频接入后没有记录全量 `flutter test` 重跑；BGM 的模型、prompt、日期和授权仍为“未提供”，不得据文件元数据推断。详见 docs/09 §1、§6。

最终交付前执行 `flutter analyze`、Web Release（带 `--pwa-strategy=none`）与 Android Release 构建，并在浏览器与 Android 设备分别手动检查静音、BGM 选择/循环/前后台恢复及表中 10 个音效触发。

构建成功只证明资源打包和代码编译。BGM 的情绪映射、曲目循环、静音、10 个触发点及 Android/Web 的实际输出仍需手动实听确认。自动化测试范围不在本设计内。

## 依据

- 当前素材语义以 `docs/08-美术资产描述总表.md` §6 为准。
- `just_audio` 官方平台表列出 Android/Web 的应用内资源播放；官方 API 文档提示 Web 循环点可能有轻微间隙。当前最新包版本要求 Dart 3.6，因此依赖选择需遵守本项目 Dart 3.3 下限：<https://pub.dev/documentation/just_audio/latest/>、<https://pub.dev/packages/just_audio/versions>。
