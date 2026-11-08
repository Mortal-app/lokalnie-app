import 'package:flutter/material.dart';

import '../models/table_sport.dart';

class TableSportScreen extends StatefulWidget {
  final List<TableSportMeetup> items;
  final String userName;
  final ValueChanged<TableSportMeetup> onAdd;

  const TableSportScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<TableSportScreen> createState() => _TableSportScreenState();
}

class _TableSportScreenState extends State<TableSportScreen> {
  late List<TableSportMeetup> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<TableSportMeetup>(
      context: context,
      builder: (_) => _SportDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ping-pong i piłkarzyki')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.sports_tennis_outlined),
        label: const Text('Sparing'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Amatorskie sparingi w świetlicach spółdzielni i klubach osiedlowych.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.sports_tennis_outlined),
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

class _SportDialog extends StatefulWidget {
  final String userName;

  const _SportDialog({required this.userName});

  @override
  State<_SportDialog> createState() => _SportDialogState();
}

class _SportDialogState extends State<_SportDialog> {
  var _kind = TableSportKind.pingPong;
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
      title: const Text('Sparing'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<TableSportKind>(
            initialValue: _kind,
            items: [
              for (final kind in TableSportKind.values)
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
              TableSportMeetup(
                id: 'ts-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Sparing amatorski'
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
