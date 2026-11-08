import 'package:flutter/material.dart';

import '../models/sidewalk_salt.dart';

class SidewalkSaltScreen extends StatefulWidget {
  final List<SidewalkSaltReport> items;
  final String userName;
  final ValueChanged<SidewalkSaltReport> onAdd;

  const SidewalkSaltScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<SidewalkSaltScreen> createState() => _SidewalkSaltScreenState();
}

class _SidewalkSaltScreenState extends State<SidewalkSaltScreen> {
  late List<SidewalkSaltReport> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<SidewalkSaltReport>(
      context: context,
      builder: (_) => _SaltDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ośnieżanie i posypywanie chodników')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.ac_unit),
        label: const Text('Zgłoszenie'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Koordynacja posypywania solą i piaskiem śliskich odcinków chodników przy klatkach — osobno od mycia kostki.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.ac_unit),
                title: Text(item.place),
                subtitle: Text(
                  '${item.kind.label}\n${item.note} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _SaltDialog extends StatefulWidget {
  final String userName;

  const _SaltDialog({required this.userName});

  @override
  State<_SaltDialog> createState() => _SaltDialogState();
}

class _SaltDialogState extends State<_SaltDialog> {
  var _kind = SaltKind.salt;
  final _place = TextEditingController();
  final _note = TextEditingController();

  @override
  void dispose() {
    _place.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Śliski odcinek'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<SaltKind>(
            initialValue: _kind,
            items: [
              for (final kind in SaltKind.values)
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
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Anuluj'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(
              context,
              SidewalkSaltReport(
                id: 'ss-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                place: _place.text.trim().isEmpty
                    ? 'Przy klatce'
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
