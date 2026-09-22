import 'package:flutter/material.dart';
import 'dart:async';

import 'package:clipboard_history/clipboard_history.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _plugin = ClipboardHistory();
  List<String>? _history;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _captureClipboard();
    _getHistory();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _captureClipboard();
      _getHistory();
    }
  }

  Future<void> _getHistory() async {
    final history = await _plugin.getHistory();

    setState(() {
      _history = history;
    });
  }

  Future<void> _captureClipboard() async {
    await _plugin.captureClipboard();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text(
            'Clipboard History',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(child: Column(children: [...historyItens])),
      ),
    );
  }

  List<Widget> get historyItens {
    if (_history != null && _history!.isNotEmpty) {
      return _history!
          .map(
            (item) =>
                Row(children: [Text(item, style: TextStyle(fontSize: 18))]),
          )
          .toList();
    }
    return [Text('Histórico vazio')];
  }
}
