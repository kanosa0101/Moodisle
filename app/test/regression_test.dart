import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moodisle_app/application/game_controller.dart';
import 'package:moodisle_app/data/save_codec.dart';
import 'package:moodisle_app/data/save_store.dart';
import 'package:moodisle_app/domain/config/game_config.dart';
import 'package:moodisle_app/domain/engine/eco_sim.dart';
import 'package:moodisle_app/domain/engine/maze/maze_models.dart';
import 'package:moodisle_app/domain/entities/emotion.dart';
import 'package:moodisle_app/domain/entities/game_state.dart';
import 'package:moodisle_app/domain/entities/pet.dart';
import 'package:moodisle_app/domain/entities/social.dart';
import 'package:moodisle_app/domain/events/game_events.dart';
import 'package:moodisle_app/domain/game_core.dart';
import 'package:moodisle_app/domain/time/local_date.dart';
import 'package:moodisle_app/main.dart';
import 'package:moodisle_app/presentation/pages/coach_page.dart';
import 'package:moodisle_app/presentation/pages/dex_page.dart';
import 'package:moodisle_app/presentation/pages/focus_page.dart';
import 'package:moodisle_app/presentation/pages/grow_page.dart';
import 'package:moodisle_app/presentation/pages/island_page.dart';
import 'package:moodisle_app/presentation/pages/tasks_page.dart';
import 'package:moodisle_app/shared/audio/moodisle_audio_scope.dart';
import 'package:moodisle_app/presentation/widgets/game_icons.dart';
import 'package:moodisle_app/presentation/widgets/pet_sprite.dart';

import 'helpers/temp_dir_cleanup.dart';

/// 识别持有已解码世界地图的画笔（_MapImagePainter 持有 image；其余画笔无该成员）。
bool hasMapImagePainter(Widget widget) {
  if (widget is! CustomPaint) return false;
  try {
    return (widget.painter as dynamic).image != null;
  } on NoSuchMethodError {
    return false;
  }
}

Widget _coachHarness({required bool waiting, required VoidCallback onNext}) =>
    MaterialApp(
      home: Scaffold(
        body: CoachOverlay(
          hole: null,
          stepIndex: 2,
          total: 9,
          text: '输入一件今天真实要做的事',
          waiting: waiting,
          onNext: onNext,
          onSkip: () {},
        ),
      ),
    );

