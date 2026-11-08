import 'package:flutter/material.dart';

import '../models/animal_patrol.dart';

class AnimalPatrolScreen extends StatefulWidget {
  final List<AnimalPatrolReport> items;
  final String userName;
  final ValueChanged<AnimalPatrolReport> onAdd;

  const AnimalPatrolScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<AnimalPatrolScreen> createState() => _AnimalPatrolScreenState();
}

class _AnimalPatrolScreenState extends State<AnimalPatrolScreen> {
  late List<AnimalPatrolReport> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<AnimalPatrolReport>(
      context: context,
      builder: (_) => _PatrolDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patrol ochrony zwierząt')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.pets),
        label: const Text('Zgłoszenie'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Interwencje, schroniska i dokarmianie kotów wolno żyjących. Krótki opis — bez alarmowych tytułów SOS.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.health_and_safety_outlined),
                title: Text(item.kind.label),
                subtitle: Text('${item.place}\n${item.note} · ${item.authorName}'),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _PatrolDialog extends StatefulWidget {
  final String userName;

  const _PatrolDialog({required this.userName});

  @override
  State<_PatrolDialog> createState() => _PatrolDialogState();
}

class _PatrolDialogState extends State<_PatrolDialog> {
  final _place = TextEditingController();
  final _note = TextEditingController();
  var _kind = AnimalPatrolKind.feralCat;

  @override
  void dispose() {
    _place.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Patrol zwierząt'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<AnimalPatrolKind>(
              initialValue: _kind,
              items: [
                for (final kind in AnimalPatrolKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _place,
              decoration: const InputDecoration(labelText: 'Miejsce'),
            ),
            TextField(
              controller: _note,
              decoration: const InputDecoration(labelText: 'Opis'),
            ),
          ],
        ),
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
              AnimalPatrolReport(
                id: 'ap-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                place: _place.text.trim().isEmpty
                    ? 'Osiedle Widzew'
                    : _place.text.trim(),
                note: _note.text.trim(),
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
