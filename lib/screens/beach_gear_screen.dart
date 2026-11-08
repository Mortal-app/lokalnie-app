import 'package:flutter/material.dart';

import '../models/beach_gear.dart';

class BeachGearScreen extends StatefulWidget {
  final List<BeachGearOffer> items;
  final String userName;
  final ValueChanged<BeachGearOffer> onAdd;

  const BeachGearScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<BeachGearScreen> createState() => _BeachGearScreenState();
}

class _BeachGearScreenState extends State<BeachGearScreen> {
  late List<BeachGearOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<BeachGearOffer>(
      context: context,
      builder: (_) => _BeachDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sprzęt plażowy')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.beach_access_outlined),
        label: const Text('Oddaję'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Materace, parawany, piłki i akcesoria na letnie wyjazdy nad wodę.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.beach_access_outlined),
                title: Text(item.title),
                subtitle: Text('${item.kind.label} · ${item.authorName}'),
              ),
            ),
        ],
      ),
    );
  }
}

class _BeachDialog extends StatefulWidget {
  final String userName;

  const _BeachDialog({required this.userName});

  @override
  State<_BeachDialog> createState() => _BeachDialogState();
}

class _BeachDialogState extends State<_BeachDialog> {
  var _kind = BeachKind.mattress;
  final _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Plaża'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<BeachKind>(
            initialValue: _kind,
            items: [
              for (final kind in BeachKind.values)
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
              BeachGearOffer(
                id: 'bg-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Sprzęt plażowy'
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
