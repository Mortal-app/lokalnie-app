import 'package:flutter/material.dart';

import '../models/pet_bird.dart';

class PetBirdScreen extends StatefulWidget {
  final List<PetBirdOffer> items;
  final String userName;
  final ValueChanged<PetBirdOffer> onAdd;

  const PetBirdScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<PetBirdScreen> createState() => _PetBirdScreenState();
}

class _PetBirdScreenState extends State<PetBirdScreen> {
  late List<PetBirdOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<PetBirdOffer>(
      context: context,
      builder: (_) => _BirdDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ptaki ozdobne i papugi')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.flutter_dash),
        label: const Text('Wpis'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Karma, akcesoria i porady behawioralne dla hodowców ptaków domowych z osiedla.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.flutter_dash),
                title: Text(item.title),
                subtitle: Text('${item.kind.label} · ${item.authorName}'),
              ),
            ),
        ],
      ),
    );
  }
}

class _BirdDialog extends StatefulWidget {
  final String userName;

  const _BirdDialog({required this.userName});

  @override
  State<_BirdDialog> createState() => _BirdDialogState();
}

class _BirdDialogState extends State<_BirdDialog> {
  var _kind = BirdKind.food;
  final _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ptaki'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<BirdKind>(
            initialValue: _kind,
            items: [
              for (final kind in BirdKind.values)
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
              PetBirdOffer(
                id: 'pb-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Wpis hodowlany'
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
