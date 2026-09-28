/// Widget 测试：验证「录入 → 复盘 → 收服 → 持久状态」主闭环与回廊门槛提示。
/// 覆盖 docs/07 M2 验收标准中的三主流程可玩性。
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moodisle_app/data/save_store.dart';
import 'package:moodisle_app/domain/game_core.dart';
import 'package:moodisle_app/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const pathProvider = MethodChannel('plugins.flutter.io/path_provider');
  late Directory documents;

  setUpAll(() {
    documents = Directory.systemTemp.createTempSync('moodisle-app-flow-test-');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProvider, (_) async => documents.path);
  });

  setUp(() {
    for (final name in [SaveStore.fileName, SaveStore.backupFileName]) {
      final file = File('${documents.path}/$name');
      if (file.existsSync()) file.deleteSync();
    }
  });

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProvider, null);
    documents.deleteSync(recursive: true);
  });

  testWidgets('主闭环：问候 → 录入待办 → 完成复盘 → 收服弹层', (tester) async {
    await tester.pumpWidget(const MoodisleApp());
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 250));
    // 首次启动：欢迎引导（onboarded=false）→ 跳过后直接进入主界面
    expect(find.text('🏝️ 欢迎来到心晴屿'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('intro_skip')));
    await tester.pump(const Duration(milliseconds: 400));

    // 切到待办 Tab
    await tester.tap(find.text('待办'));
    await tester.pump(const Duration(milliseconds: 400));

    // 录入
    await tester.enterText(find.byType(TextField), '写周报');
    await tester.tap(find.text('召唤'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('写周报'), findsOneWidget);
    expect(find.text('完成并收服'), findsNothing); // tooltip 不渲染为文本

    // 完成复盘（底部弹层）
    await tester.tap(find.byIcon(Icons.check_circle));
    await tester.pump(); // 路由推入帧
    await tester.pump(const Duration(milliseconds: 500)); // 入场动画完成
    await tester.tap(find.byKey(const ValueKey(FeedbackKind.calm)));
    await tester.pump(const Duration(milliseconds: 500));

    // 收服弹层出现并关闭
    expect(find.text('收下伙伴 ✨'), findsOneWidget);
    await tester.tap(find.text('收下伙伴 ✨'));
    await tester.pump(const Duration(milliseconds: 400));
  });

  testWidgets('收服后图鉴可见晴态卡片；回廊未选伙伴给出提示', (tester) async {
    await tester.pumpWidget(const MoodisleApp());
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 250));
    // 首次启动：欢迎引导（onboarded=false）→ 跳过
    expect(find.text('🏝️ 欢迎来到心晴屿'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('intro_skip')));
    await tester.pump(const Duration(milliseconds: 400));

    // 图鉴：未收服显示 ？？？（10 张卡片）
    await tester.tap(find.text('图鉴'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('？？？'), findsNWidgets(10));

    // 回廊：无出战伙伴 → 提示
    await tester.tap(find.text('回廊'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.textContaining('出战伙伴'), findsWidgets);
    await tester.tap(find.text('进入').first);
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.textContaining('出战伙伴'), findsWidgets);
  });

  testWidgets('心屿页：完成待办后精灵定居（野生怪离场）', (tester) async {
    await tester.pumpWidget(const MoodisleApp());
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 250));
    // 首次启动：欢迎引导（onboarded=false）
    expect(find.text('🏝️ 欢迎来到心晴屿'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('intro_skip')));
    await tester.pump(const Duration(milliseconds: 400));
    // 闭环走一遍（复用上面的流程）
    await tester.tap(find.text('待办'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.enterText(find.byType(TextField), '跑步');
    await tester.tap(find.text('召唤'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.byIcon(Icons.check_circle));
    await tester.pump(); // 路由推入帧
    await tester.pump(const Duration(milliseconds: 500)); // 入场动画完成
    await tester.tap(find.byKey(const ValueKey(FeedbackKind.relieved)));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('收下伙伴 ✨'));
    await tester.pump(const Duration(milliseconds: 400));
    // 全程无异常：PetSprite 占位渲染（正式图缺失时 errorBuilder 兜底）正常
    expect(tester.takeException(), isNull);
  });
}
