import 'package:flutter/material.dart';

import '../models/puzzle_swap.dart';

class PuzzleSwapScreen extends StatefulWidget {
  final List<PuzzleSwapOffer> items;
  final String userName;
  final ValueChanged<PuzzleSwapOffer> onAdd;

  const PuzzleSwapScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<PuzzleSwapScreen> createState() => _PuzzleSwapScreenState();
}

class _PuzzleSwapScreenState extends State<PuzzleSwapScreen> {
  late List<PuzzleSwapOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<PuzzleSwapOffer>(
      context: context,
      builder: (_) => _PuzzleDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Puzzle i układanki')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.extension_outlined),
        label: const Text('Oddaję'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Puzzle 500–3000 elementów i gry logiczne przekazywane po ułożeniu.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.extension_outlined),
                title: Text(item.title),
                subtitle: Text('${item.kind.label} · ${item.authorName}'),
              ),
            ),
        ],
      ),
    );
  }
}

class _PuzzleDialog extends StatefulWidget {
  final String userName;

  const _PuzzleDialog({required this.userName});

  @override
  State<_PuzzleDialog> createState() => _PuzzleDialogState();
}

class _PuzzleDialogState extends State<_PuzzleDialog> {
  var _kind = PuzzleKind.pieces1000;
  final _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Puzzle'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<PuzzleKind>(
            initialValue: _kind,
            items: [
              for (final kind in PuzzleKind.values)
                DropdownMenuItem(value: kind, child: Text(kind.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _kind = value);
            },
          ),
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Tytuł zestawu'),
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
              PuzzleSwapOffer(
                id: 'pz-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Puzzle po ułożeniu'
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
