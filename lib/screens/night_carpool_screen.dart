import 'package:flutter/material.dart';

import '../models/night_carpool.dart';

class NightCarpoolScreen extends StatefulWidget {
  final List<NightCarpoolRide> items;
  final String userName;
  final ValueChanged<NightCarpoolRide> onAdd;

  const NightCarpoolScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<NightCarpoolScreen> createState() => _NightCarpoolScreenState();
}

class _NightCarpoolScreenState extends State<NightCarpoolScreen> {
  late List<NightCarpoolRide> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<NightCarpoolRide>(
      context: context,
      builder: (_) => _NightDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nocny i weekendowy carpool')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.nights_stay_outlined),
        label: const Text('Zgłoś przejazd'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Powroty z nocnych imprez w centrum Łodzi oraz weekendowe wyjazdy poza miasto.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(
                  item.kind == NightRideKind.nightReturn
                      ? Icons.nights_stay_outlined
                      : Icons.weekend_outlined,
                ),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.whenLabel}\n${item.seats} miejsca · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _NightDialog extends StatefulWidget {
  final String userName;

  const _NightDialog({required this.userName});

  @override
  State<_NightDialog> createState() => _NightDialogState();
}

class _NightDialogState extends State<_NightDialog> {
  final _title = TextEditingController();
  var _kind = NightRideKind.nightReturn;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Przejazd'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<NightRideKind>(
              initialValue: _kind,
              items: [
                for (final kind in NightRideKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Trasa'),
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
              NightCarpoolRide(
                id: 'nc-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                whenLabel: _kind == NightRideKind.nightReturn
                    ? 'Dziś po 23:00'
                    : 'Weekend',
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
