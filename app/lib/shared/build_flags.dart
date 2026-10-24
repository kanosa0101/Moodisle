/// 构建期平台标记（docs/superpowers/plans/2026-10-24-wechat-miniprogram.md M4）。
///
/// 微信小程序构建经 `--dart-define=MOODISLE_MP=1` 注入，仅在小程序产物中为 true：
/// - 不注入 SQLite 仓库：drift 的 wasm/worker 在微信运行时不可用，
///   JSON 存档走 localStorage 垫片（wx.*StorageSync 承载）；
/// - 专注文案采用"切后台暂停"语义：小程序无锁屏信号，与 web 同边界。
const kMoodisleMp = bool.fromEnvironment('MOODISLE_MP');
