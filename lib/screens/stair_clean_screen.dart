import 'package:flutter/material.dart';

import '../models/stair_clean.dart';
import '../theme/widzew_ui.dart';

class StairCleanScreen extends StatefulWidget {
  final List<StairCleanSlot> items;
  final String userName;
  final ValueChanged<StairCleanSlot> onAdd;

  const StairCleanScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<StairCleanScreen> createState() => _StairCleanScreenState();
}

class _StairCleanScreenState extends State<StairCleanScreen> {
  late List<StairCleanSlot> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<StairCleanSlot>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _CleanDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mycie klatek i okien')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.cleaning_services_outlined),
        label: const Text('Zapisuję się'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Harmonogram społecznych porządków: okna na klatkach i wspólne przestrzenie.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.cleaning_services_outlined),
                title: Text(item.kind.label),
                subtitle: Text(
                  '${item.place} · ${item.whenText}\n${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _CleanDialog extends StatefulWidget {
  final String userName;

  const _CleanDialog({required this.userName});

  @override
  State<_CleanDialog> createState() => _CleanDialogState();
}

class _CleanDialogState extends State<_CleanDialog> {
  var _kind = StairCleanKind.windows;
  final _when = TextEditingController();
  final _place = TextEditingController();

  @override
  void dispose() {
    _when.dispose();
    _place.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Termin porządków'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<StairCleanKind>(
            initialValue: _kind,
            items: [
              for (final kind in StairCleanKind.values)
                DropdownMenuItem(value: kind, child: Text(kind.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _kind = value);
            },
          ),
          TextField(
            controller: _when,
            decoration: const InputDecoration(labelText: 'Kiedy'),
          ),
          TextField(
            controller: _place,
            decoration: const InputDecoration(labelText: 'Klatka'),
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
              StairCleanSlot(
                id: 'sc-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                whenText: _when.text.trim().isEmpty
                    ? 'Do uzgodnienia'
                    : _when.text.trim(),
                place: _place.text.trim().isEmpty
                    ? 'Klatka osiedlowa'
                    : _place.text.trim(),
                authorName: widget.userName,
              ),
            );
          },
          child: const Text('Zapisz'),
        ),
      ],
    );
  }
}
