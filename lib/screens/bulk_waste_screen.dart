import 'package:flutter/material.dart';

import '../models/bulk_waste.dart';
import '../theme/widzew_ui.dart';

class BulkWasteScreen extends StatefulWidget {
  final List<BulkWasteReport> items;
  final String userName;
  final ValueChanged<BulkWasteReport> onAdd;

  const BulkWasteScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<BulkWasteScreen> createState() => _BulkWasteScreenState();
}

class _BulkWasteScreenState extends State<BulkWasteScreen> {
  late List<BulkWasteReport> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<BulkWasteReport>(
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
      appBar: AppBar(title: const Text('Gabaryty i stare meble')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.chair_outlined),
        label: const Text('Zgłoś gabaryt'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Wystawione gabaryty na osiedlu i harmonogram odbioru MPO Łódź (zwykle pierwszy wtorek miesiąca).',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.delete_outline),
                title: Text(item.item),
                subtitle: Text(
                  '${item.place}\n${item.pickupLabel} · ${item.authorName}',
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
  final _item = TextEditingController();
  final _place = TextEditingController();

  @override
  void dispose() {
    _item.dispose();
    _place.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Gabaryt'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _item,
              decoration: const InputDecoration(labelText: 'Co wystawiono?'),
            ),
            TextField(
              controller: _place,
              decoration: const InputDecoration(labelText: 'Gdzie'),
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
              BulkWasteReport(
                id: 'bw-${DateTime.now().millisecondsSinceEpoch}',
                item: _item.text.trim().isEmpty
                    ? 'Gabaryt przy śmietniku'
                    : _item.text.trim(),
                place: _place.text.trim().isEmpty
                    ? 'Widzew'
                    : _place.text.trim(),
                pickupLabel: 'Odbiór MPO Łódź — wg harmonogramu osiedla',
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
