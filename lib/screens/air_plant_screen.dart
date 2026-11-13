import 'package:flutter/material.dart';

import '../models/air_plant.dart';
import '../theme/widzew_ui.dart';

class AirPlantScreen extends StatefulWidget {
  final List<AirPlantGuide> items;
  final String userName;
  final ValueChanged<AirPlantGuide> onAdd;

  const AirPlantScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<AirPlantScreen> createState() => _AirPlantScreenState();
}

class _AirPlantScreenState extends State<AirPlantScreen> {
  late List<AirPlantGuide> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<AirPlantGuide>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _PlantDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rośliny oczyszczające powietrze')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.local_florist_outlined),
        label: const Text('Roślina'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Katalog kwiatów doniczkowych do bloków z wielkiej płyty — skrzydłokwiat, sansewieria i pielęgnacja.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.local_florist_outlined),
                title: Text(item.name),
                subtitle: Text('${item.care} · ${item.authorName}'),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _PlantDialog extends StatefulWidget {
  final String userName;

  const _PlantDialog({required this.userName});

  @override
  State<_PlantDialog> createState() => _PlantDialogState();
}

class _PlantDialogState extends State<_PlantDialog> {
  final _name = TextEditingController();
  final _care = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _care.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Roślina doniczkowa'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Nazwa'),
          ),
          TextField(
            controller: _care,
            decoration: const InputDecoration(labelText: 'Pielęgnacja'),
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
              AirPlantGuide(
                id: 'ap-${DateTime.now().millisecondsSinceEpoch}',
                name: _name.text.trim().isEmpty
                    ? 'Kwiat doniczkowy'
                    : _name.text.trim(),
                care: _care.text.trim().isEmpty
                    ? 'Umiarkowane podlewanie.'
                    : _care.text.trim(),
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
