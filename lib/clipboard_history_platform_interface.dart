import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'clipboard_history_method_channel.dart';

abstract class ClipboardHistoryPlatform extends PlatformInterface {
  /// Constructs a ClipboardHistoryPlatform.
  ClipboardHistoryPlatform() : super(token: _token);

  static final Object _token = Object();

  static ClipboardHistoryPlatform _instance = MethodChannelClipboardHistory();

  /// The default instance of [ClipboardHistoryPlatform] to use.
  ///
  /// Defaults to [MethodChannelClipboardHistory].
  static ClipboardHistoryPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ClipboardHistoryPlatform] when
  /// they register themselves.
  static set instance(ClipboardHistoryPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
