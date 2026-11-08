import 'package:flutter/material.dart';

import '../models/archery_gear.dart';

class ArcheryGearScreen extends StatefulWidget {
  final List<ArcheryGearOffer> items;
  final String userName;
  final ValueChanged<ArcheryGearOffer> onAdd;

  const ArcheryGearScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<ArcheryGearScreen> createState() => _ArcheryGearScreenState();
}

class _ArcheryGearScreenState extends State<ArcheryGearScreen> {
  late List<ArcheryGearOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<ArcheryGearOffer>(
      context: context,
      builder: (_) => _ArcheryDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Łucznictwo i sprzęt terenowy')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.gps_fixed),
        label: const Text('Oferta'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Giełda tarcz, łuków rekreacyjnych, strzał i sprzętu outdoorowego dla pasjonatów z osiedla.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.gps_fixed),
                title: Text(item.title),
                subtitle: Text('${item.kind.label} · ${item.authorName}'),
              ),
            ),
        ],
      ),
    );
  }
}

class _ArcheryDialog extends StatefulWidget {
  final String userName;

  const _ArcheryDialog({required this.userName});

  @override
  State<_ArcheryDialog> createState() => _ArcheryDialogState();
}

class _ArcheryDialogState extends State<_ArcheryDialog> {
  var _kind = ArcheryKind.target;
  final _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tarcza / łuk / strzały'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<ArcheryKind>(
            initialValue: _kind,
            items: [
              for (final kind in ArcheryKind.values)
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
              ArcheryGearOffer(
                id: 'ag-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
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
