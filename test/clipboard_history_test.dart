import 'package:flutter_test/flutter_test.dart';
import 'package:clipboard_history/clipboard_history.dart';
import 'package:clipboard_history/clipboard_history_platform_interface.dart';
import 'package:clipboard_history/clipboard_history_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockClipboardHistoryPlatform
    with MockPlatformInterfaceMixin
    implements ClipboardHistoryPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ClipboardHistoryPlatform initialPlatform =
      ClipboardHistoryPlatform.instance;

  test('$MethodChannelClipboardHistory is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelClipboardHistory>());
  });
}
