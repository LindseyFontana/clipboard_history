import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'clipboard_history_platform_interface.dart';

class MethodChannelClipboardHistory extends ClipboardHistoryPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('clipboard_history');

  @override
  Future<String?> captureClipboard() async {
    final data = await methodChannel.invokeMethod<String>('captureClipboard');
    return data;
  }

  @override
  Future<List<String>> getHistory() async {
    final data = await methodChannel.invokeMethod<List<Object?>>('getHistory');
    return data?.cast<String>() ?? [];
  }

  @override
  Future<bool> clearHistory() async {
    try {
      return await methodChannel.invokeMethod<bool>('clearHistory') ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<String>> deleteItem(String item) async {
    try {
      final data = await methodChannel.invokeMethod<List<Object?>>(
        'deleteItem',
        item,
      );
      return data?.cast<String>() ?? [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<String>> addToClipboard(String item) async {
    try {
      final data = await methodChannel.invokeMethod<List<Object?>>(
        'addToClipboard',
        item,
      );
      return data?.cast<String>() ?? [];
    } catch (e) {
      return [];
    }
  }
}
