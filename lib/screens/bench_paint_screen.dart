import 'package:flutter/material.dart';

import '../models/bench_paint.dart';

class BenchPaintScreen extends StatefulWidget {
  final List<BenchPaintSlot> items;
  final String userName;
  final ValueChanged<BenchPaintSlot> onAdd;

  const BenchPaintScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<BenchPaintScreen> createState() => _BenchPaintScreenState();
}

class _BenchPaintScreenState extends State<BenchPaintScreen> {
  late List<BenchPaintSlot> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<BenchPaintSlot>(
      context: context,
      builder: (_) => _BenchDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ławki, altany i trzepaki')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.format_paint_outlined),
        label: const Text('Termin'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Społeczne malowanie ławek parkowych, altan i trzepaków — mała architektura osiedla.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.format_paint_outlined),
                title: Text(item.place),
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

class _BenchDialog extends StatefulWidget {
  final String userName;

  const _BenchDialog({required this.userName});

  @override
  State<_BenchDialog> createState() => _BenchDialogState();
}

class _BenchDialogState extends State<_BenchDialog> {
  final _place = TextEditingController();
  final _when = TextEditingController();

  @override
  void dispose() {
    _place.dispose();
    _when.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Renowacja'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _place,
            decoration: const InputDecoration(labelText: 'Miejsce'),
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
              BenchPaintSlot(
                id: 'bp-${DateTime.now().millisecondsSinceEpoch}',
                place: _place.text.trim().isEmpty
                    ? 'Skwer osiedlowy'
                    : _place.text.trim(),
                whenText: _when.text.trim().isEmpty
                    ? 'Weekend rano'
                    : _when.text.trim(),
                note: 'Farba i pędzle — przynosimy z domu.',
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
