import 'package:flutter/material.dart';

import '../models/retro_it_offer.dart';
import '../theme/widzew_ui.dart';

class RetroItScreen extends StatefulWidget {
  final List<RetroItOffer> items;
  final String userName;
  final ValueChanged<RetroItOffer> onAdd;

  const RetroItScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<RetroItScreen> createState() => _RetroItScreenState();
}

class _RetroItScreenState extends State<RetroItScreen> {
  late List<RetroItOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<RetroItOffer>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _ItDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Retro-IT i warsztat komputerowy')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.memory_outlined),
        label: const Text('Dodaj ogłoszenie'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Podzespoły, czyszczenie układów chłodzenia i serwis laptopów/PC w sąsiedztwie.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.computer_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.place}\n${item.description}\n${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _ItDialog extends StatefulWidget {
  final String userName;

  const _ItDialog({required this.userName});

  @override
  State<_ItDialog> createState() => _ItDialogState();
}

class _ItDialogState extends State<_ItDialog> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  var _kind = RetroItKind.parts;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Warsztat komputerowy'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<RetroItKind>(
              initialValue: _kind,
              items: [
                for (final kind in RetroItKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Tytuł'),
            ),
            TextField(
              controller: _description,
              decoration: const InputDecoration(labelText: 'Opis'),
              maxLines: 3,
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
              RetroItOffer(
                id: 'it-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                description: _description.text.trim(),
                kind: _kind,
                authorName: widget.userName,
                place: 'Widzew',
              ),
            );
          },
          child: const Text('Zapisz'),
        ),
      ],
    );
  }
}
