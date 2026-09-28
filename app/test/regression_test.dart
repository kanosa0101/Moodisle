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
import 'package:moodisle_app/presentation/pages/dex_page.dart';
import 'package:moodisle_app/presentation/pages/island_page.dart';
import 'package:moodisle_app/presentation/widgets/game_icons.dart';
import 'package:moodisle_app/presentation/widgets/pet_sprite.dart';

void main() {
  const pathProvider = MethodChannel('plugins.flutter.io/path_provider');
  late Directory documents;

  setUp(() {
    documents = Directory.systemTemp.createTempSync('moodisle-widget-test-');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProvider, (_) async => documents.path);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProvider, null);
    documents.deleteSync(recursive: true);
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

  testWidgets('首屏等待存档恢复后再判断是否显示首次引导', (tester) async {
    final saved = GameState.fresh()..onboarded = true;
    await SaveStore().save(encodeSave(saved));
    final directoryRead = Completer<String>();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProvider, (_) => directoryRead.future);

    try {
      await tester.pumpWidget(const MoodisleApp());
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('🏝️ 欢迎来到心晴屿'), findsNothing);
      expect(find.text('🌅 今日心晴'), findsNothing);

      directoryRead.complete(documents.path);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byKey(const ValueKey('intro_start')), findsNothing);
      expect(find.text('🌅 今日心晴'), findsOneWidget);
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

  testWidgets('地图资源按大世界尺寸绘制，再由视口裁切', (tester) async {
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
      final map = find.byWidgetPredicate((widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage)
              .assetName
              .startsWith('assets/island/map_'));

      expect(map, findsOneWidget);
      expect(tester.getSize(map), const Size(kWorldW, kWorldH));
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
