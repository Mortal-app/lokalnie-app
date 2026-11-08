import 'package:flutter/material.dart';

import '../models/lock_care.dart';

class LockCareScreen extends StatefulWidget {
  final List<LockCareTip> items;
  final String userName;
  final ValueChanged<LockCareTip> onAdd;

  const LockCareScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<LockCareScreen> createState() => _LockCareScreenState();
}

class _LockCareScreenState extends State<LockCareScreen> {
  late List<LockCareTip> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<LockCareTip>(
      context: context,
      builder: (_) => _LockDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zamki i wkładki')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.lock_outline),
        label: const Text('Porada / pomoc'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Wymiana wkładek w drzwiach wejściowych i smarowanie zawiasów (WD-40 na zawiasy, nie do zamka).',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.lock_outline),
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

class _LockDialog extends StatefulWidget {
  final String userName;

  const _LockDialog({required this.userName});

  @override
  State<_LockDialog> createState() => _LockDialogState();
}

class _LockDialogState extends State<_LockDialog> {
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
      title: const Text('Zamek / zawiasy'),
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
              LockCareTip(
                id: 'lc-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? 'Pomoc przy wkładce'
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
