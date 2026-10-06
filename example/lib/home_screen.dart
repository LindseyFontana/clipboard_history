import 'package:clipboard_history/clipboard_history.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Copia & cola',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _history != null && _history!.isNotEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_clipboardHistory(), _clearButton()],
                )
              : _emptyBody(),
        ),
      ),
    );
  }

  Widget _clipboardHistory() => Flexible(
    child: ListView.builder(
      physics: ClampingScrollPhysics(),
      itemCount: _history?.length,
      itemBuilder: ((context, index) => _clipboardItem(_history![index])),
    ),
  );

  Widget _clipboardItem(String item) {
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
                padding: EdgeInsets.zero,
                onPressed: () async {
                  final data = await _plugin.addToClipboard(item);
                  setState(() => _history = data);
                },
                icon: Icon(Icons.content_copy),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  final data = await _plugin.deleteItem(item);
                  setState(() => _history = data);
                },
                icon: Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyBody() =>
      Center(child: Text('Histórico vazio', style: TextStyle(fontSize: 20)));

  Widget _clearButton() => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () async {
        if (await _plugin.clearHistory()) {
          setState(() => _history = []);
        }
      },
      child: Text("Apagar", style: Theme.of(context).textTheme.titleLarge),
    ),
  );
}
