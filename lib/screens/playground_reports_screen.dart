import 'package:flutter/material.dart';

import '../models/playground_report.dart';

class PlaygroundReportsScreen extends StatefulWidget {
  final List<PlaygroundReport> items;
  final String userName;
  final ValueChanged<PlaygroundReport> onAdd;

  const PlaygroundReportsScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<PlaygroundReportsScreen> createState() =>
      _PlaygroundReportsScreenState();
}

class _PlaygroundReportsScreenState extends State<PlaygroundReportsScreen> {
  late List<PlaygroundReport> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<PlaygroundReport>(
      context: context,
      builder: (_) => _PlayDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bezpieczny plac zabaw')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.report_outlined),
        label: const Text('Zgłoś usterkę'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Huśtawki, nawierzchnia i ławeczki na osiedlowych placach zabaw.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.child_care_outlined),
                title: Text(item.issue.label),
                subtitle: Text(
                  '${item.place}\n${item.note} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _PlayDialog extends StatefulWidget {
  final String userName;

  const _PlayDialog({required this.userName});

  @override
  State<_PlayDialog> createState() => _PlayDialogState();
}

class _PlayDialogState extends State<_PlayDialog> {
  final _place = TextEditingController();
  final _note = TextEditingController();
  var _issue = PlaygroundIssue.swing;

  @override
  void dispose() {
    _place.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zgłoszenie placu zabaw'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<PlaygroundIssue>(
              initialValue: _issue,
              items: [
                for (final issue in PlaygroundIssue.values)
                  DropdownMenuItem(value: issue, child: Text(issue.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _issue = value);
              },
            ),
            TextField(
              controller: _place,
              decoration: const InputDecoration(labelText: 'Plac / adres'),
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
              PlaygroundReport(
                id: 'py-${DateTime.now().millisecondsSinceEpoch}',
                issue: _issue,
                place: _place.text.trim().isEmpty
                    ? 'Plac zabaw na osiedlu'
                    : _place.text.trim(),
                note: _note.text.trim(),
                authorName: widget.userName,
              ),
            );
          },
          child: const Text('Zgłoś'),
        ),
      ],
    );
  }
}
