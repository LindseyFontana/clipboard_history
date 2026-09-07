import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'clipboard_history_platform_interface.dart';

/// An implementation of [ClipboardHistoryPlatform] that uses method channels.
class MethodChannelClipboardHistory extends ClipboardHistoryPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('clipboard_history');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
