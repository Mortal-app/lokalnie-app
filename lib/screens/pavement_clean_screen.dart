import 'package:flutter/material.dart';

import '../models/pavement_clean.dart';

class PavementCleanScreen extends StatefulWidget {
  final List<PavementCleanSlot> items;
  final String userName;
  final ValueChanged<PavementCleanSlot> onAdd;

  const PavementCleanScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<PavementCleanScreen> createState() => _PavementCleanScreenState();
}

class _PavementCleanScreenState extends State<PavementCleanScreen> {
  late List<PavementCleanSlot> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<PavementCleanSlot>(
      context: context,
      builder: (_) => _PavDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kostka i chodniki')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.cleaning_services_outlined),
        label: const Text('Termin'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Wspólne porządki kostki, wejść do klatek i podjazdów dla wózków.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.cleaning_services_outlined),
                title: Text(item.block),
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

class _PavDialog extends StatefulWidget {
  final String userName;

  const _PavDialog({required this.userName});

  @override
  State<_PavDialog> createState() => _PavDialogState();
}

class _PavDialogState extends State<_PavDialog> {
  final _block = TextEditingController();
  final _when = TextEditingController();

  @override
  void dispose() {
    _block.dispose();
    _when.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Porządki przy klatce'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _block,
            decoration: const InputDecoration(labelText: 'Blok / klatka'),
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
              PavementCleanSlot(
                id: 'pv-${DateTime.now().millisecondsSinceEpoch}',
                block: _block.text.trim().isEmpty
                    ? 'Klatka osiedlowa'
                    : _block.text.trim(),
                whenText: _when.text.trim().isEmpty
                    ? 'Weekend rano'
                    : _when.text.trim(),
                note: 'Kostka i podjazd dla wózków.',
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
