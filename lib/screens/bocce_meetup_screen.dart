import 'package:flutter/material.dart';

import '../models/bocce_meetup.dart';

class BocceMeetupScreen extends StatefulWidget {
  final List<BocceMeetup> items;
  final String userName;
  final ValueChanged<BocceMeetup> onAdd;

  const BocceMeetupScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<BocceMeetupScreen> createState() => _BocceMeetupScreenState();
}

class _BocceMeetupScreenState extends State<BocceMeetupScreen> {
  late List<BocceMeetup> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<BocceMeetup>(
      context: context,
      builder: (_) => _BocceDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kule / pétanque')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.sports_outlined),
        label: const Text('Rozgrywka'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Amatorskie boule i bocce na skwerach i trawnikach Widzewa Wschodu.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.sports_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.whenText} · ${item.place}\n${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _BocceDialog extends StatefulWidget {
  final String userName;

  const _BocceDialog({required this.userName});

  @override
  State<_BocceDialog> createState() => _BocceDialogState();
}

class _BocceDialogState extends State<_BocceDialog> {
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
      title: const Text('Pétanque'),
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
              BocceMeetup(
                id: 'bc-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? 'Kule na skwerze'
                    : _title.text.trim(),
                whenText: _when.text.trim().isEmpty
                    ? 'Do uzgodnienia'
                    : _when.text.trim(),
                place: 'Skwer osiedlowy',
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
