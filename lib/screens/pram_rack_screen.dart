import 'package:flutter/material.dart';

import '../models/pram_rack.dart';
import '../theme/widzew_ui.dart';

class PramRackScreen extends StatefulWidget {
  final List<PramRackNotice> items;
  final String userName;
  final ValueChanged<PramRackNotice> onAdd;

  const PramRackScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<PramRackScreen> createState() => _PramRackScreenState();
}

class _PramRackScreenState extends State<PramRackScreen> {
  late List<PramRackNotice> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<PramRackNotice>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _RackDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stojaki i wózkownie')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.pedal_bike_outlined),
        label: const Text('Zgłoś miejsce'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Wolne haki oraz porzucone rowery i wózki w osiedlowych wózkowniach.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.pedal_bike_outlined),
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

class _RackDialog extends StatefulWidget {
  final String userName;

  const _RackDialog({required this.userName});

  @override
  State<_RackDialog> createState() => _RackDialogState();
}

class _RackDialogState extends State<_RackDialog> {
  var _kind = PramRackKind.freeSlot;
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
      title: const Text('Wózkownia'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<PramRackKind>(
            initialValue: _kind,
            items: [
              for (final kind in PramRackKind.values)
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
              PramRackNotice(
                id: 'pr-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                place: _place.text.trim().isEmpty
                    ? 'Wózkownia'
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
