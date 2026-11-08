import 'package:flutter/material.dart';

import '../models/streetball.dart';

class StreetballScreen extends StatefulWidget {
  final List<StreetballMeetup> items;
  final String userName;
  final ValueChanged<StreetballMeetup> onAdd;

  const StreetballScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<StreetballScreen> createState() => _StreetballScreenState();
}

class _StreetballScreenState extends State<StreetballScreen> {
  late List<StreetballMeetup> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<StreetballMeetup>(
      context: context,
      builder: (_) => _BallDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Koszykówka i streetball')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.sports_basketball_outlined),
        label: const Text('Mecz'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Luźne mecze na boiskach szkolnych i orlikach na Widzewie Wschodzie.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.sports_basketball_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.court.label} · ${item.place}\n${item.whenText} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _BallDialog extends StatefulWidget {
  final String userName;

  const _BallDialog({required this.userName});

  @override
  State<_BallDialog> createState() => _BallDialogState();
}

class _BallDialogState extends State<_BallDialog> {
  var _court = CourtKind.orlik;
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
      title: const Text('Streetball'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<CourtKind>(
            initialValue: _court,
            items: [
              for (final court in CourtKind.values)
                DropdownMenuItem(value: court, child: Text(court.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _court = value);
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
              StreetballMeetup(
                id: 'bb-${DateTime.now().millisecondsSinceEpoch}',
                court: _court,
                title: _title.text.trim().isEmpty
                    ? 'Luźny mecz'
                    : _title.text.trim(),
                whenText: _when.text.trim().isEmpty
                    ? 'Dziś wieczór'
                    : _when.text.trim(),
                place: 'Widzew Wschód',
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
