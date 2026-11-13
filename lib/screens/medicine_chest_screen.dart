import 'package:flutter/material.dart';

import '../models/medicine_chest.dart';
import '../theme/widzew_ui.dart';

class MedicineChestScreen extends StatefulWidget {
  final List<MedicineOffer> items;
  final String userName;
  final ValueChanged<MedicineOffer> onAdd;

  const MedicineChestScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<MedicineChestScreen> createState() => _MedicineChestScreenState();
}

class _MedicineChestScreenState extends State<MedicineChestScreen> {
  late List<MedicineOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<MedicineOffer>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _MedDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apteczki i data ważności')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.medical_services_outlined),
        label: const Text('Opakowanie zamknięte'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Tylko nienaruszone, fabrycznie zamknięte opakowania z ważną datą — wymiana lub oddanie potrzebującym / punktowi. Nie przyjmujemy otwartych blistrów.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.medication_outlined),
                title: Text(item.title),
                subtitle: Text(
                  'Ważność: ${item.expiry} · ${item.sealed ? 'Zamknięte' : 'Otwarte — nie oddawać'}\n${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _MedDialog extends StatefulWidget {
  final String userName;

  const _MedDialog({required this.userName});

  @override
  State<_MedDialog> createState() => _MedDialogState();
}

class _MedDialogState extends State<_MedDialog> {
  final _title = TextEditingController();
  final _expiry = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _expiry.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Apteczka sąsiedzka'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(
                labelText: 'Co (opakowanie zamknięte)',
              ),
            ),
            TextField(
              controller: _expiry,
              decoration: const InputDecoration(labelText: 'Data ważności'),
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
              MedicineOffer(
                id: 'md-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? 'Opakowanie zamknięte'
                    : _title.text.trim(),
                expiry: _expiry.text.trim().isEmpty
                    ? 'data na opakowaniu'
                    : _expiry.text.trim(),
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
