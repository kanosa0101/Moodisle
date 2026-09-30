import 'dart:io';

/// 删除测试临时目录，带短暂重试。
///
/// Windows 下刚创建/写入的文件可能被杀毒或索引服务短暂占用，
/// 立即 deleteSync 会偶发 errno 32（文件被另一进程使用）。
/// 间隔重试后仍失败才向上抛出。
void deleteTempDirWithRetry(Directory dir,
    {int attempts = 10,
    Duration interval = const Duration(milliseconds: 40)}) {
  for (var attempt = 0;; attempt++) {
    try {
      dir.deleteSync(recursive: true);
      return;
    } on FileSystemException {
      if (attempt >= attempts - 1) rethrow;
    }
    // ignore: avoid_print
    print('temp dir locked, retrying deletion (${attempt + 1}/$attempts)');
    sleep(interval);
  }
}
