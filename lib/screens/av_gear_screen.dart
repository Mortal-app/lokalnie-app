import 'package:flutter/material.dart';

import '../models/av_gear.dart';

class AvGearScreen extends StatefulWidget {
  final List<AvGearItem> items;
  final ValueChanged<AvGearItem> onAdd;
  final ValueChanged<String> onBorrow;

  const AvGearScreen({
    super.key,
    required this.items,
    required this.onAdd,
    required this.onBorrow,
  });

  @override
  State<AvGearScreen> createState() => _AvGearScreenState();
}

class _AvGearScreenState extends State<AvGearScreen> {
  late List<AvGearItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<AvGearItem>(
      context: context,
      builder: (_) => const _AvDialog(),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  void _borrow(AvGearItem item) {
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
      appBar: AppBar(title: const Text('Sprzęt AV i podcasty')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.mic_none_outlined),
        label: const Text('Udostępniam sprzęt'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Mikrofony pojemnościowe, statywy, ring-light i kamery do projektów amatorskich.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.videocam_outlined),
                title: Text(item.title),
                subtitle: Text('${item.kind.label} · ${item.owner}'),
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

class _AvDialog extends StatefulWidget {
  const _AvDialog();

  @override
  State<_AvDialog> createState() => _AvDialogState();
}

class _AvDialogState extends State<_AvDialog> {
  final _title = TextEditingController();
  var _kind = AvGearKind.mic;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sprzęt AV'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<AvGearKind>(
              initialValue: _kind,
              items: [
                for (final kind in AvGearKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Opis'),
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
              AvGearItem(
                id: 'av-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                owner: 'Sąsiad',
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
