import 'package:flutter/material.dart';

import '../models/emergency_rental.dart';
import '../theme/widzew_ui.dart';

class EmergencyRentalScreen extends StatefulWidget {
  final List<EmergencyRentalItem> items;
  final String userName;
  final ValueChanged<EmergencyRentalItem> onAdd;

  const EmergencyRentalScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<EmergencyRentalScreen> createState() => _EmergencyRentalScreenState();
}

class _EmergencyRentalScreenState extends State<EmergencyRentalScreen> {
  late List<EmergencyRentalItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<EmergencyRentalItem>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _RentDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sprzęt na wynajem awaryjny')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.inventory_2_outlined),
        label: const Text('Dodaj sprzęt'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Osuszacze, odkurzacze piorące i projektory u sąsiadów — symboliczna opłata albo przysługa.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.inventory_2_outlined),
                title: Text(item.kind.label),
                subtitle: Text('${item.terms}\n${item.authorName}'),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _RentDialog extends StatefulWidget {
  final String userName;

  const _RentDialog({required this.userName});

  @override
  State<_RentDialog> createState() => _RentDialogState();
}

class _RentDialogState extends State<_RentDialog> {
  var _kind = EmergencyGearKind.dehumidifier;
  final _terms = TextEditingController();

  @override
  void dispose() {
    _terms.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sprzęt awaryjny'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<EmergencyGearKind>(
            initialValue: _kind,
            items: [
              for (final kind in EmergencyGearKind.values)
                DropdownMenuItem(value: kind, child: Text(kind.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _kind = value);
            },
          ),
          TextField(
            controller: _terms,
            decoration: const InputDecoration(
              labelText: 'Opłata / przysługa',
            ),
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
              EmergencyRentalItem(
                id: 'er-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                terms: _terms.text.trim().isEmpty
                    ? 'Za przysługę'
                    : _terms.text.trim(),
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
