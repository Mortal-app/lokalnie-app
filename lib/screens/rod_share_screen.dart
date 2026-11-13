import 'package:flutter/material.dart';

import '../models/rod_share.dart';
import '../theme/widzew_ui.dart';

class RodShareScreen extends StatefulWidget {
  final List<RodShare> items;
  final String userName;
  final ValueChanged<RodShare> onAdd;

  const RodShareScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<RodShareScreen> createState() => _RodShareScreenState();
}

class _RodShareScreenState extends State<RodShareScreen> {
  late List<RodShare> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<RodShare>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _RodDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ROD i ogródki działkowe')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.yard_outlined),
        label: const Text('Dodaj ogłoszenie'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Narzędzia ogrodowe, nadwyżki plonów i kostka brukowa — ROD im. Władysława Reymonta i okolice Widzewa.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.grass_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.garden}\n${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _RodDialog extends StatefulWidget {
  final String userName;

  const _RodDialog({required this.userName});

  @override
  State<_RodDialog> createState() => _RodDialogState();
}

class _RodDialogState extends State<_RodDialog> {
  final _title = TextEditingController();
  var _kind = RodShareKind.harvest;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Działka / ROD'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<RodShareKind>(
              initialValue: _kind,
              items: [
                for (final kind in RodShareKind.values)
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
              RodShare(
                id: 'rod-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                garden: 'ROD im. Władysława Reymonta',
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
