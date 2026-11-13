import 'package:flutter/material.dart';

import '../models/radiator_thermo.dart';
import '../theme/widzew_ui.dart';

class RadiatorThermoScreen extends StatefulWidget {
  final List<RadiatorThermoTip> items;
  final String userName;
  final ValueChanged<RadiatorThermoTip> onAdd;

  const RadiatorThermoScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<RadiatorThermoScreen> createState() => _RadiatorThermoScreenState();
}

class _RadiatorThermoScreenState extends State<RadiatorThermoScreen> {
  late List<RadiatorThermoTip> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<RadiatorThermoTip>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _RadiatorDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Termostaty i kaloryfery')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.thermostat_outlined),
        label: const Text('Porada'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Odblokowywanie iglic w głowicach termostatycznych i odpowietrzanie kaloryferów w bloku.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.thermostat_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label}\n${item.body} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _RadiatorDialog extends StatefulWidget {
  final String userName;

  const _RadiatorDialog({required this.userName});

  @override
  State<_RadiatorDialog> createState() => _RadiatorDialogState();
}

class _RadiatorDialogState extends State<_RadiatorDialog> {
  var _kind = RadiatorKind.pin;
  final _title = TextEditingController();
  final _body = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Porada majstra'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<RadiatorKind>(
            initialValue: _kind,
            items: [
              for (final kind in RadiatorKind.values)
                DropdownMenuItem(value: kind, child: Text(kind.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _kind = value);
            },
          ),
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Temat'),
          ),
          TextField(
            controller: _body,
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
              RadiatorThermoTip(
                id: 'rt-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                body: _body.text.trim(),
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
