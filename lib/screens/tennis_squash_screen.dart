import 'package:flutter/material.dart';

import '../models/tennis_squash.dart';

class TennisSquashScreen extends StatefulWidget {
  final List<TennisSquashMeetup> items;
  final String userName;
  final ValueChanged<TennisSquashMeetup> onAdd;

  const TennisSquashScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<TennisSquashScreen> createState() => _TennisSquashScreenState();
}

class _TennisSquashScreenState extends State<TennisSquashScreen> {
  late List<TennisSquashMeetup> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<TennisSquashMeetup>(
      context: context,
      builder: (_) => _RacketDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tenis i squash')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.sports),
        label: const Text('Sparing'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Amatorskie sparingi tenisowe i squash na obiektach sportowych w okolicy Widzewa i Olechowa.',
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

class _RacketDialog extends StatefulWidget {
  final String userName;

  const _RacketDialog({required this.userName});

  @override
  State<_RacketDialog> createState() => _RacketDialogState();
}

class _RacketDialogState extends State<_RacketDialog> {
  var _kind = RacketKind.tennis;
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
      title: const Text('Nowy sparing'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<RacketKind>(
            initialValue: _kind,
            items: [
              for (final kind in RacketKind.values)
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
            decoration: const InputDecoration(labelText: 'Obiekt'),
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
              TennisSquashMeetup(
                id: 'tsq-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                whenText: _when.text.trim().isEmpty
                    ? 'Do uzgodnienia'
                    : _when.text.trim(),
                place: _place.text.trim().isEmpty
                    ? 'Widzew / Olechów'
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
