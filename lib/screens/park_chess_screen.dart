import 'package:flutter/material.dart';

import '../models/park_chess.dart';

class ParkChessScreen extends StatefulWidget {
  final List<ParkChessMeetup> items;
  final String userName;
  final ValueChanged<ParkChessMeetup> onAdd;

  const ParkChessScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<ParkChessScreen> createState() => _ParkChessScreenState();
}

class _ParkChessScreenState extends State<ParkChessScreen> {
  late List<ParkChessMeetup> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<ParkChessMeetup>(
      context: context,
      builder: (_) => _ParkDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Szachy parkowe')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.event_seat_outlined),
        label: const Text('Umawiam partię'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Partie pod chmurką przy stolikach parkowych na Widzewie Wschodzie.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.event_seat_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.tablePlace} · ${item.whenText}\n${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _ParkDialog extends StatefulWidget {
  final String userName;

  const _ParkDialog({required this.userName});

  @override
  State<_ParkDialog> createState() => _ParkDialogState();
}

class _ParkDialogState extends State<_ParkDialog> {
  final _title = TextEditingController();
  final _when = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _when.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Partia w parku'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Tytuł'),
          ),
          TextField(
            controller: _when,
            decoration: const InputDecoration(labelText: 'Termin'),
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
              ParkChessMeetup(
                id: 'pc-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? 'Partia pod chmurką'
                    : _title.text.trim(),
                whenText: _when.text.trim().isEmpty
                    ? 'Dziś popołudniu'
                    : _when.text.trim(),
                tablePlace: 'Stoliki parkowe, Widzew Wschód',
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
