import 'package:flutter/material.dart';

import '../models/party_gear.dart';

class PartyGearScreen extends StatefulWidget {
  final List<PartyGear> items;
  final ValueChanged<PartyGear> onAdd;
  final ValueChanged<String> onBorrow;

  const PartyGearScreen({
    super.key,
    required this.items,
    required this.onAdd,
    required this.onBorrow,
  });

  @override
  State<PartyGearScreen> createState() => _PartyGearScreenState();
}

class _PartyGearScreenState extends State<PartyGearScreen> {
  late List<PartyGear> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<PartyGear>(
      context: context,
      builder: (_) => const _GearDialog(),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  void _borrow(PartyGear gear) {
    if (gear.borrowed) return;
    setState(() {
      _items = _items
          .map(
            (item) => item.id == gear.id ? item.copyWith(borrowed: true) : item,
          )
          .toList();
    });
    widget.onBorrow(gear.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sprzęt imprezowy')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.speaker_outlined),
        label: const Text('Oddam sprzęt'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Projektory, głośniki Bluetooth, stoły cateringowe i namioty na imprezy sąsiedzkie.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.celebration_outlined),
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

class _GearDialog extends StatefulWidget {
  const _GearDialog();

  @override
  State<_GearDialog> createState() => _GearDialogState();
}

class _GearDialogState extends State<_GearDialog> {
  final _title = TextEditingController();
  var _kind = PartyGearKind.speaker;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sprzęt do wypożyczenia'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<PartyGearKind>(
              initialValue: _kind,
              items: [
                for (final kind in PartyGearKind.values)
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
              PartyGear(
                id: 'pg-${DateTime.now().millisecondsSinceEpoch}',
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
