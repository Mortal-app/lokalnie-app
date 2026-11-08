import 'package:flutter/material.dart';

import '../models/smoke_alarm.dart';

class SmokeAlarmScreen extends StatefulWidget {
  final List<SmokeAlarmReminder> items;
  final String userName;
  final ValueChanged<SmokeAlarmReminder> onAdd;

  const SmokeAlarmScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<SmokeAlarmScreen> createState() => _SmokeAlarmScreenState();
}

class _SmokeAlarmScreenState extends State<SmokeAlarmScreen> {
  late List<SmokeAlarmReminder> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<SmokeAlarmReminder>(
      context: context,
      builder: (_) => _SmokeDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  void _remind(SmokeAlarmReminder item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Przypomnienie: ${item.kind.label} — ${item.nextChange}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Czujniki dymu i czadu')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.sensors_outlined),
        label: const Text('Czujnik'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Kontrola i wymiana baterii w czujnikach dymu oraz czadu.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.sensors_outlined),
                title: Text(item.kind.label),
                subtitle: Text(
                  '${item.nextChange}\n${item.note} · ${item.authorName}',
                ),
                isThreeLine: true,
                trailing: IconButton(
                  tooltip: 'Przypomnij',
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () => _remind(item),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SmokeDialog extends StatefulWidget {
  final String userName;

  const _SmokeDialog({required this.userName});

  @override
  State<_SmokeDialog> createState() => _SmokeDialogState();
}

class _SmokeDialogState extends State<_SmokeDialog> {
  var _kind = SmokeKind.smoke;
  final _next = TextEditingController();

  @override
  void dispose() {
    _next.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Czujnik'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<SmokeKind>(
            initialValue: _kind,
            items: [
              for (final kind in SmokeKind.values)
                DropdownMenuItem(value: kind, child: Text(kind.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _kind = value);
            },
          ),
          TextField(
            controller: _next,
            decoration: const InputDecoration(labelText: 'Następna kontrola'),
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
              SmokeAlarmReminder(
                id: 'sa-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                nextChange: _next.text.trim().isEmpty
                    ? 'Za 6 miesięcy'
                    : _next.text.trim(),
                note: 'Wymiana baterii i test przyciskiem.',
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
