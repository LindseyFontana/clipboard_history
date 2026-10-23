import 'package:clipboard_history/clipboard_history.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final _plugin = ClipboardHistory();
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getHistory();
  }

  Future<void> _getHistory() async {
    final history = await _plugin.getHistory();

    updateHistory(history);
  }

  void updateHistory(List<String> history) {
    setState(() => _history = history.reversed.toList());
  }

  Future<List<String>> _captureClipboard() async {
    return await _plugin.captureClipboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Copia & Cola',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _history.isNotEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_clipboardHistory(), actionButtons()],
                )
              : _emptyBody(),
        ),
      ),
    );
  }

  Widget _clipboardHistory() => Flexible(
    child: ListView.separated(
      physics: ClampingScrollPhysics(),
      itemCount: _history.length,
      itemBuilder: ((context, index) => _clipboardItem(_history[index], index)),
      separatorBuilder: (context, index) => Divider(),
    ),
  );

  Widget _clipboardItem(String item, int index) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(item, style: Theme.of(context).textTheme.bodyLarge),
          ),
          Row(
            children: [
              IconButton(
                key: Key('copy-item$index'),
                padding: EdgeInsets.zero,
                onPressed: () async {
                  await _plugin.addToClipboard(item);
                },
                icon: Icon(Icons.content_copy),
              ),
              IconButton(
                key: Key('delete-item$index'),
                padding: EdgeInsets.zero,
                onPressed: () async {
                  final data = await _plugin.deleteItem(item);
                  updateHistory(data);
                },
                icon: Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyBody() => Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,

    children: [
      Expanded(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded, size: 80),
              SizedBox(height: 12),
              Text('Histórico vazio', style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
      _getButton(),
    ],
  );

  Widget actionButtons() => Column(children: [_getButton(), _clearButton()]);

  Widget _getButton() => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      key: const Key('add-button'),
      onPressed: () async {
        final data = await _captureClipboard();
        updateHistory(data);
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
      child: Text("colar", style: Theme.of(context).textTheme.titleLarge),
    ),
  );

  Widget _clearButton() => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      key: const Key('clear-button'),
      onPressed: () async {
        if (await _plugin.clearHistory()) {
          setState(() => _history = []);
        }
      },
      child: Text("apagar", style: Theme.of(context).textTheme.titleLarge),
    ),
  );
}
