import 'package:flutter/material.dart';

import '../models/lunchbox.dart';
import '../theme/widzew_ui.dart';

class LunchboxScreen extends StatefulWidget {
  final List<LunchboxRecipe> items;
  final String userName;
  final ValueChanged<LunchboxRecipe> onAdd;

  const LunchboxScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<LunchboxScreen> createState() => _LunchboxScreenState();
}

class _LunchboxScreenState extends State<LunchboxScreen> {
  late List<LunchboxRecipe> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<LunchboxRecipe>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _LunchDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Przekąski do szkoły i pracy')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.lunch_dining_outlined),
        label: const Text('Przepis'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Lunchboksy, batony owsiane i koktajle — szybkie pomysły mieszkańców.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.lunch_dining_outlined),
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

class _LunchDialog extends StatefulWidget {
  final String userName;

  const _LunchDialog({required this.userName});

  @override
  State<_LunchDialog> createState() => _LunchDialogState();
}

class _LunchDialogState extends State<_LunchDialog> {
  var _kind = LunchKind.lunchbox;
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
      title: const Text('Przekąska'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<LunchKind>(
            initialValue: _kind,
            items: [
              for (final kind in LunchKind.values)
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
              LunchboxRecipe(
                id: 'lb-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Zdrowa przekąska'
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
