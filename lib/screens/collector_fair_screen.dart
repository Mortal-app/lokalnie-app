import 'package:flutter/material.dart';

import '../models/collector_fair.dart';

class CollectorFairScreen extends StatefulWidget {
  final List<CollectorItem> items;
  final String userName;
  final ValueChanged<CollectorItem> onAdd;

  const CollectorFairScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<CollectorFairScreen> createState() => _CollectorFairScreenState();
}

class _CollectorFairScreenState extends State<CollectorFairScreen> {
  late List<CollectorItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<CollectorItem>(
      context: context,
      builder: (_) => _ColDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Klub kolekcjonera')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.collections_outlined),
        label: const Text('Eksponat'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Monety, banknoty, znaczki i militaria z regionu łódzkiego.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.savings_outlined),
                title: Text(item.title),
                subtitle: Text('${item.kind.label} · ${item.authorName}'),
              ),
            ),
        ],
      ),
    );
  }
}

class _ColDialog extends StatefulWidget {
  final String userName;

  const _ColDialog({required this.userName});

  @override
  State<_ColDialog> createState() => _ColDialogState();
}

class _ColDialogState extends State<_ColDialog> {
  final _title = TextEditingController();
  var _kind = CollectorKind.coin;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Giełda numizmatyczna'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<CollectorKind>(
              initialValue: _kind,
              items: [
                for (final kind in CollectorKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Opis'),
            ),
          ],
        ),
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
              CollectorItem(
                id: 'cf-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
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