void main() {
  const pathProvider = MethodChannel('plugins.flutter.io/path_provider');
  late Directory documents;

  setUp(() {
    documents = Directory.systemTemp.createTempSync('moodisle-widget-test-');
    // getTemporaryDirectory 单独指向系统临时目录，避免 just_audio 资产缓存
    // 写入存档目录导致 teardown 删除时句柄未释放（Windows errno 32）。
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProvider, (call) async {
      return call.method == 'getTemporaryDirectory'
          ? Directory.systemTemp.path
          : documents.path;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProvider, null);
    deleteTempDirWithRetry(documents);
  });

  testWidgets('390px 窄屏顶栏使用短标题', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    try {
      await tester.pumpWidget(const MoodisleApp());
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('心晴屿'), findsOneWidget);
      expect(find.text('心晴屿 Moodisle'), findsNothing);
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
    }
  });

  testWidgets('专注页临时停 BGM，离页不覆盖用户静音偏好', (tester) async {
    await tester.pumpWidget(const MoodisleApp());
    await tester.pump(const Duration(milliseconds: 600));
    await tester.tap(find.byKey(const ValueKey('intro_skip')));
    await tester.pump(const Duration(milliseconds: 400));
    final audio = tester
        .widget<MoodisleAudioScope>(find.byType(MoodisleAudioScope))
        .service;
    expect(audio.isMusicSuppressed, isFalse);
    await tester.tap(find.text('专注'));
    await tester.pump();
    expect(audio.isMusicSuppressed, isTrue);
    expect(audio.isMuted, isFalse);
    audio.toggleMuted();
    await tester.tap(find.text('心屿'));
    await tester.pump();
    expect(audio.isMusicSuppressed, isFalse);
    expect(audio.isMuted, isTrue);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('待办界面展开完成列表后按日期显示历史任务', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final state = GameState.fresh();
    final core = GameCore(state);
    core.addTask('昨天的事', Emotion.sloth, 1, DateTime(2026, 11, 15));
    core.completeTask(1, now: DateTime(2026, 11, 16));
    core.addTask('历史的事', Emotion.sloth, 1, DateTime(2026, 10, 1));
    core.completeTask(2, now: DateTime(2026, 10, 2));
    final json = saveToJson(state);
    ((json['tasks'] as List).singleWhere((task) => task['id'] == 2) as Map)
        .remove('completedOn');
    final controller = GameController(state: decodeSave(jsonEncode(json)));
    await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: TasksPage(controller: controller))));
    final expand = find.textContaining('已安抚 2 只');
    await tester.ensureVisible(expand);
    await tester.tap(expand);
    await tester.pump();
    expect(find.textContaining('2026-11-16'), findsOneWidget);
    expect(find.textContaining('历史完成 · 完成日期未记录'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    controller.dispose();
  });

  testWidgets('开始上岛后第一步和下一步引导卡片都可见', (tester) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    try {
      await tester.pumpWidget(const MoodisleApp());
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byKey(const ValueKey('intro_start')), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('intro_start')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.text('第 1 / 9 步'), findsOneWidget);
      expect(find.textContaining('先去「待办」录入第一件事'), findsOneWidget);
      expect(find.textContaining('<b>'), findsNothing);
      final shell = tester.getRect(find.byType(AppShell));
      final tipCard =
          tester.getRect(find.byKey(const ValueKey('coach_tip_card')));
      expect(tipCard.left, greaterThanOrEqualTo(shell.left));
      expect(tipCard.right, lessThanOrEqualTo(shell.right));
      expect(tipCard.top, greaterThanOrEqualTo(shell.top));
      expect(tipCard.bottom, lessThanOrEqualTo(shell.bottom));

      await tester.tap(find.text('下一步'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('第 2 / 9 步'), findsOneWidget);
      expect(find.textContaining('共 10 种等你收集'), findsOneWidget);
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
    }
  });

  testWidgets('引导等待步骤在洞就绪前只拦截不推进', (tester) async {
    var next = 0;
    await tester.pumpWidget(_coachHarness(waiting: true, onNext: () => next++));
    await tester.pump();
    await tester.tap(find.byType(CoachOverlay));
    await tester.pump();
    expect(next, 0, reason: '等待步骤洞未就绪时点击不应触发推进（避免误触跳步）');
  });

  testWidgets('引导普通步骤点击空白处推进', (tester) async {
    var next = 0;
    await tester
        .pumpWidget(_coachHarness(waiting: false, onNext: () => next++));
    await tester.pump();
    await tester.tap(find.byType(CoachOverlay));
    await tester.pump();
    expect(next, 1, reason: '非等待步骤点击高亮区外应推进');
  });

  testWidgets('引导第三步输入框可直接输入，召唤后自动放行', (tester) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    try {
      await tester.pumpWidget(const MoodisleApp());
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.byKey(const ValueKey('intro_start')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      // 推进到等待真实输入的第 3 步（高亮添加面板）
      await tester.tap(find.text('下一步'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      await tester.tap(find.text('下一步'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('第 3 / 9 步'), findsOneWidget);

      // 提示卡片不得遮挡输入框；洞内输入框可点击、可输入
      final fieldRect = tester.getRect(find.byType(TextField).first);
      final tipRect =
          tester.getRect(find.byKey(const ValueKey('coach_tip_card')));
      expect(fieldRect.overlaps(tipRect), isFalse, reason: '引导提示卡片不得遮挡录入框');
      await tester.tap(find.byType(TextField).first);
      await tester.enterText(find.byType(TextField).first, '写周报');
      await tester.tap(find.text('召唤'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // 召唤成功 → 引导自动放行到第 4 步
      expect(find.text('第 4 / 9 步'), findsOneWidget);
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
    }
  });

  testWidgets('首屏等待存档恢复后再判断是否显示首次引导', (tester) async {
    final saved = GameState.fresh()..onboarded = true;
    await SaveStore().save(encodeSave(saved));
    final directoryRead = Completer<String>();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProvider, (_) => directoryRead.future);

    try {
      await tester.pumpWidget(const MoodisleApp());
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('欢迎来到心晴屿'), findsNothing);
      expect(find.text('今日心晴'), findsNothing);

      directoryRead.complete(documents.path);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byKey(const ValueKey('intro_start')), findsNothing);
      expect(find.text('今日心晴'), findsOneWidget);
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
    }
  });

  testWidgets('图鉴卡片中的精灵图片随卡片放大', (tester) async {
    final controller = GameController();
    try {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 428,
            child: DexPage(controller: controller),
          ),
        ),
      ));
      await tester.pump();

      expect(
        tester.getSize(find.byType(PetSprite).first).width,
        greaterThan(100),
      );
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
    }
  });

  testWidgets('装扮商店图片随卡片放大', (tester) async {
    final controller = GameController();
    try {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 428,
            height: 900,
            child: IslandPage(controller: controller),
          ),
        ),
      ));
      await tester.pump();
      final firstDecor = find.byType(SouvenirIcon).first;
      await tester.ensureVisible(firstDecor);
      await tester.pump();

      expect(tester.getSize(firstDecor).width, greaterThan(70));
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
    }
  });

  testWidgets('地图以世界图经相机窗口裁切绘制到视口', (tester) async {
    final controller = GameController();
    try {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 428,
            height: 900,
            child: IslandPage(controller: controller),
          ),
        ),
      ));
      await tester.pump();
      await tester.runAsync(() async {
        // 真实异步窗口：等待 rootBundle + 图片解码完成（FakeAsync 不推进引擎 IO）
        await Future<void>.delayed(const Duration(milliseconds: 150));
      });
      await tester.pump();

      // 场景画笔持有一张已解码的世界地图（assets/island/map_* 部署且加载成功）
      final mapPainters = find.byWidgetPredicate(hasMapImagePainter);
      expect(mapPainters, findsOneWidget);

      // 相机钳制在世界范围内：视口 428×300 按相机窗口从世界图裁切
      final painter =
          tester.widget<CustomPaint>(mapPainters).painter! as dynamic;
      expect(painter.cam.dx, inInclusiveRange(0, kWorldW - kViewW));
      expect(painter.cam.dy, inInclusiveRange(0, kWorldH - kViewH));
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
    }
  });

  for (final width in [390.0, 800.0]) {
    testWidgets('$width 宽度地图斜滑保留二维位移，区域外仍可滚动', (tester) async {
      tester.view.physicalSize = Size(width, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = GameController();
      try {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(body: IslandPage(controller: controller)),
        ));
        await tester.pump();
        final map = find.byWidgetPredicate((w) {
          if (w is! CustomPaint) return false;
          try {
            return (w.painter as dynamic).cam is Offset;
          } on NoSuchMethodError {
            return false;
          }
        });
        Offset camera() =>
            (tester.widget<CustomPaint>(map).painter as dynamic).cam as Offset;
        final scroll = tester.state<ScrollableState>(
          find.descendant(
            of: find.byType(IslandPage),
            matching: find.byType(Scrollable),
          ).first,
        ).position;
        for (final delta in [
          const Offset(-6, -10),
          const Offset(10, 6),
          const Offset(-10, 0),
          const Offset(0, 10),
        ]) {
          final before = camera();
          final gesture = await tester.startGesture(tester.getCenter(map));
          for (var i = 0; i < 8; i++) {
            await gesture.moveBy(delta);
            await tester.pump(const Duration(milliseconds: 16));
          }
          await gesture.up();
          await tester.pump();
          final moved = camera() - before;
          if (delta.dx != 0) expect(moved.dx * delta.dx, lessThan(0));
          if (delta.dy != 0) expect(moved.dy * delta.dy, lessThan(0));
          if (delta.dx != 0 && delta.dy != 0) {
            expect(moved.dx / moved.dy, closeTo(delta.dx / delta.dy, 0.01));
          }
          expect(scroll.pixels, 0);
        }
        // 同一次拖动先竖滑再横滑，也应保留后半段的横向移动。
        final turning = await tester.startGesture(tester.getCenter(map));
        await turning.moveBy(const Offset(0, -40));
        await tester.pump();
        final beforeTurn = camera();
        await turning.moveBy(const Offset(-50, 0));
        await tester.pump();
        expect(camera().dx - beforeTurn.dx, closeTo(50, 0.01));
        await turning.up();
        expect(scroll.pixels, 0);
        final belowMap =
            Offset(width / 2, tester.getBottomLeft(map).dy + 40);
        await tester.dragFrom(belowMap, const Offset(0, -100));
        await tester.pump();
        expect(scroll.pixels, greaterThan(0));
        expect(tester.takeException(), isNull);
      } finally {
        await tester.pumpWidget(const SizedBox.shrink());
        controller.dispose();
      }
    });
  }

  test('导入存档保留所有已编码状态', () {
    final source = GameState.fresh()
      ..onboarded = true
      ..lastReportWeek = const LocalDate(2026, 9, 21);
    source.stats
      ..mistDewCollected = 7
      ..deepDives = 3;
    source.achievements.add('first_capture');
    source.roam
      ..slots.add(RoamSlot(
        pet: Emotion.sloth,
        routeId: 'monsoon',
        startedAt: DateTime(2026, 9, 27, 8),
        durationMs: 1800000,
      ))
      ..souvenirs['rainbow_arch'] = 2
      ..pendant = 'cloudBell';
    source.social
      ..myName = '晴屿'
      ..visitingPet = Emotion.emo
      ..visitingExpire = DateTime(2026, 9, 28);
    source.social.postcards.add(Postcard(
      code: 'TEST-CODE',
      friendName: '小云',
      friendPet: Emotion.anxious,
      receivedAt: DateTime(2026, 9, 27, 9),
    ));
    GameCore(source).ensureDaily(DateTime.now());

    final controller = GameController(state: GameState.fresh());
    addTearDown(controller.dispose);
    expect(controller.importSaveJson(encodeSave(source)), isTrue);
    expect(encodeSave(controller.state), encodeSave(source));
  });

  test('每日回廊次数校验使用传入的游戏日期', () {
    final now = DateTime.now().add(const Duration(days: 5));
    final state = GameState.fresh()
      ..daily.date = LocalDate.today(now)
      ..daily.mazeToday = GameConfig.baseDailyMaze;
    state.pets[Emotion.sloth] = PetRecord(
      emotion: Emotion.sloth,
      count: 1,
      stage: PetStage.clear,
      bond: Bond(minutes: 0),
    );
    state
      ..companion = Emotion.sloth
      ..energy = 2;
    final core = GameCore(state);

    final events = core.startMaze(0, now: now);

    expect(state.energy, 2);
    expect(core.activeMazeRun, isNull);
    expect(
      events
          .whereType<GameNotice>()
          .any((event) => event.text.contains('今日探索次数已用完')),
      isTrue,
    );
  });

  test('购买装饰后立即通知依赖它的界面', () {
    final state = GameState.fresh()..items[ItemId.sunnyCrystal] = 100;
    final controller = GameController(state: state, rng: Random(1));
    addTearDown(controller.dispose);
    var notifications = 0;
    controller.addListener(() => notifications++);

    controller.buyDecor('breeze_chime_stand');

    expect(state.roam.souvenirs['breeze_chime_stand'], 1);
    expect(notifications, 1);
  });

  test('导出和导入保留进行中的回廊与撤销历史', () {
    final state = GameState.fresh()..items[ItemId.sunnyCrystal] = 0;
    state.pets[Emotion.sloth] = PetRecord(
      emotion: Emotion.sloth,
      count: 1,
      stage: PetStage.clear,
      bond: Bond(minutes: 0),
    );
    state
      ..companion = Emotion.sloth
      ..energy = 3;
    final controller = GameController(state: state, rng: Random(1));
    addTearDown(controller.dispose);
    controller.startMaze(0);
    final run = controller.mazeRun!;
    final start = run.pos;
    final next = neighbors(start.x, start.y, run.floor.w, run.floor.h)
        .where((p) => run.walkable(p.x, p.y))
        .first;
    run.step(next.x - start.x, next.y - start.y);
    final raw = controller.exportSaveJson();

    expect(
        (jsonDecode(raw) as Map<String, dynamic>)['activeMazeRun'], isNotNull);
    final restored = GameController(state: GameState.fresh(), rng: Random(1));
    addTearDown(restored.dispose);
    expect(restored.importSaveJson(raw), isTrue);
    expect(restored.mazeRun, isNotNull);
    expect(restored.mazeRun!.pos, next);
    expect(restored.mazeRun!.undo(), isTrue);
    expect(restored.mazeRun!.pos, start);
  });

  testWidgets('专注 UI 直接按截止时间刷新，切应用暂停、息屏继续', (tester) async {
    final state = GameState.fresh();
    state.pets[Emotion.sloth] = PetRecord(
      emotion: Emotion.sloth,
      count: 1,
      stage: PetStage.clear,
      bond: Bond(minutes: 0),
    );
    var now = DateTime(2026, 11, 15, 10);
    final controller = GameController(
        state: state, rng: Random(1), focusNow: () => now);
    controller.startFocus(Emotion.sloth, 25);
    try {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: FocusPage(controller: controller)),
      ));
      await tester.pump();
      expect(find.text('25:00'), findsOneWidget);
      now = now.add(const Duration(milliseconds: 999));
      controller.setCompanion(Emotion.sloth);
      await tester.pump(const Duration(milliseconds: 999));
      expect(find.text('25:00'), findsOneWidget);
      now = now.add(const Duration(milliseconds: 1));
      await tester.pump(const Duration(milliseconds: 1));
      expect(find.text('24:59'), findsOneWidget);
      // 没有心跳时，普通界面重建也必须根据当前时间显示正确倒计时。
      now = now.add(const Duration(seconds: 24));
      controller.setCompanion(Emotion.sloth);
      await tester.pump();
      expect(state.session!.accumSeconds, 1);
      expect(find.text('24:35'), findsOneWidget,
          reason: '显示不能依赖上一次心跳的累计秒数');
      now = now.add(const Duration(seconds: 47));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('23:48'), findsOneWidget);
      controller.focusBackgrounded();
      now = now.add(const Duration(minutes: 5));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('23:48'), findsOneWidget);
      controller.focusResumed();
      now = now.add(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('23:47'), findsOneWidget);
      controller.focusScreenLocked();
      now = now.add(const Duration(minutes: 24));
      controller.focusResumed();
      await tester.pump();
      expect(find.text('专注完成！'), findsOneWidget);
      expect(state.stats.totalFocusSessions, 1);
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
    }
  });

  testWidgets('成长页可重新开始新手引导', (tester) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    try {
      await tester.pumpWidget(const MoodisleApp());
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.byKey(const ValueKey('intro_skip')));
      await tester.pump(const Duration(milliseconds: 400));

      await tester.tap(find.byIcon(Icons.local_florist_outlined));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      // 引导面板位于成长页列表深处（成就墙之后），先滚动到它被懒构建
      final growScrollable = find
          .descendant(
            of: find.byType(GrowPage),
            matching: find.byType(Scrollable),
          )
          .first;
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('replay_coach')),
        300,
        scrollable: growScrollable,
      );
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('replay_coach')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('第 1 / 9 步'), findsOneWidget,
          reason: '重新引导应回到第 1 步并显示引导卡片');
      expect(find.textContaining('先去「待办」录入第一件事'), findsOneWidget);
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
    }
  });

  testWidgets('心屿地图竖向拖动平移地图而不是滚动整页', (tester) async {
    tester.view.physicalSize = const Size(428, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final controller = GameController();
    try {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 428,
            height: 900,
            child: IslandPage(controller: controller),
          ),
        ),
      ));
      await tester.pump();

      final scrollable = find
          .descendant(
            of: find.byType(IslandPage),
            matching: find.byType(Scrollable),
          )
          .first;
      final position = tester.state<ScrollableState>(scrollable).position;
      expect(position.pixels, 0);

      // 在地图面板中央竖向下拖：应由地图手势接管，整页不滚动
      final mapCenter = tester.getCenter(find.byType(GestureDetector).first);
      final gesture = await tester.startGesture(mapCenter);
      await gesture.moveBy(const Offset(0, 120));
      await gesture.up();
      await tester.pump();

      expect(position.pixels, 0,
          reason: '地图上的竖向拖动不应触发整页 ListView 滚动');
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
    }
  });
}
