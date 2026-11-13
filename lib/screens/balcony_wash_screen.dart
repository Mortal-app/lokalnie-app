import 'package:flutter/material.dart';

import '../models/balcony_wash.dart';
import '../theme/widzew_ui.dart';

class BalconyWashScreen extends StatefulWidget {
  final List<BalconyWashSlot> items;
  final String userName;
  final ValueChanged<BalconyWashSlot> onAdd;

  const BalconyWashScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<BalconyWashScreen> createState() => _BalconyWashScreenState();
}

class _BalconyWashScreenState extends State<BalconyWashScreen> {
  late List<BalconyWashSlot> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<BalconyWashSlot>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _WashDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mycie balkonów i elewacji')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.deck_outlined),
        label: const Text('Termin'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Wspólne porządki loggii, szyb od zewnątrz i elewacji na wyższych piętrach.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.deck_outlined),
                title: Text('${item.block} · ${item.floor}'),
                subtitle: Text(
                  '${item.whenText}\n${item.note} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _WashDialog extends StatefulWidget {
  final String userName;

  const _WashDialog({required this.userName});

  @override
  State<_WashDialog> createState() => _WashDialogState();
}

class _WashDialogState extends State<_WashDialog> {
  final _block = TextEditingController();
  final _floor = TextEditingController();
  final _when = TextEditingController();

  @override
  void dispose() {
    _block.dispose();
    _floor.dispose();
    _when.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Mycie loggii'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _block,
            decoration: const InputDecoration(labelText: 'Blok / klatka'),
          ),
          TextField(
            controller: _floor,
            decoration: const InputDecoration(labelText: 'Piętra'),
          ),
          TextField(
            controller: _when,
            decoration: const InputDecoration(labelText: 'Termin'),
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
              BalconyWashSlot(
                id: 'bw-${DateTime.now().millisecondsSinceEpoch}',
                block: _block.text.trim().isEmpty
                    ? 'Blok osiedlowy'
                    : _block.text.trim(),
                floor: _floor.text.trim().isEmpty
                    ? 'Wyższe piętra'
                    : _floor.text.trim(),
                whenText: _when.text.trim().isEmpty
                    ? 'Weekend rano'
                    : _when.text.trim(),
                note: 'Wiadro, ściągaczka, asekuracja.',
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
