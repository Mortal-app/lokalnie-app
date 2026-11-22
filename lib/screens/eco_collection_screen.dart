import 'package:flutter/material.dart';

import '../models/eco_collection.dart';
import '../theme/widzew_ui.dart';

class EcoCollectionScreen extends StatefulWidget {
  final List<EcoCollectionDrive> items;
  final ValueChanged<EcoCollectionDrive> onAdd;
  final void Function(String id, double kg) onAddKg;

  const EcoCollectionScreen({
    super.key,
    required this.items,
    required this.onAdd,
    required this.onAddKg,
  });

  @override
  State<EcoCollectionScreen> createState() => _EcoCollectionScreenState();
}

class _EcoCollectionScreenState extends State<EcoCollectionScreen> {
  late List<EcoCollectionDrive> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<EcoCollectionDrive>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _DriveDialog(),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  void _addKg(EcoCollectionDrive drive) {
    setState(() {
      _items = _items
          .map((item) => item.id == drive.id ? item.addKg(1) : item)
          .toList();
    });
    widget.onAddKg(drive.id, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eko-zbiórka surowców')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.recycling),
        label: const Text('Nowa zbiórka'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Makulatura, elektrośmieci i puszki — licznik kilogramów dla bloku.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.blockName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text('${item.material.label} · ${item.whenLabel}'),
                    Text(item.place),
                    const SizedBox(height: 6),
                    Text(
                      'Zebrano: ${item.kgCollected.toStringAsFixed(1)} kg',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _addKg(item),
                        child: const Text('+1 kg'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DriveDialog extends StatefulWidget {
  const _DriveDialog();

  @override
  State<_DriveDialog> createState() => _DriveDialogState();
}

class _DriveDialogState extends State<_DriveDialog> {
  final _block = TextEditingController();
  final _place = TextEditingController();
  var _material = EcoMaterial.paper;

  @override
  void dispose() {
    _block.dispose();
    _place.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Akcja zbiórki'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<EcoMaterial>(
              initialValue: _material,
              items: [
                for (final kind in EcoMaterial.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _material = value);
              },
            ),
            TextField(
              controller: _block,
              decoration: const InputDecoration(labelText: 'Blok'),
            ),
            TextField(
              controller: _place,
              decoration: const InputDecoration(labelText: 'Miejsce'),
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
              EcoCollectionDrive(
                id: 'eco-${DateTime.now().millisecondsSinceEpoch}',
                blockName: _block.text.trim().isEmpty
                    ? 'Blok w Twojej okolicy'
                    : _block.text.trim(),
                material: _material,
                whenLabel: 'Wkrótce',
                kgCollected: 0,
                place: _place.text.trim().isEmpty
                    ? 'Przy śmietniku'
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
