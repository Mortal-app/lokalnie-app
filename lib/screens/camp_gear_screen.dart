import 'package:flutter/material.dart';

import '../models/camp_gear.dart';

class CampGearScreen extends StatefulWidget {
  final List<CampGearItem> items;
  final ValueChanged<CampGearItem> onAdd;
  final ValueChanged<String> onBorrow;

  const CampGearScreen({
    super.key,
    required this.items,
    required this.onAdd,
    required this.onBorrow,
  });

  @override
  State<CampGearScreen> createState() => _CampGearScreenState();
}

class _CampGearScreenState extends State<CampGearScreen> {
  late List<CampGearItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<CampGearItem>(
      context: context,
      builder: (_) => const _CampDialog(),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  void _borrow(CampGearItem item) {
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
      appBar: AppBar(title: const Text('Sprzęt turystyczny')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.luggage_outlined),
        label: const Text('Udostępniam sprzęt'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Namioty, śpiwory, plecaki i lodówki turystyczne na wakacyjne wyjazdy.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.terrain_outlined),
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

class _CampDialog extends StatefulWidget {
  const _CampDialog();

  @override
  State<_CampDialog> createState() => _CampDialogState();
}

class _CampDialogState extends State<_CampDialog> {
  final _title = TextEditingController();
  var _kind = CampGearKind.tent;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sprzęt kempingowy'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<CampGearKind>(
              initialValue: _kind,
              items: [
                for (final kind in CampGearKind.values)
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
              CampGearItem(
                id: 'cg-${DateTime.now().millisecondsSinceEpoch}',
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
