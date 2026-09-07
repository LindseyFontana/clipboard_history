
import 'clipboard_history_platform_interface.dart';

class ClipboardHistory {
  Future<String?> getPlatformVersion() {
    return ClipboardHistoryPlatform.instance.getPlatformVersion();
  }
}
