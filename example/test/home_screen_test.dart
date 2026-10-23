import 'package:clipboard_history/clipboard_history_platform_interface.dart';
import 'package:clipboard_history_example/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockClipboardHistoryPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements ClipboardHistoryPlatform {}

void main() {
  late MockClipboardHistoryPlatform platform;

  setUp(() {
    platform = MockClipboardHistoryPlatform();
    ClipboardHistoryPlatform.instance = platform;

    when(() => platform.getHistory()).thenAnswer((_) async => ['item1']);
    when(() => platform.captureClipboard()).thenAnswer((_) async => ['item1']);
    when(() => platform.clearHistory()).thenAnswer((_) async => true);
    when(() => platform.addToClipboard(any())).thenAnswer((_) async => true);
    when(() => platform.deleteItem(any())).thenAnswer((_) async => <String>[]);
  });

  Future<void> pumpHome(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();
  }

  testWidgets('loads the history when the screen starts', (tester) async {
    await pumpHome(tester);

    verify(() => platform.getHistory()).called(1);
  });

  testWidgets('paste button calls captureClipboard', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.byKey(const Key('add-button')));
    await tester.pumpAndSettle();

    verify(() => platform.captureClipboard()).called(1);
  });

  testWidgets('delete button calls clearHistory', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.byKey(const Key('clear-button')));
    await tester.pumpAndSettle();

    verify(() => platform.clearHistory()).called(1);
  });

  testWidgets('copy icon calls addToClipboard with the item', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.byKey(const Key('copy-item0')));
    await tester.pumpAndSettle();

    verify(() => platform.addToClipboard('item1')).called(1);
  });

  testWidgets('delete icon calls deleteItem with the item', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.byKey(const Key('delete-item0')));
    await tester.pumpAndSettle();

    verify(() => platform.deleteItem('item1')).called(1);
  });
}
