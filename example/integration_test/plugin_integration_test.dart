import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:clipboard_history/clipboard_history.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final ClipboardHistory plugin = ClipboardHistory();

  setUp(() async {
    await plugin.clearHistory();
  });

  testWidgets('addToClipboard returns true', (WidgetTester tester) async {
    final added = await plugin.addToClipboard('item1');

    expect(added, true);
  });

  testWidgets('captureClipboard adds the clipboard content to the history', (
    WidgetTester tester,
  ) async {
    await plugin.addToClipboard('item1');

    final history = await plugin.captureClipboard();

    expect(history, isA<List<String>>());
    expect(history, contains('item1'));
  });

  testWidgets('getHistory returns a list', (WidgetTester tester) async {
    final history = await plugin.getHistory();

    expect(history, isA<List<String>>());
  });

  testWidgets('deleteItem removes the item from the history', (
    WidgetTester tester,
  ) async {
    await plugin.addToClipboard('item1');
    await plugin.captureClipboard();

    final history = await plugin.deleteItem('item1');

    expect(history, isA<List<String>>());
    expect(history, isNot(contains('item1')));
  });

  testWidgets('clearHistory returns true', (WidgetTester tester) async {
    final cleared = await plugin.clearHistory();

    expect(cleared, true);
  });
}
