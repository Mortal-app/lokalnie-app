import 'package:flutter/material.dart';

import '../models/classical_opera.dart';
import '../theme/widzew_ui.dart';

class ClassicalOperaScreen extends StatefulWidget {
  final List<ClassicalOperaPost> items;
  final String userName;
  final ValueChanged<ClassicalOperaPost> onAdd;

  const ClassicalOperaScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<ClassicalOperaScreen> createState() => _ClassicalOperaScreenState();
}

class _ClassicalOperaScreenState extends State<ClassicalOperaScreen> {
  late List<ClassicalOperaPost> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<ClassicalOperaPost>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _OperaDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Muzyka klasyczna i opera')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.music_note_outlined),
        label: const Text('Wpis'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Wymiana nagrań płytowych, zapowiedzi spektakli w Teatrze Wielkim w Łodzi oraz wspólne wyjścia kulturalne.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.album_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label}\n${item.body} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _OperaDialog extends StatefulWidget {
  final String userName;

  const _OperaDialog({required this.userName});

  @override
  State<_OperaDialog> createState() => _OperaDialogState();
}

class _OperaDialogState extends State<_OperaDialog> {
  var _kind = OperaKind.recording;
  final _title = TextEditingController();
  final _body = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Klasyka / opera'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<OperaKind>(
            initialValue: _kind,
            items: [
              for (final kind in OperaKind.values)
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
            controller: _body,
            decoration: const InputDecoration(labelText: 'Opis'),
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
              ClassicalOperaPost(
                id: 'co-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                body: _body.text.trim(),
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
