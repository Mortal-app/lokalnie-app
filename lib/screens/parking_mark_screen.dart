import 'package:flutter/material.dart';

import '../models/parking_mark.dart';

class ParkingMarkScreen extends StatefulWidget {
  final List<ParkingMarkReport> items;
  final String userName;
  final ValueChanged<ParkingMarkReport> onAdd;

  const ParkingMarkScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<ParkingMarkScreen> createState() => _ParkingMarkScreenState();
}

class _ParkingMarkScreenState extends State<ParkingMarkScreen> {
  late List<ParkingMarkReport> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<ParkingMarkReport>(
      context: context,
      builder: (_) => _ParkingDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Oznakowanie parkingów')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.format_paint_outlined),
        label: const Text('Zgłoszenie'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Planowanie odświeżania linii stanowisk postojowych i kopert dla osób niepełnosprawnych pod blokami.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(
                  item.kind == ParkingMarkKind.disabledEnvelope
                      ? Icons.accessible
                      : Icons.local_parking,
                ),
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

class _ParkingDialog extends StatefulWidget {
  final String userName;

  const _ParkingDialog({required this.userName});

  @override
  State<_ParkingDialog> createState() => _ParkingDialogState();
}

class _ParkingDialogState extends State<_ParkingDialog> {
  var _kind = ParkingMarkKind.lines;
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
      title: const Text('Zgłoszenie malowania'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<ParkingMarkKind>(
            initialValue: _kind,
            items: [
              for (final kind in ParkingMarkKind.values)
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
              ParkingMarkReport(
                id: 'pm-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                place: _place.text.trim().isEmpty
                    ? 'Pod blokiem'
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
