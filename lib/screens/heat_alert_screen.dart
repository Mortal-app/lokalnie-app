import 'package:flutter/material.dart';

import '../models/heat_alert.dart';
import '../theme/widzew_ui.dart';

class HeatAlertScreen extends StatefulWidget {
  final List<HeatAlert> items;
  final String userName;
  final ValueChanged<HeatAlert> onAdd;

  const HeatAlertScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<HeatAlertScreen> createState() => _HeatAlertScreenState();
}

class _HeatAlertScreenState extends State<HeatAlertScreen> {
  late List<HeatAlert> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<HeatAlert>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _HeatDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('C.O. i ciepła woda')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.thermostat_outlined),
        label: const Text('Zgłoś'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Wychłodzone kaloryfery i zaplanowane prace Veolii w Twojej okolicy.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.thermostat_outlined),
                title: Text(item.kind.label),
                subtitle: Text(
                  '${item.place} · ${item.whenText}\n${item.note} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _HeatDialog extends StatefulWidget {
  final String userName;

  const _HeatDialog({required this.userName});

  @override
  State<_HeatDialog> createState() => _HeatDialogState();
}

class _HeatDialogState extends State<_HeatDialog> {
  var _kind = HeatAlertKind.coldRadiator;
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
      title: const Text('Zgłoszenie C.O.'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<HeatAlertKind>(
              initialValue: _kind,
              items: [
                for (final kind in HeatAlertKind.values)
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
              HeatAlert(
                id: 'ha-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                place: _place.text.trim().isEmpty
                    ? 'Okolica'
                    : _place.text.trim(),
                whenText: 'Teraz',
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
