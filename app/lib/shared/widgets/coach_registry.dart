/// 新手引导重启注册表：AppShell 注册启动回调，成长页等独立路由触发。
/// 单实例应用足够（与 GrowPageRegistry 同款轻量做法，不引入额外依赖）。
library;

class CoachRegistry {
  CoachRegistry._();

  /// 由 AppShell 注入的「重新开始引导」回调；独立页面调用前先自行退出路由，
  /// 保证引导遮罩渲染在主壳 Stack 上可见。
  static void Function()? launch;
}
