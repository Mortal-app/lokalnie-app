import 'package:flutter/material.dart';

import '../models/small_appliance.dart';
import '../theme/widzew_ui.dart';

class SmallAppliancesScreen extends StatefulWidget {
  final List<SmallAppliance> items;
  final String userName;
  final ValueChanged<SmallAppliance> onAdd;

  const SmallAppliancesScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<SmallAppliancesScreen> createState() => _SmallAppliancesScreenState();
}

class _SmallAppliancesScreenState extends State<SmallAppliancesScreen> {
  late List<SmallAppliance> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<SmallAppliance>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _AppDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drugie życie AGD')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.kitchen_outlined),
        label: const Text('Blender / toster'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Nie wyrzucaj — napraw z sąsiadem, który zna się na elektronice. Blender, toster, drobne AGD.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.electrical_services_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.forRepair ? 'Do naprawy' : 'Sprawne — oddam'}\n${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _AppDialog extends StatefulWidget {
  final String userName;

  const _AppDialog({required this.userName});

  @override
  State<_AppDialog> createState() => _AppDialogState();
}

class _AppDialogState extends State<_AppDialog> {
  final _title = TextEditingController();
  var _kind = ApplianceKind.blender;
  var _repair = true;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Drobne AGD'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<ApplianceKind>(
              initialValue: _kind,
              items: [
                for (final kind in ApplianceKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Do naprawy'),
              value: _repair,
              onChanged: (value) => setState(() => _repair = value),
            ),
            TextField(
              controller: _title,
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
              SmallAppliance(
                id: 'sa-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                authorName: widget.userName,
                forRepair: _repair,
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
