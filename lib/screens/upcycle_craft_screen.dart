import 'package:flutter/material.dart';

import '../models/upcycle_craft.dart';

class UpcycleCraftScreen extends StatefulWidget {
  final List<UpcycleOffer> items;
  final String userName;
  final ValueChanged<UpcycleOffer> onAdd;

  const UpcycleCraftScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<UpcycleCraftScreen> createState() => _UpcycleCraftScreenState();
}

class _UpcycleCraftScreenState extends State<UpcycleCraftScreen> {
  late List<UpcycleOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<UpcycleOffer>(
      context: context,
      builder: (_) => _UpcycleDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Krawiectwo i upcycling')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.content_cut),
        label: const Text('Ogłoszenie'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Przeróbki starych ubrań, torby z bannerów i dekoracje z odzysku.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.content_cut),
                title: Text(item.title),
                subtitle: Text('${item.kind.label} · ${item.authorName}'),
              ),
            ),
        ],
      ),
    );
  }
}

class _UpcycleDialog extends StatefulWidget {
  final String userName;

  const _UpcycleDialog({required this.userName});

  @override
  State<_UpcycleDialog> createState() => _UpcycleDialogState();
}

class _UpcycleDialogState extends State<_UpcycleDialog> {
  var _kind = UpcycleKind.bannerBag;
  final _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Upcycling'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<UpcycleKind>(
            initialValue: _kind,
            items: [
              for (final kind in UpcycleKind.values)
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
              UpcycleOffer(
                id: 'uc-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Przeróbka z odzysku'
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
