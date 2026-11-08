import 'package:flutter/material.dart';

import '../models/school_gear.dart';

class SchoolGearScreen extends StatefulWidget {
  final List<SchoolGearOffer> items;
  final String userName;
  final ValueChanged<SchoolGearOffer> onAdd;

  const SchoolGearScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<SchoolGearScreen> createState() => _SchoolGearScreenState();
}

class _SchoolGearScreenState extends State<SchoolGearScreen> {
  late List<SchoolGearOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<SchoolGearOffer>(
      context: context,
      builder: (_) => _GearDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sprzęt szkolny i plecaki')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.school_outlined),
        label: const Text('Oddaję'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Piórniki, tornistry, plastyczne i zestawy geometryczne przed nowym rokiem szkolnym.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.school_outlined),
                title: Text(item.title),
                subtitle: Text('${item.kind.label} · ${item.authorName}'),
              ),
            ),
        ],
      ),
    );
  }
}

class _GearDialog extends StatefulWidget {
  final String userName;

  const _GearDialog({required this.userName});

  @override
  State<_GearDialog> createState() => _GearDialogState();
}

class _GearDialogState extends State<_GearDialog> {
  var _kind = SchoolGearKind.backpack;
  final _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sprzęt szkolny'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<SchoolGearKind>(
            initialValue: _kind,
            items: [
              for (final kind in SchoolGearKind.values)
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
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Anuluj'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(
              context,
              SchoolGearOffer(
                id: 'sg-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Sprzęt szkolny'
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
