import 'package:flutter/material.dart';

import '../models/cargo_carpool.dart';
import '../theme/widzew_ui.dart';

class CargoCarpoolScreen extends StatefulWidget {
  final List<CargoCarpoolOffer> items;
  final String userName;
  final ValueChanged<CargoCarpoolOffer> onAdd;

  const CargoCarpoolScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<CargoCarpoolScreen> createState() => _CargoCarpoolScreenState();
}

class _CargoCarpoolScreenState extends State<CargoCarpoolScreen> {
  late List<CargoCarpoolOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<CargoCarpoolOffer>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _CargoDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carpooling bagażowy')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.local_shipping_outlined),
        label: const Text('Kombi / dostawczak'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Kombi i busy — pomoc w przewiezieniu dużego zakupu ze sklepu meblowego.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.airport_shuttle_outlined),
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

class _CargoDialog extends StatefulWidget {
  final String userName;

  const _CargoDialog({required this.userName});

  @override
  State<_CargoDialog> createState() => _CargoDialogState();
}

class _CargoDialogState extends State<_CargoDialog> {
  final _title = TextEditingController();
  var _kind = CargoVehicleKind.kombi;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Transport mebli'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<CargoVehicleKind>(
              initialValue: _kind,
              items: [
                for (final kind in CargoVehicleKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Trasa / ładunek'),
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
              CargoCarpoolOffer(
                id: 'cg-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Pomoc z zakupem meblowym'
                    : _title.text.trim(),
                whenLabel: 'Weekend',
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
