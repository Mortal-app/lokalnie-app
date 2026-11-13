import 'package:flutter/material.dart';

import '../models/aquarium_swap.dart';
import '../theme/widzew_ui.dart';

class AquariumSwapScreen extends StatefulWidget {
  final List<AquariumSwapOffer> items;
  final String userName;
  final ValueChanged<AquariumSwapOffer> onAdd;

  const AquariumSwapScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<AquariumSwapScreen> createState() => _AquariumSwapScreenState();
}

class _AquariumSwapScreenState extends State<AquariumSwapScreen> {
  late List<AquariumSwapOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<AquariumSwapOffer>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _AquaDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Akwaria i terraria')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.water_outlined),
        label: const Text('Wymiana'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Roślinki, krewetki, nadwyżki filtrów i terraria — forum akwarystów z osiedla.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.water_outlined),
                title: Text(item.title),
                subtitle: Text('${item.kind.label} · ${item.authorName}'),
              ),
            ),
        ],
      ),
    );
  }
}

class _AquaDialog extends StatefulWidget {
  final String userName;

  const _AquaDialog({required this.userName});

  @override
  State<_AquaDialog> createState() => _AquaDialogState();
}

class _AquaDialogState extends State<_AquaDialog> {
  var _kind = AquaKind.plant;
  final _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Akwarystyka'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<AquaKind>(
            initialValue: _kind,
            items: [
              for (final kind in AquaKind.values)
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
              AquariumSwapOffer(
                id: 'aq-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Nadwyżka z akwarium'
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
