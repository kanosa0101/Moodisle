import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 复制文本到剪贴板；环境剪贴板不可用（如微信小程序抛错）时，
/// 降级为可长按选择的弹窗，保证明信片码/存档导出仍然可用。
Future<void> copyTextWithFallback(
  BuildContext context, {
  required String text,
  required String successMessage,
}) async {
  try {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(successMessage)));
    }
  } catch (_) {
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('请长按复制'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(child: SelectableText(text)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }
}

/// 优先读剪贴板；读不到（空/抛错）时弹出手动粘贴框，输入内容经 [onText] 回传。
Future<void> pasteTextWithFallback(
  BuildContext context, {
  required String title,
  required String hint,
  required void Function(String text) onText,
}) async {
  String? fromClipboard;
  try {
    final data = await Clipboard.getData('text/plain');
    fromClipboard = data?.text;
  } catch (_) {
    // 剪贴板读取在部分环境（小程序）可能抛错，走手动粘贴降级。
  }
  if (fromClipboard != null && fromClipboard.isNotEmpty) {
    onText(fromClipboard);
    return;
  }
  if (!context.mounted) return;
  final controller = TextEditingController();
  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        maxLines: 4,
        autofocus: true,
        decoration: InputDecoration(hintText: hint),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(ctx);
            onText(controller.text);
          },
          child: const Text('确定'),
        ),
      ],
    ),
  );
}
