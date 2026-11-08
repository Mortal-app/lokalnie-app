import 'package:flutter/material.dart';

import '../models/youth_code.dart';

class YouthCodeScreen extends StatefulWidget {
  final List<YouthCodeWorkshop> items;
  final String userName;
  final ValueChanged<YouthCodeWorkshop> onAdd;

  const YouthCodeScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<YouthCodeScreen> createState() => _YouthCodeScreenState();
}

class _YouthCodeScreenState extends State<YouthCodeScreen> {
  late List<YouthCodeWorkshop> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<YouthCodeWorkshop>(
      context: context,
      builder: (_) => _CodeDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Klub młodego programisty')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.smart_toy_outlined),
        label: const Text('Warsztat'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Kodowanie, roboty i druk 3D dla dzieci i młodzieży na Widzewie.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.code),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.place}\n${item.whenLabel} · ${item.host}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _CodeDialog extends StatefulWidget {
  final String userName;

  const _CodeDialog({required this.userName});

  @override
  State<_CodeDialog> createState() => _CodeDialogState();
}

class _CodeDialogState extends State<_CodeDialog> {
  final _title = TextEditingController();
  var _kind = YouthCodeKind.coding;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Warsztat'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<YouthCodeKind>(
              initialValue: _kind,
              items: [
                for (final kind in YouthCodeKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Temat'),
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
              YouthCodeWorkshop(
                id: 'yc-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                place: 'Widzew — świetlica',
                whenLabel: 'Sobota 11:00',
                host: widget.userName,
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
