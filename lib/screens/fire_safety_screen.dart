import 'package:flutter/material.dart';

import '../models/fire_safety.dart';

class FireSafetyScreen extends StatefulWidget {
  final List<FireSafetyReport> items;
  final String userName;
  final ValueChanged<FireSafetyReport> onAdd;

  const FireSafetyScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<FireSafetyScreen> createState() => _FireSafetyScreenState();
}

class _FireSafetyScreenState extends State<FireSafetyScreen> {
  late List<FireSafetyReport> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<FireSafetyReport>(
      context: context,
      builder: (_) => _FireDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Czujniki dymu i pożar')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.local_fire_department_outlined),
        label: const Text('Zgłoś zagrożenie'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Poradnik antypożarowy w bloku oraz zgłoszenia zablokowanego wyjścia lub zagraconej piwnicy.',
          ),
          const SizedBox(height: 8),
          for (final tip in FireSafetyReport.tips)
            Card(
              child: ListTile(
                leading: const Icon(Icons.smoke_free_outlined),
                title: Text(tip),
              ),
            ),
          const SizedBox(height: 8),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.warning_amber_outlined),
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

class _FireDialog extends StatefulWidget {
  final String userName;

  const _FireDialog({required this.userName});

  @override
  State<_FireDialog> createState() => _FireDialogState();
}

class _FireDialogState extends State<_FireDialog> {
  final _place = TextEditingController();
  final _note = TextEditingController();
  var _kind = FireHazardKind.blockedExit;

  @override
  void dispose() {
    _place.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zgłoszenie pożarowe'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<FireHazardKind>(
              initialValue: _kind,
              items: [
                for (final kind in FireHazardKind.values)
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
              FireSafetyReport(
                id: 'fs-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                place: _place.text.trim().isEmpty
                    ? 'Klatka na Widzewie'
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
