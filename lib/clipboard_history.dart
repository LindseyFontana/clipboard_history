import 'clipboard_history_platform_interface.dart';

class ClipboardHistory {
  final List<String> history = [];
  final int historyLimit = 50;

  Future<String?> captureClipboard() {
    return ClipboardHistoryPlatform.instance.captureClipboard();
  }

  Future<List<String>> getHistory() async {
    return ClipboardHistoryPlatform.instance.getHistory();
  }

  Future<bool> clearHistory() async =>
      await ClipboardHistoryPlatform.instance.clearHistory();

  Future<List<String>> deleteItem(String item) async =>
      await ClipboardHistoryPlatform.instance.deleteItem(item);
}
