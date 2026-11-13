import 'package:flutter/material.dart';

import '../models/roller_shutter.dart';
import '../theme/widzew_ui.dart';

class RollerShutterScreen extends StatefulWidget {
  final List<RollerShutterTip> items;
  final String userName;
  final ValueChanged<RollerShutterTip> onAdd;

  const RollerShutterScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<RollerShutterScreen> createState() => _RollerShutterScreenState();
}

class _RollerShutterScreenState extends State<RollerShutterScreen> {
  late List<RollerShutterTip> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<RollerShutterTip>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _ShutDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rolety zewnętrzne')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.blinds_outlined),
        label: const Text('Porada / pomoc'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Regulacja pancerzy i wymiana zerwanych taśm zwijaczy — osobno od okuć PCV.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.blinds_outlined),
                title: Text(item.title),
                subtitle: Text('${item.body} · ${item.authorName}'),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _ShutDialog extends StatefulWidget {
  final String userName;

  const _ShutDialog({required this.userName});

  @override
  State<_ShutDialog> createState() => _ShutDialogState();
}

class _ShutDialogState extends State<_ShutDialog> {
  final _title = TextEditingController();
  final _body = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Roleta'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Tytuł'),
          ),
          TextField(
            controller: _body,
            decoration: const InputDecoration(labelText: 'Porada'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Anuluj'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(
              context,
              RollerShutterTip(
                id: 'rs-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? 'Naprawa rolety'
                    : _title.text.trim(),
                body: _body.text.trim(),
                authorName: widget.userName,
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
