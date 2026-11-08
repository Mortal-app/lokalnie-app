import 'package:flutter/material.dart';

import '../models/badminton_meetup.dart';

class BadmintonMeetupScreen extends StatefulWidget {
  final List<BadmintonMeetup> items;
  final String userName;
  final ValueChanged<BadmintonMeetup> onAdd;

  const BadmintonMeetupScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<BadmintonMeetupScreen> createState() => _BadmintonMeetupScreenState();
}

class _BadmintonMeetupScreenState extends State<BadmintonMeetupScreen> {
  late List<BadmintonMeetup> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<BadmintonMeetup>(
      context: context,
      builder: (_) => _BadDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Badminton i korty')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.sports_tennis_outlined),
        label: const Text('Sparing'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Amatorski badminton na trawnikach, boiskach i kortach otwartych — osobno od ping-ponga.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.sports_tennis_outlined),
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

class _BadDialog extends StatefulWidget {
  final String userName;

  const _BadDialog({required this.userName});

  @override
  State<_BadDialog> createState() => _BadDialogState();
}

class _BadDialogState extends State<_BadDialog> {
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
              BadmintonMeetup(
                id: 'bd-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? 'Badminton'
                    : _title.text.trim(),
                whenText: _when.text.trim().isEmpty
                    ? 'Do uzgodnienia'
                    : _when.text.trim(),
                place: 'Boisko osiedlowe',
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
