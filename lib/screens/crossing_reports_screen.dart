import 'package:flutter/material.dart';

import '../models/crossing_report.dart';

class CrossingReportsScreen extends StatefulWidget {
  final List<CrossingReport> items;
  final String userName;
  final ValueChanged<CrossingReport> onAdd;

  const CrossingReportsScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<CrossingReportsScreen> createState() => _CrossingReportsScreenState();
}

class _CrossingReportsScreenState extends State<CrossingReportsScreen> {
  late List<CrossingReport> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<CrossingReport>(
      context: context,
      builder: (_) => _CrossDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bezpieczne przejścia')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.traffic_outlined),
        label: const Text('Zgłoś przejście'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Szybkie zgłoszenia ciemnych, nieoświetlonych lub niebezpiecznych przejść dla pieszych.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.warning_amber_outlined),
                title: Text(item.place),
                subtitle: Text(
                  '${item.issue.label}\n${item.note} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _CrossDialog extends StatefulWidget {
  final String userName;

  const _CrossDialog({required this.userName});

  @override
  State<_CrossDialog> createState() => _CrossDialogState();
}

class _CrossDialogState extends State<_CrossDialog> {
  final _place = TextEditingController();
  final _note = TextEditingController();
  var _issue = CrossingIssue.unlit;

  @override
  void dispose() {
    _place.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zgłoszenie przejścia'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<CrossingIssue>(
              initialValue: _issue,
              items: [
                for (final issue in CrossingIssue.values)
                  DropdownMenuItem(value: issue, child: Text(issue.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _issue = value);
              },
            ),
            TextField(
              controller: _place,
              decoration: const InputDecoration(labelText: 'Lokalizacja'),
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
              CrossingReport(
                id: 'cr-${DateTime.now().millisecondsSinceEpoch}',
                issue: _issue,
                place: _place.text.trim().isEmpty
                    ? 'Przejście na Widzewie'
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
