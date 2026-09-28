/// 存档落盘（docs/03 §9）：文档目录 JSON 文件；Web 使用 localStorage。
/// 写失败不抛出，保留内存态并允许手动导入/导出。
library;

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'save_codec.dart';
import 'save_store_web_stub.dart' if (dart.library.html) 'save_store_web.dart'
    as browser_storage;

class SaveStore {
  static const String fileName = 'moodisle_save_v2.json';
  static const String backupFileName = '$fileName.bak';
  final Map<String, File> _cache = {};
  bool _unavailable = false;
  bool recoveredFromBackup = false;
  bool hadCorruptSave = false;

  Future<File?> _file(String name) async {
    if (_unavailable || kIsWeb) return null;
    if (_cache[name] != null) return _cache[name];
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$name');
      _cache[name] = file;
      return file;
    } catch (_) {
      _unavailable = true; // 平台不支持 → 本次会话不再尝试
      return null;
    }
  }

  Future<String?> _readStored(String name) async {
    try {
      if (kIsWeb) return browser_storage.readSave(name);
      final f = await _file(name);
      if (f == null || !f.existsSync()) return null;
      return f.readAsStringSync();
    } catch (_) {
      hadCorruptSave = true;
      return null;
    }
  }

  bool _isValid(String raw) {
    try {
      decodeSaveDocument(raw);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// 读取主存档；损坏时尝试备份。都不可读时由调用方告知并降级为新档。
  Future<String?> load() async {
    recoveredFromBackup = false;
    hadCorruptSave = false;
    final primary = await _readStored(fileName);
    if (primary != null) {
      if (_isValid(primary)) return primary;
      hadCorruptSave = true;
    }

    final backup = await _readStored(backupFileName);
    if (backup != null) {
      if (_isValid(backup)) {
        recoveredFromBackup = true;
        return backup;
      }
      hadCorruptSave = true;
    }
    return null;
  }

  /// 写入前保留上一份有效档；失败静默以保留内存态。
  Future<void> save(String json) async {
    if (!_isValid(json)) return;
    try {
      final previous = await _readStored(fileName);
      if (previous != null && _isValid(previous)) {
        await _writeStored(backupFileName, previous);
      }
      await _writeStored(fileName, json);
    } catch (_) {
      // 静默：下一次写操作重试
    }
  }

  Future<void> _writeStored(String name, String value) async {
    if (kIsWeb) {
      browser_storage.writeSave(name, value);
      return;
    }
    final f = await _file(name);
    if (f != null) f.writeAsStringSync(value);
  }
}
