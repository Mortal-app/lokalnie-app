import 'package:flutter/material.dart';

import '../models/baby_carrier.dart';

class BabyCarrierScreen extends StatefulWidget {
  final List<BabyCarrierOffer> items;
  final String userName;
  final ValueChanged<BabyCarrierOffer> onAdd;

  const BabyCarrierScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<BabyCarrierScreen> createState() => _BabyCarrierScreenState();
}

class _BabyCarrierScreenState extends State<BabyCarrierScreen> {
  late List<BabyCarrierOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<BabyCarrierOffer>(
      context: context,
      builder: (_) => _CarrierDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nosidełka i chusty')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.child_care_outlined),
        label: const Text('Oferta'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Giełda chust tkanych, elastycznych i nosidełek troczonych między młodymi rodzicami — bez wózków.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.child_care),
                title: Text(item.title),
                subtitle: Text('${item.kind.label} · ${item.authorName}'),
              ),
            ),
        ],
      ),
    );
  }
}

class _CarrierDialog extends StatefulWidget {
  final String userName;

  const _CarrierDialog({required this.userName});

  @override
  State<_CarrierDialog> createState() => _CarrierDialogState();
}

class _CarrierDialogState extends State<_CarrierDialog> {
  var _kind = CarrierKind.woven;
  final _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Chusta / nosidełko'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<CarrierKind>(
            initialValue: _kind,
            items: [
              for (final kind in CarrierKind.values)
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
              BabyCarrierOffer(
                id: 'cr-${DateTime.now().millisecondsSinceEpoch}',
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
