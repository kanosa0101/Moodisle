import 'dart:async';

import 'package:flutter/material.dart';

import 'application/game_controller.dart';
import 'domain/config/game_config.dart';
import 'domain/entities/task.dart';
import 'domain/time/local_date.dart';
import 'presentation/pages/coach_page.dart';
import 'presentation/pages/dex_page.dart';
import 'presentation/pages/focus_page.dart';
import 'presentation/pages/grow_page.dart';
import 'presentation/pages/island_page.dart';
import 'presentation/pages/maze_page.dart';
import 'presentation/pages/tasks_page.dart';
import 'shared/theme/tokens.dart';

void main() => runApp(const MoodisleApp());

/// 心晴屿 Moodisle 主应用。
/// 页面骨架对齐原版：460px 居中栏 + 顶栏 + 可滚动视图 + 底部导航。
/// 版权约束：本工程为清洁室原创，禁止引入参考原型代码（docs/00 R1）。
class MoodisleApp extends StatelessWidget {
  const MoodisleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '心晴屿 Moodisle',
      debugShowCheckedModeBanner: false,
      theme: buildMoodisleTheme(),
      home: const _PageFrame(child: AppShell()),
    );
  }
}

/// 460px 居中栏 + 奶油渐变外底（对齐原版 #app 与 body 背景）。
class _PageFrame extends StatelessWidget {
  final Widget child;
  const _PageFrame({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFFFFE9B0), Color(0xFFF6EAD2), Color(0xFFBFE9C0)],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: child,
        ),
      ),
    );
  }
}

