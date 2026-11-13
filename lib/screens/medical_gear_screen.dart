import 'package:flutter/material.dart';

import '../models/medical_gear.dart';
import '../theme/widzew_ui.dart';

class MedicalGearScreen extends StatefulWidget {
  final List<MedicalGearItem> items;
  final ValueChanged<MedicalGearItem> onAdd;
  final ValueChanged<String> onBorrow;

  const MedicalGearScreen({
    super.key,
    required this.items,
    required this.onAdd,
    required this.onBorrow,
  });

  @override
  State<MedicalGearScreen> createState() => _MedicalGearScreenState();
}

class _MedicalGearScreenState extends State<MedicalGearScreen> {
  late List<MedicalGearItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<MedicalGearItem>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _GearDialog(),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  void _borrow(MedicalGearItem item) {
    if (item.borrowed) return;
    setState(() {
      _items = _items
          .map(
            (entry) =>
                entry.id == item.id ? entry.copyWith(borrowed: true) : entry,
          )
          .toList();
    });
    widget.onBorrow(item.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sprzęt medyczny i rehab')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.accessible_forward),
        label: const Text('Udostępniam sprzęt'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Kule łokciowe, wózek i łóżko rehabilitacyjne — bezpłatnie od mieszkańców.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.medical_services_outlined),
                title: Text(item.kind.label),
                subtitle: Text('${item.place} · ${item.owner}'),
                trailing: TextButton(
                  onPressed: item.borrowed ? null : () => _borrow(item),
                  child: Text(item.borrowed ? 'Wypożyczono' : 'Wypożycz'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GearDialog extends StatefulWidget {
  const _GearDialog();

  @override
  State<_GearDialog> createState() => _GearDialogState();
}

class _GearDialogState extends State<_GearDialog> {
  final _place = TextEditingController();
  var _kind = MedicalGearKind.crutches;

  @override
  void dispose() {
    _place.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sprzęt do wypożyczenia'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<MedicalGearKind>(
              initialValue: _kind,
              items: [
                for (final kind in MedicalGearKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _place,
              decoration: const InputDecoration(labelText: 'Gdzie odebrać'),
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
              MedicalGearItem(
                id: 'med-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                owner: 'Sąsiad',
                place: _place.text.trim().isEmpty
                    ? 'Widzew'
                    : _place.text.trim(),
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
