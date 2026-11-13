import 'package:flutter/material.dart';

import '../models/amateur_theater.dart';
import '../theme/widzew_ui.dart';

class AmateurTheaterScreen extends StatefulWidget {
  final List<AmateurTheaterMeetup> items;
  final String userName;
  final ValueChanged<AmateurTheaterMeetup> onAdd;

  const AmateurTheaterScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<AmateurTheaterScreen> createState() => _AmateurTheaterScreenState();
}

class _AmateurTheaterScreenState extends State<AmateurTheaterScreen> {
  late List<AmateurTheaterMeetup> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<AmateurTheaterMeetup>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _TheaterDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teatr i recytacja')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.theater_comedy_outlined),
        label: const Text('Spotkanie'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Wieczory literackie, poezja i małe formy artystyczne w świetlicy.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.theater_comedy_outlined),
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

class _TheaterDialog extends StatefulWidget {
  final String userName;

  const _TheaterDialog({required this.userName});

  @override
  State<_TheaterDialog> createState() => _TheaterDialogState();
}

class _TheaterDialogState extends State<_TheaterDialog> {
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
      title: const Text('Świetlica'),
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
              AmateurTheaterMeetup(
                id: 'at-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? 'Wieczór literacki'
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
