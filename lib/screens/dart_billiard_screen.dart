import 'package:flutter/material.dart';

import '../models/dart_billiard.dart';

class DartBilliardScreen extends StatefulWidget {
  final List<DartBilliardMeetup> items;
  final String userName;
  final ValueChanged<DartBilliardMeetup> onAdd;

  const DartBilliardScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<DartBilliardScreen> createState() => _DartBilliardScreenState();
}

class _DartBilliardScreenState extends State<DartBilliardScreen> {
  late List<DartBilliardMeetup> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<DartBilliardMeetup>(
      context: context,
      builder: (_) => _GameDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dart i bilard')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.sports_outlined),
        label: const Text('Rozgrywka'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Amatorskie rzutki i bilard w świetlicach, klubach osiedlowych i pubach na Widzewie.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.gps_fixed),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.place}\n${item.whenText} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _GameDialog extends StatefulWidget {
  final String userName;

  const _GameDialog({required this.userName});

  @override
  State<_GameDialog> createState() => _GameDialogState();
}

class _GameDialogState extends State<_GameDialog> {
  var _kind = CueGameKind.darts;
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
      title: const Text('Spotkanie'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<CueGameKind>(
            initialValue: _kind,
            items: [
              for (final kind in CueGameKind.values)
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
              DartBilliardMeetup(
                id: 'db-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Rozgrywka amatorska'
                    : _title.text.trim(),
                whenText: _when.text.trim().isEmpty
                    ? 'Do uzgodnienia'
                    : _when.text.trim(),
                place: 'Świetlica osiedlowa',
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
