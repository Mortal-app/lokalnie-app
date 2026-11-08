import 'package:flutter/material.dart';

import '../models/bike_child.dart';

class BikeChildScreen extends StatefulWidget {
  final List<BikeChildOffer> items;
  final String userName;
  final ValueChanged<BikeChildOffer> onAdd;

  const BikeChildScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<BikeChildScreen> createState() => _BikeChildScreenState();
}

class _BikeChildScreenState extends State<BikeChildScreen> {
  late List<BikeChildOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<BikeChildOffer>(
      context: context,
      builder: (_) => _ChildBikeDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Foteliki i przyczepki rowerowe')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.pedal_bike_outlined),
        label: const Text('Oddaję'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Foteliki montowane na rowerze i przyczepki dla najmłodszych.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.pedal_bike_outlined),
                title: Text(item.title),
                subtitle: Text('${item.kind.label} · ${item.authorName}'),
              ),
            ),
        ],
      ),
    );
  }
}

class _ChildBikeDialog extends StatefulWidget {
  final String userName;

  const _ChildBikeDialog({required this.userName});

  @override
  State<_ChildBikeDialog> createState() => _ChildBikeDialogState();
}

class _ChildBikeDialogState extends State<_ChildBikeDialog> {
  var _kind = BikeChildKind.seat;
  final _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Fotelik / przyczepka'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<BikeChildKind>(
            initialValue: _kind,
            items: [
              for (final kind in BikeChildKind.values)
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
              BikeChildOffer(
                id: 'bkc-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Fotelik rowerowy'
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
