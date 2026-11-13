import 'package:flutter/material.dart';

import '../models/power_share.dart';
import '../theme/widzew_ui.dart';

class PowerShareScreen extends StatefulWidget {
  final List<PowerShareOffer> items;
  final String userName;
  final ValueChanged<PowerShareOffer> onAdd;

  const PowerShareScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<PowerShareScreen> createState() => _PowerShareScreenState();
}

class _PowerShareScreenState extends State<PowerShareScreen> {
  late List<PowerShareOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<PowerShareOffer>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _PowerDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bank awaryjnego zasilania')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.battery_charging_full),
        label: const Text('Pożyczam sprzęt'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Agregat, duży powerbank i latarki czołowe — na wypadek awarii prądu.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.electrical_services_outlined),
                title: Text(item.title),
                subtitle: Text('${item.kind.label} · ${item.authorName}'),
              ),
            ),
        ],
      ),
    );
  }
}

class _PowerDialog extends StatefulWidget {
  final String userName;

  const _PowerDialog({required this.userName});

  @override
  State<_PowerDialog> createState() => _PowerDialogState();
}

class _PowerDialogState extends State<_PowerDialog> {
  var _kind = PowerShareKind.powerbank;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Awaria prądu'),
      content: DropdownButtonFormField<PowerShareKind>(
        initialValue: _kind,
        items: [
          for (final kind in PowerShareKind.values)
            DropdownMenuItem(value: kind, child: Text(kind.label)),
        ],
        onChanged: (value) {
          if (value != null) setState(() => _kind = value);
        },
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
              PowerShareOffer(
                id: 'ps-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title:
                    'Mogę pożyczyć agregat prądotwórczy / duży powerbank / latarki czołowe dla sąsiadów w potrzebie',
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
