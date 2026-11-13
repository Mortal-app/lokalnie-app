import 'package:flutter/material.dart';

import '../models/home_safe.dart';
import '../theme/widzew_ui.dart';

class HomeSafeScreen extends StatefulWidget {
  final List<HomeSafeTip> items;
  final String userName;
  final ValueChanged<HomeSafeTip> onAdd;

  const HomeSafeScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<HomeSafeScreen> createState() => _HomeSafeScreenState();
}

class _HomeSafeScreenState extends State<HomeSafeScreen> {
  late List<HomeSafeTip> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<HomeSafeTip>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _SafeDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sejfy i skrytki')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.lock_outline),
        label: const Text('Porada / pomoc'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Montaż małych sejfów ściennych i podłogowych w wielkiej płycie — ostrożnie ze zbrojeniem.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.lock_outline),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label}\n${item.body} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _SafeDialog extends StatefulWidget {
  final String userName;

  const _SafeDialog({required this.userName});

  @override
  State<_SafeDialog> createState() => _SafeDialogState();
}

class _SafeDialogState extends State<_SafeDialog> {
  var _kind = SafeKind.wall;
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
      title: const Text('Sejf'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<SafeKind>(
            initialValue: _kind,
            items: [
              for (final kind in SafeKind.values)
                DropdownMenuItem(value: kind, child: Text(kind.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _kind = value);
            },
          ),
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
              HomeSafeTip(
                id: 'hs-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Montaż sejfu'
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
