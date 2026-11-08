import 'package:flutter/material.dart';

import '../models/fruit_preserve.dart';

class FruitPreserveScreen extends StatefulWidget {
  final List<FruitPreserveRecipe> items;
  final String userName;
  final ValueChanged<FruitPreserveRecipe> onAdd;

  const FruitPreserveScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<FruitPreserveScreen> createState() => _FruitPreserveScreenState();
}

class _FruitPreserveScreenState extends State<FruitPreserveScreen> {
  late List<FruitPreserveRecipe> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<FruitPreserveRecipe>(
      context: context,
      builder: (_) => _FruitDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Przetwory owocowe z ROD')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.kitchen_outlined),
        label: const Text('Przepis'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Konfitury, powidła śliwkowe i kompoty z owoców z działek — osobno od wymiany słoików.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.kitchen_outlined),
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

class _FruitDialog extends StatefulWidget {
  final String userName;

  const _FruitDialog({required this.userName});

  @override
  State<_FruitDialog> createState() => _FruitDialogState();
}

class _FruitDialogState extends State<_FruitDialog> {
  var _kind = FruitPreserveKind.powidla;
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
      title: const Text('Przetwór z ROD'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<FruitPreserveKind>(
            initialValue: _kind,
            items: [
              for (final kind in FruitPreserveKind.values)
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
            decoration: const InputDecoration(labelText: 'Przepis'),
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
              FruitPreserveRecipe(
                id: 'fp-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Przetwór owocowy'
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
