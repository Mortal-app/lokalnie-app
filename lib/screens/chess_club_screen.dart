import 'package:flutter/material.dart';

import '../models/chess_club.dart';

class ChessClubScreen extends StatefulWidget {
  final List<ChessChallenge> items;
  final String userName;
  final ValueChanged<ChessChallenge> onAdd;

  const ChessClubScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<ChessClubScreen> createState() => _ChessClubScreenState();
}

class _ChessClubScreenState extends State<ChessClubScreen> {
  late List<ChessChallenge> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<ChessChallenge>(
      context: context,
      builder: (_) => _ChessDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Klub szachowy i logiczny')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.grid_on_outlined),
        label: const Text('Wyzwanie'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Wyzwania szachowe i weekendowe sparingi przy stolikach w parku lub świetlicy.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.extension_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.place} · ${item.whenLabel}\n${item.host} · ok. ${item.ratingHint} elo',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _ChessDialog extends StatefulWidget {
  final String userName;

  const _ChessDialog({required this.userName});

  @override
  State<_ChessDialog> createState() => _ChessDialogState();
}

class _ChessDialogState extends State<_ChessDialog> {
  final _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sparing'),
      content: TextField(
        controller: _title,
        decoration: const InputDecoration(labelText: 'Wyzwanie'),
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
              ChessChallenge(
                id: 'ch-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? 'Sparing szachowy'
                    : _title.text.trim(),
                place: 'Park / świetlica',
                whenLabel: 'Sobota 11:00',
                host: widget.userName,
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
