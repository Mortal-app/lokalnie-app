import 'package:flutter/material.dart';

import '../models/smile_tutor.dart';
import '../theme/widzew_ui.dart';

class SmileTutorScreen extends StatefulWidget {
  final List<SmileTutorOffer> items;
  final String userName;
  final ValueChanged<SmileTutorOffer> onAdd;

  const SmileTutorScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<SmileTutorScreen> createState() => _SmileTutorScreenState();
}

class _SmileTutorScreenState extends State<SmileTutorScreen> {
  late List<SmileTutorOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<SmileTutorOffer>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _TutorDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Korepetycje Za Uśmiech')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.school_outlined),
        label: const Text('Oferuję pomoc'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Darmowa pomoc w nauce dla dzieci ze szkoły podstawowej — od starszych uczniów i studentów z osiedla.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.school_outlined),
                title: Text(item.subject),
                subtitle: Text(
                  '${item.level} · ${item.whenText}\n${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _TutorDialog extends StatefulWidget {
  final String userName;

  const _TutorDialog({required this.userName});

  @override
  State<_TutorDialog> createState() => _TutorDialogState();
}

class _TutorDialogState extends State<_TutorDialog> {
  final _subject = TextEditingController();
  final _when = TextEditingController();

  @override
  void dispose() {
    _subject.dispose();
    _when.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pomoc za uśmiech'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _subject,
            decoration: const InputDecoration(labelText: 'Przedmiot'),
          ),
          TextField(
            controller: _when,
            decoration: const InputDecoration(labelText: 'Kiedy'),
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
              SmileTutorOffer(
                id: 'st-${DateTime.now().millisecondsSinceEpoch}',
                subject: _subject.text.trim().isEmpty
                    ? 'Korepetycje za uśmiech'
                    : _subject.text.trim(),
                level: 'Szkoła podstawowa',
                whenText: _when.text.trim().isEmpty
                    ? 'Po lekcjach'
                    : _when.text.trim(),
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
