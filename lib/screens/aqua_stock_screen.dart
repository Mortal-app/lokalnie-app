import 'package:flutter/material.dart';

import '../models/aqua_stock.dart';
import '../theme/widzew_ui.dart';

class AquaStockScreen extends StatefulWidget {
  final List<AquaStockOffer> items;
  final String userName;
  final ValueChanged<AquaStockOffer> onAdd;

  const AquaStockScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<AquaStockScreen> createState() => _AquaStockScreenState();
}

class _AquaStockScreenState extends State<AquaStockScreen> {
  late List<AquaStockOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<AquaStockOffer>(
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
      appBar: AppBar(title: const Text('Ryby, krewetki i narybek')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.water),
        label: const Text('Wpis'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Katalog akwarystów z osiedla: narybek, rośliny szybko rosnące i podłoże aktywne — osobno od wymiany sprzętu.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.water),
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
  var _kind = AquaStockKind.fry;
  final _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Narybek / rośliny / podłoże'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<AquaStockKind>(
            initialValue: _kind,
            items: [
              for (final kind in AquaStockKind.values)
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
              AquaStockOffer(
                id: 'as-${DateTime.now().millisecondsSinceEpoch}',
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