/// 应用壳：生命周期桥接（专注宽限）+ 5 Tab + 首次引导 + 每日问候。
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with WidgetsBindingObserver {
  late final GameController _controller;
  int _tab = 0;

  // —— 引导 ——
  bool _coachActive = false;
  int _coachStep = 0;
  Rect? _coachHole;
  final _shellStackKey = GlobalKey();
  final _navBarKey = GlobalKey();
  final _tabIslandKey = GlobalKey();
  final _tabIslandSelKey = GlobalKey();
  final _tabTodoKey = GlobalKey();
  final _tabTodoSelKey = GlobalKey();
  final _tabDexKey = GlobalKey();
  final _tabDexSelKey = GlobalKey();
  final _tabMazeKey = GlobalKey();
  final _tabMazeSelKey = GlobalKey();
  final _growBtnKey = GlobalKey();
  final _addRowKey = GlobalKey();
  final _typeChipsKey = GlobalKey();
  final _taskListKey = GlobalKey();
  final _chainKey = GlobalKey();
  int _tasksAtCoachStart = 0;

  late final List<CoachStep> _steps;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = GameController();
    _steps = [
      CoachStep(_tabTodoSelKey,
          '底部导航：<b>心屿 / 待办 / 图鉴 / 回廊 / 专注</b>（右上角打开成长页）。先去「待办」录入第一件事。',
          tab: 'tasks'),
      CoachStep(_typeChipsKey,
          '先选一个<b>情绪属性</b>——它代表这件事让你产生的情绪，决定召唤哪只天气精灵。共 10 种等你收集。',
          tab: 'tasks'),
      CoachStep(_addRowKey, '输入一件<b>今天真实要做的事</b>，点「召唤」。一只天气精灵就会登上你的心屿。',
          tab: 'tasks', wait: 'add'),
      CoachStep(_taskListKey, '很好！这只精灵正在心屿游荡。<b>在现实中完成这件事后，点右侧 ✓</b> 来安抚收服它。',
          tab: 'tasks', wait: 'capture'),
      CoachStep(_chainKey,
          '按<b>天气循环</b>（雷→雨→雾→霭→云→涡→风→霜→星→霞→雷）连续完成会触发<b>共鸣链</b>：链越长奖励越多。',
          tab: 'tasks'),
      CoachStep(_tabIslandSelKey, '每收服一只，<b>心屿就放晴一点</b>。岛上会看到定居的精灵与游荡的野生怪。',
          tab: 'island'),
      CoachStep(
          _tabDexSelKey, '已收服的精灵进入<b>图鉴</b>；同类任务坚持越多越会进化，觉醒分<b>星宿/深流</b>两线。',
          tab: 'dex'),
      CoachStep(
          _tabMazeSelKey, '完成真实待办积累<b>行动力</b>。回廊是等级吞噬的策略迷宫：先吃小怪攒级，再挑战心结巨灵。',
          tab: 'maze'),
      CoachStep(
          _growBtnKey, '「成长」页有看岛人等级、连晴、签到、成就与<b>心晴周报</b>。准备好了，开始点亮你的心晴屿吧！',
          tab: 'island'),
    ];
    _controller.addListener(_onControllerChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _startup());
  }

  Future<void> _startup() async {
    if (!mounted) return;
    await _controller.ready;
    if (!mounted) return;
    final notice = _controller.restoreNotice;
    if (notice != null) {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          key: const ValueKey('save_recovery_notice'),
          title: const Text('存档恢复提示'),
          content: Text(notice),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('知道了'),
            ),
          ],
        ),
      );
      if (!mounted) return;
    }
    if (!_controller.state.onboarded) {
      _showIntro();
    } else {
      _maybeGreet();
    }
  }

  void _showIntro() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: MoodisleColors.paper,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MoodisleRadii.xl)),
        title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('assets/ui/app_icon.png', width: 30, height: 30),
          const SizedBox(width: 6),
          const Text('欢迎来到心晴屿', textAlign: TextAlign.center),
        ]),
        content: const Text(
            '这是属于你内心的一座小岛。把真实的待办交给它，\n'
            '每件事会化作一只「天气精灵」——完成任务即可安抚收服，让雾蒙蒙的小岛重新放晴。',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, height: 1.7)),
        actions: [
          TextButton(
            key: const ValueKey('intro_skip'),
            onPressed: () {
              Navigator.pop(ctx);
              _controller.finishOnboarding();
            },
            child: const Text('跳过'),
          ),
          FilledButton(
            key: const ValueKey('intro_start'),
            onPressed: () {
              Navigator.pop(ctx);
              _startCoach();
            },
            style:
                FilledButton.styleFrom(backgroundColor: MoodisleColors.orange),
            child: const Text('开始上岛'),
          ),
        ],
      ),
    );
  }

  void _startCoach() {
    _tasksAtCoachStart = _controller.state.tasks.length;
    setState(() {
      _coachActive = true;
      _coachStep = 0;
    });
    _applyStep();
  }

  void _applyStep() {
    final step = _steps[_coachStep];
    setState(() => _coachHole = null);
    if (step.tab.isNotEmpty) _switchTab(step.tab);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _coachHole = _rectOf(step.target));
    });
  }

  void _nextStep() {
    if (_coachStep + 1 >= _steps.length) {
      _endCoach();
      return;
    }
    setState(() => _coachStep++);
    _applyStep();
  }

  void _endCoach() {
    setState(() {
      _coachActive = false;
      _coachHole = null;
    });
    _controller.finishOnboarding();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('引导完成，开始你的心晴之旅。')));
  }

  Rect? _rectOf(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return null;
    final shell = _shellStackKey.currentContext?.findRenderObject();
    if (shell is! RenderBox || !shell.attached) return null;
    final topLeft = shell.globalToLocal(box.localToGlobal(Offset.zero));
    final bottomRight = shell.globalToLocal(
      box.localToGlobal(Offset(box.size.width, box.size.height)),
    );
    return Rect.fromPoints(topLeft, bottomRight);
  }

  /// 引导等待：召唤/收服后自动放行。
  void _onControllerChanged() {
    if (!_coachActive || !mounted) return;
    final wait = _steps[_coachStep].wait;
    if (wait == 'add' && _controller.state.tasks.length > _tasksAtCoachStart) {
      _nextStep();
    } else if (wait == 'capture' && _controller.pendingCapture != null) {
      _nextStep();
    }
  }

  void _maybeGreet() {
    if (_controller.state.daily.lastGreet == LocalDate.today()) return;
    final pend = _controller.state.tasks
        .where((t) => t.status == TaskStatus.pending)
        .length;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _controller.greet();
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: MoodisleColors.paper,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MoodisleRadii.xl)),
          title: const Text('今日心晴', textAlign: TextAlign.center),
          content: Text(
            pend > 0
                ? '心岛上还有 $pend 只天气精灵等你安抚。慢慢来，先从一件小事开始。'
                : '今天还没有待办。录入一件真实要做的事，召唤你的第一只精灵吧。',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, height: 1.6),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              style: FilledButton.styleFrom(
                  backgroundColor: MoodisleColors.orange),
              child: const Text('开始今天'),
            ),
          ],
        ),
      );
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _controller.focusBackgrounded();
      unawaited(_controller.flushSave());
    } else if (state == AppLifecycleState.resumed) {
      _controller.focusResumed();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  void _switchTab(String name) {
    final map = {
      'island': 0,
      'tasks': 1,
      'dex': 2,
      'maze': 3,
      'focus': 4,
    };
    setState(() => _tab = map[name] ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    // 引导遮罩需要盖住 AppBar/底栏 → 整个 Scaffold 包进外层 Stack
    return Stack(key: _shellStackKey, children: [
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Row(children: [
            Image.asset('assets/ui/app_icon.png', width: 30, height: 30),
            const SizedBox(width: 7),
            const Text('心晴屿 Moodisle',
                style: TextStyle(
                    fontWeight: FontWeight.w900, color: Color(0xFF5A3E22))),
          ]),
          actions: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Center(
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text('Lv.${_controller.state.keeper.level}',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: MoodisleColors.ink2)),
                    const SizedBox(width: 5),
                    const Icon(Icons.bolt_rounded,
                        size: 15, color: MoodisleColors.orange),
                    Text('${_controller.state.energy}',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: MoodisleColors.ink2)),
                    const SizedBox(width: 4),
                    const Icon(Icons.wb_sunny_rounded,
                        size: 15, color: MoodisleColors.orange),
                    Text('${_controller.state.items[ItemId.sunnyCrystal] ?? 0}',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: MoodisleColors.ink2)),
                  ]),
                ),
              ),
            ),
            IconButton(
              key: _growBtnKey,
              tooltip: '成长',
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => GrowPage(controller: _controller))),
              icon: const Icon(Icons.local_florist_outlined),
            ),
          ],
        ),
        body: Stack(children: [
          IndexedStack(index: _tab, children: [
            IslandPage(controller: _controller),
            TasksPage(
              controller: _controller,
              addRowKey: _addRowKey,
              typeChipsKey: _typeChipsKey,
              taskListKey: _taskListKey,
              chainKey: _chainKey,
            ),
            DexPage(controller: _controller),
            MazePage(controller: _controller),
            FocusPage(controller: _controller),
          ]),
        ]),
        bottomNavigationBar: NavigationBar(
          key: _navBarKey,
          selectedIndex: _tab,
          onDestinationSelected: (i) => setState(() => _tab = i),
          destinations: [
            _tabDest([_tabIslandKey, _tabIslandSelKey], 'island',
                Icons.landscape_outlined, '心屿'),
            _tabDest([_tabTodoKey, _tabTodoSelKey], 'todo',
                Icons.checklist_outlined, '待办'),
            _tabDest([_tabDexKey, _tabDexSelKey], 'compendium',
                Icons.menu_book_outlined, '图鉴'),
            _tabDest([_tabMazeKey, _tabMazeSelKey], 'maze',
                Icons.explore_outlined, '回廊'),
            const NavigationDestination(
                icon: Icon(Icons.timer_outlined), label: '专注'),
          ],
        ),
      ),
      if (_coachActive)
        Positioned.fill(
          child: CoachOverlay(
            hole: _coachHole,
            stepIndex: _coachStep,
            total: _steps.length,
            text: _steps[_coachStep].text,
            waiting: _steps[_coachStep].wait != null,
            onNext: _nextStep,
            onSkip: _endCoach,
          ),
        ),
    ]);
  }

  NavigationDestination _tabDest(
      List<Key> keys, String name, IconData fallback, String label) {
    Widget tabImg() => Image.asset('assets/ui/tabs/$name.png',
        width: 26, height: 26, errorBuilder: (_, __, ___) => Icon(fallback));
    return NavigationDestination(
      icon: KeyedSubtree(key: keys[0], child: tabImg()),
      selectedIcon: KeyedSubtree(key: keys[1], child: tabImg()),
      label: label,
    );
  }
}
