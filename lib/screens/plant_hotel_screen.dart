import 'package:flutter/material.dart';

import '../models/plant_hotel.dart';
import '../theme/widzew_ui.dart';

class PlantHotelScreen extends StatefulWidget {
  final List<PlantHotelStay> items;
  final String userName;
  final ValueChanged<PlantHotelStay> onAdd;

  const PlantHotelScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<PlantHotelScreen> createState() => _PlantHotelScreenState();
}

class _PlantHotelScreenState extends State<PlantHotelScreen> {
  late List<PlantHotelStay> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<PlantHotelStay>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _HotelDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hotel dla kwiatów')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.local_florist_outlined),
        label: const Text('Opieka'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Tymczasowa opieka nad kwiatami doniczkowymi na czas urlopu sąsiadów.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.local_florist_outlined),
                title: Text(item.plantName),
                subtitle: Text(
                  '${item.seekingHost ? 'Szukam opieki' : 'Przyjmę kwiaty'} · ${item.whenText}\n${item.note} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _HotelDialog extends StatefulWidget {
  final String userName;

  const _HotelDialog({required this.userName});

  @override
  State<_HotelDialog> createState() => _HotelDialogState();
}

class _HotelDialogState extends State<_HotelDialog> {
  var _seeking = true;
  final _plant = TextEditingController();
  final _note = TextEditingController();

  @override
  void dispose() {
    _plant.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Kwiaty na urlop'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Szukam opieki (wyłącz: przyjmę kwiaty)'),
            value: _seeking,
            onChanged: (value) => setState(() => _seeking = value),
          ),
          TextField(
            controller: _plant,
            decoration: const InputDecoration(labelText: 'Rośliny'),
          ),
          TextField(
            controller: _note,
            decoration: const InputDecoration(labelText: 'Uwagi'),
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
              PlantHotelStay(
                id: 'ph-${DateTime.now().millisecondsSinceEpoch}',
                plantName: _plant.text.trim().isEmpty
                    ? 'Kwiaty doniczkowe'
                    : _plant.text.trim(),
                whenText: 'Urlop',
                note: _note.text.trim(),
                authorName: widget.userName,
                seekingHost: _seeking,
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
