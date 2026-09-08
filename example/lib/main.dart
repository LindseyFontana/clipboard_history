import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:clipboard_history/clipboard_history.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _plugin = ClipboardHistory();
  String? _lastCaptured;

  @override
  void initState() {
    super.initState();
    _captureClipboard();
  }

  Future<void> _captureClipboard() async {
    final captured = await _plugin.captureClipboard();
    if (captured != null) {
      setState(() => _lastCaptured = captured);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(child: Text('Texto copiado: $_lastCaptured')),
      ),
    );
  }
}
