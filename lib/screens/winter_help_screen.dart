import 'package:flutter/material.dart';

import '../models/winter_help.dart';
import '../theme/widzew_ui.dart';

class WinterHelpScreen extends StatefulWidget {
  final List<WinterHelpOffer> items;
  final String userName;
  final ValueChanged<WinterHelpOffer> onAdd;

  const WinterHelpScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<WinterHelpScreen> createState() => _WinterHelpScreenState();
}

class _WinterHelpScreenState extends State<WinterHelpScreen> {
  late List<WinterHelpOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<WinterHelpOffer>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _WinterDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zima: carpool i odśnieżanie')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.ac_unit),
        label: const Text('Dodaj pomoc'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Odśnieżanie aut po nocnych opadach i zimowe dojazdy — wzajemna pomoc.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(
                  item.kind == WinterHelpKind.snowCar
                      ? Icons.ac_unit
                      : Icons.directions_car_outlined,
                ),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.whenLabel}\n${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _WinterDialog extends StatefulWidget {
  final String userName;

  const _WinterDialog({required this.userName});

  @override
  State<_WinterDialog> createState() => _WinterDialogState();
}

class _WinterDialogState extends State<_WinterDialog> {
  final _title = TextEditingController();
  var _kind = WinterHelpKind.snowCar;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pomoc zimowa'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<WinterHelpKind>(
              initialValue: _kind,
              items: [
                for (final kind in WinterHelpKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
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
              WinterHelpOffer(
                id: 'wh-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                whenLabel: 'Po opadach',
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
