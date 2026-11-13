import 'package:flutter/material.dart';

import '../models/caretaker_note.dart';
import '../theme/widzew_ui.dart';

class CaretakerNotesScreen extends StatefulWidget {
  final List<CaretakerNote> items;
  final ValueChanged<CaretakerNote> onAdd;

  const CaretakerNotesScreen({
    super.key,
    required this.items,
    required this.onAdd,
  });

  @override
  State<CaretakerNotesScreen> createState() => _CaretakerNotesScreenState();
}

class _CaretakerNotesScreenState extends State<CaretakerNotesScreen> {
  late List<CaretakerNote> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<CaretakerNote>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _NoteDialog(),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes gospodarza klatki')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.note_add_outlined),
        label: const Text('Nowa notatka'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Usterki, plan sprzątania i przeglądy techniczne — panel gospodarza domu.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(switch (item.kind) {
                  CaretakerKind.fault => Icons.report_problem_outlined,
                  CaretakerKind.cleaning => Icons.cleaning_services_outlined,
                  CaretakerKind.inspection => Icons.fact_check_outlined,
                }),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.staircase} · ${item.whenLabel}\n${item.body}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _NoteDialog extends StatefulWidget {
  const _NoteDialog();

  @override
  State<_NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<_NoteDialog> {
  final _title = TextEditingController();
  final _body = TextEditingController();
  final _staircase = TextEditingController(text: 'Klatka I');
  var _kind = CaretakerKind.fault;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    _staircase.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Notatka gospodarza'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<CaretakerKind>(
              initialValue: _kind,
              items: [
                for (final kind in CaretakerKind.values)
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
              decoration: const InputDecoration(labelText: 'Treść'),
            ),
            TextField(
              controller: _staircase,
              decoration: const InputDecoration(labelText: 'Klatka'),
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
              CaretakerNote(
                id: 'care-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                body: _body.text.trim(),
                staircase: _staircase.text.trim(),
                whenLabel: 'Dziś',
              ),
            );
          },
          child: const Text('Zapisz'),
        ),
      ],
    );
  }
}
