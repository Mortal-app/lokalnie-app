import 'package:flutter/material.dart';

import '../models/jazz_blues.dart';
import '../theme/widzew_ui.dart';

class JazzBluesScreen extends StatefulWidget {
  final List<JazzBluesPost> items;
  final String userName;
  final ValueChanged<JazzBluesPost> onAdd;

  const JazzBluesScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<JazzBluesScreen> createState() => _JazzBluesScreenState();
}

class _JazzBluesScreenState extends State<JazzBluesScreen> {
  late List<JazzBluesPost> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<JazzBluesPost>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _JazzDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jazz i blues')),
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
            'Płyty, kluby jazzowe w Łodzi i jam session — osobno od rocka, ambientu i disco.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.music_note_outlined),
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

class _JazzDialog extends StatefulWidget {
  final String userName;

  const _JazzDialog({required this.userName});

  @override
  State<_JazzDialog> createState() => _JazzDialogState();
}

class _JazzDialogState extends State<_JazzDialog> {
  var _kind = JazzKind.concert;
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
      title: const Text('Jazz / blues'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<JazzKind>(
            initialValue: _kind,
            items: [
              for (final kind in JazzKind.values)
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
            decoration: const InputDecoration(labelText: 'Szczegóły'),
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
              JazzBluesPost(
                id: 'jb-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Wpis jazzowy'
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
