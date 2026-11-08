import 'package:flutter/material.dart';

import '../models/water_pressure.dart';

class WaterPressureScreen extends StatefulWidget {
  final List<WaterPressureReport> items;
  final String userName;
  final ValueChanged<WaterPressureReport> onAdd;

  const WaterPressureScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<WaterPressureScreen> createState() => _WaterPressureScreenState();
}

class _WaterPressureScreenState extends State<WaterPressureScreen> {
  late List<WaterPressureReport> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<WaterPressureReport>(
      context: context,
      builder: (_) => _PressureDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Zgłoszenie ciśnienia przekazane do spółdzielni (lokalnie).'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ciśnienie wody w pionach')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.water_drop_outlined),
        label: const Text('Zgłoś spadek'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Spadki ciśnienia na piętrach — zgłoszenie idzie też jako powiadomienie dla spółdzielni.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.water_drop_outlined),
                title: Text('${item.block} · ${item.floor}'),
                subtitle: Text(
                  '${item.note}\n${item.authorName}${item.notifyCoop ? ' · spółdzielnia' : ''}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _PressureDialog extends StatefulWidget {
  final String userName;

  const _PressureDialog({required this.userName});

  @override
  State<_PressureDialog> createState() => _PressureDialogState();
}

class _PressureDialogState extends State<_PressureDialog> {
  final _block = TextEditingController();
  final _floor = TextEditingController();
  final _note = TextEditingController();

  @override
  void dispose() {
    _block.dispose();
    _floor.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Spadek ciśnienia'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _block,
            decoration: const InputDecoration(labelText: 'Blok / klatka'),
          ),
          TextField(
            controller: _floor,
            decoration: const InputDecoration(labelText: 'Piętro'),
          ),
          TextField(
            controller: _note,
            decoration: const InputDecoration(labelText: 'Opis'),
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
              WaterPressureReport(
                id: 'wp-${DateTime.now().millisecondsSinceEpoch}',
                block: _block.text.trim().isEmpty
                    ? 'Blok na Widzewie'
                    : _block.text.trim(),
                floor: _floor.text.trim().isEmpty
                    ? 'Piętro'
                    : _floor.text.trim(),
                note: _note.text.trim(),
                authorName: widget.userName,
              ),
            );
          },
          child: const Text('Zgłoś'),
        ),
      ],
    );
  }
}
