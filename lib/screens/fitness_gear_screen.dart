import 'package:flutter/material.dart';

import '../models/fitness_gear.dart';

class FitnessGearScreen extends StatefulWidget {
  final List<FitnessGearItem> items;
  final ValueChanged<FitnessGearItem> onAdd;
  final ValueChanged<String> onBorrow;

  const FitnessGearScreen({
    super.key,
    required this.items,
    required this.onAdd,
    required this.onBorrow,
  });

  @override
  State<FitnessGearScreen> createState() => _FitnessGearScreenState();
}

class _FitnessGearScreenState extends State<FitnessGearScreen> {
  late List<FitnessGearItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<FitnessGearItem>(
      context: context,
      builder: (_) => const _FitDialog(),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  void _borrow(FitnessGearItem item) {
    if (item.borrowed) return;
    setState(() {
      _items = _items
          .map(
            (entry) =>
                entry.id == item.id ? entry.copyWith(borrowed: true) : entry,
          )
          .toList();
    });
    widget.onBorrow(item.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sąsiedzki sprzęt fitness')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.fitness_center_outlined),
        label: const Text('Udostępniam sprzęt'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Hantle, maty, gumy oporowe i rowery stacjonarne — barwny fitness na klatce.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.fitness_center),
                title: Text(item.title),
                subtitle: Text('${item.kind.label} · ${item.owner}'),
                trailing: TextButton(
                  onPressed: item.borrowed ? null : () => _borrow(item),
                  child: Text(item.borrowed ? 'Wypożyczono' : 'Wypożycz'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FitDialog extends StatefulWidget {
  const _FitDialog();

  @override
  State<_FitDialog> createState() => _FitDialogState();
}

class _FitDialogState extends State<_FitDialog> {
  final _title = TextEditingController();
  var _kind = FitnessGearKind.yogaMat;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sprzęt fitness'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<FitnessGearKind>(
              initialValue: _kind,
              items: [
                for (final kind in FitnessGearKind.values)
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
              FitnessGearItem(
                id: 'fg-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                owner: 'Sąsiad',
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
