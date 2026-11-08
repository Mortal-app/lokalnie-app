import 'package:flutter/material.dart';

import '../models/wildlife_care.dart';

class WildlifeCareScreen extends StatefulWidget {
  final List<WildlifeCareReport> items;
  final String userName;
  final ValueChanged<WildlifeCareReport> onAdd;

  const WildlifeCareScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<WildlifeCareScreen> createState() => _WildlifeCareScreenState();
}

class _WildlifeCareScreenState extends State<WildlifeCareScreen> {
  late List<WildlifeCareReport> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<WildlifeCareReport>(
      context: context,
      builder: (_) => _CareDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ratunek dla zwierząt')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.pets),
        label: const Text('Nowe zgłoszenie'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Zimowe dokarmianie ptaków w parkach i zgłoszenia rannych zwierząt. Nie dokarmiaj chlebem.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(
                  item.kind == WildlifeCareKind.injured
                      ? Icons.healing_outlined
                      : Icons.park_outlined,
                ),
                title: Text(item.kind.label),
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

class _CareDialog extends StatefulWidget {
  final String userName;

  const _CareDialog({required this.userName});

  @override
  State<_CareDialog> createState() => _CareDialogState();
}

class _CareDialogState extends State<_CareDialog> {
  final _place = TextEditingController();
  final _note = TextEditingController();
  var _kind = WildlifeCareKind.birdFeed;

  @override
  void dispose() {
    _place.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zgłoszenie'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<WildlifeCareKind>(
              initialValue: _kind,
              items: [
                for (final kind in WildlifeCareKind.values)
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
              WildlifeCareReport(
                id: 'wc-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                place: _place.text.trim().isEmpty
                    ? 'Park na Widzewie'
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
