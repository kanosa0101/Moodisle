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
import 'package:moodisle_app/presentation/pages/island_page.dart';
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
}
