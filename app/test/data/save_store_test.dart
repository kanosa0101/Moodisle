import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moodisle_app/application/game_controller.dart';
import 'package:moodisle_app/data/save_codec.dart';
import 'package:moodisle_app/data/save_store.dart';
import 'package:moodisle_app/domain/entities/game_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const pathProvider = MethodChannel('plugins.flutter.io/path_provider');
  late Directory documents;

  setUp(() async {
    documents = await Directory.systemTemp.createTemp('moodisle-save-test-');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProvider, (_) async => documents.path);
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProvider, null);
    await documents.delete(recursive: true);
  });

  test('主存档损坏时回退读取有效备份', () async {
    final backup = encodeSave(GameState.fresh());
    await File('${documents.path}/${SaveStore.fileName}.bak')
        .writeAsString(backup);
    await File('${documents.path}/${SaveStore.fileName}')
        .writeAsString('{invalid');

    final store = SaveStore();
    expect(await store.load(), backup);
    expect(store.recoveredFromBackup, isTrue);
    expect(store.hadCorruptSave, isTrue);
  });

  test('保存新档前保留上一份有效主存档', () async {
    final store = SaveStore();
    final first = encodeSave(GameState.fresh()..onboarded = true);
    final second = encodeSave(GameState.fresh()..onboarded = false);
    await store.save(first);
    await store.save(second);

    expect(
      await File('${documents.path}/${SaveStore.fileName}.bak').readAsString(),
      first,
    );
    expect(await store.load(), second);
  });

  test('备份恢复后控制器保留存档并提供明确提示', () async {
    final saved = encodeSave(GameState.fresh()..onboarded = true);
    await File('${documents.path}/${SaveStore.backupFileName}')
        .writeAsString(saved);
    await File('${documents.path}/${SaveStore.fileName}')
        .writeAsString('{invalid');
    final controller = GameController();
    addTearDown(controller.dispose);

    await controller.ready;

    expect(controller.state.onboarded, isTrue);
    expect(controller.restoreNotice, contains('从备份恢复'));
  });

  test('主存档和备份都损坏时明确告知并启动新档', () async {
    await File('${documents.path}/${SaveStore.fileName}')
        .writeAsString('{invalid');
    await File('${documents.path}/${SaveStore.backupFileName}')
        .writeAsString('[]');
    final controller = GameController();
    addTearDown(controller.dispose);

    await controller.ready;

    expect(controller.state.onboarded, isFalse);
    expect(controller.restoreNotice, contains('已启动新存档'));
  });

  test('心跳刷新期间自动保存防抖仍会落盘', () async {
    final controller = GameController();
    addTearDown(controller.dispose);
    await controller.restoreFromDisk();
    controller.finishOnboarding();

    await Future<void>.delayed(const Duration(milliseconds: 2600));

    expect(
      File('${documents.path}/${SaveStore.fileName}').existsSync(),
      isTrue,
    );
  });
}
