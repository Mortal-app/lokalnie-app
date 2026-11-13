import 'package:flutter/material.dart';

import '../models/fruit_vinegar.dart';
import '../theme/widzew_ui.dart';

class FruitVinegarScreen extends StatefulWidget {
  final List<FruitVinegarRecipe> items;
  final String userName;
  final ValueChanged<FruitVinegarRecipe> onAdd;

  const FruitVinegarScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<FruitVinegarScreen> createState() => _FruitVinegarScreenState();
}

class _FruitVinegarScreenState extends State<FruitVinegarScreen> {
  late List<FruitVinegarRecipe> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<FruitVinegarRecipe>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _VinegarDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Octy owocowe i zakwasy')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.science_outlined),
        label: const Text('Przepis'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Fermentacja domowa, ocet z obierek jabłek i naturalne probiotyki — osobno od chleba i powideł.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.opacity),
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

class _VinegarDialog extends StatefulWidget {
  final String userName;

  const _VinegarDialog({required this.userName});

  @override
  State<_VinegarDialog> createState() => _VinegarDialogState();
}

class _VinegarDialogState extends State<_VinegarDialog> {
  var _kind = VinegarKind.appleCider;
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
      title: const Text('Przepis fermentacyjny'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<VinegarKind>(
            initialValue: _kind,
            items: [
              for (final kind in VinegarKind.values)
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
              FruitVinegarRecipe(
                id: 'fv-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Ocet owocowy'
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
