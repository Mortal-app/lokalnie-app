import 'package:flutter/material.dart';

import '../models/green_waste.dart';
import '../theme/widzew_ui.dart';

class GreenWasteScreen extends StatefulWidget {
  final List<GreenWastePickup> items;
  final String userName;
  final ValueChanged<GreenWastePickup> onAdd;

  const GreenWasteScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<GreenWasteScreen> createState() => _GreenWasteScreenState();
}

class _GreenWasteScreenState extends State<GreenWasteScreen> {
  late List<GreenWastePickup> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<GreenWastePickup>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _WasteDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Odpady zielone i gałęzie')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.park_outlined),
        label: const Text('Zgłoś gałęzie'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Wywoz i zagospodarowanie gałęzi po przycinaniu krzewów i drzewek na działkach oraz wokół bloków.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.eco_outlined),
                title: Text(item.place),
                subtitle: Text(
                  '${item.whenText} · ${item.volume}\n${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _WasteDialog extends StatefulWidget {
  final String userName;

  const _WasteDialog({required this.userName});

  @override
  State<_WasteDialog> createState() => _WasteDialogState();
}

class _WasteDialogState extends State<_WasteDialog> {
  final _place = TextEditingController();
  final _volume = TextEditingController();

  @override
  void dispose() {
    _place.dispose();
    _volume.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Gałęzie do wywozu'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _place,
            decoration: const InputDecoration(labelText: 'Miejsce'),
          ),
          TextField(
            controller: _volume,
            decoration: const InputDecoration(labelText: 'Ilość'),
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
              GreenWastePickup(
                id: 'gw-${DateTime.now().millisecondsSinceEpoch}',
                place: _place.text.trim().isEmpty
                    ? 'Zieleń przy bloku'
                    : _place.text.trim(),
                whenText: 'Do uzgodnienia',
                volume: _volume.text.trim().isEmpty
                    ? 'Gałęzie po cięciu'
                    : _volume.text.trim(),
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
