import 'package:flutter/material.dart';

import '../models/yard_game.dart';

class YardGameScreen extends StatefulWidget {
  final List<YardGameMeetup> items;
  final String userName;
  final ValueChanged<YardGameMeetup> onAdd;

  const YardGameScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<YardGameScreen> createState() => _YardGameScreenState();
}

class _YardGameScreenState extends State<YardGameScreen> {
  late List<YardGameMeetup> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<YardGameMeetup>(
      context: context,
      builder: (_) => _YardDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gry podwórkowe i bule')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.sports),
        label: const Text('Turniej'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Turnieje kapśli, gumy do skakania, klas i bul podwórkowych — osobno od klubu pétanque na skwerze.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.sports),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.whenText}\n${item.place} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _YardDialog extends StatefulWidget {
  final String userName;

  const _YardDialog({required this.userName});

  @override
  State<_YardDialog> createState() => _YardDialogState();
}

class _YardDialogState extends State<_YardDialog> {
  var _kind = YardGameKind.caps;
  final _title = TextEditingController();
  final _when = TextEditingController();
  final _place = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _when.dispose();
    _place.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nowy turniej'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<YardGameKind>(
            initialValue: _kind,
            items: [
              for (final kind in YardGameKind.values)
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
            controller: _when,
            decoration: const InputDecoration(labelText: 'Termin'),
          ),
          TextField(
            controller: _place,
            decoration: const InputDecoration(labelText: 'Miejsce'),
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
              YardGameMeetup(
                id: 'yg-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                whenText: _when.text.trim().isEmpty
                    ? 'Do uzgodnienia'
                    : _when.text.trim(),
                place: _place.text.trim().isEmpty
                    ? 'Podwórko'
                    : _place.text.trim(),
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
