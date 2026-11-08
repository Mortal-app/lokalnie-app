import 'package:flutter/material.dart';

import '../models/block_tool.dart';

class BlockToolScreen extends StatefulWidget {
  final List<BlockToolItem> items;
  final String userName;
  final ValueChanged<BlockToolItem> onAdd;
  final ValueChanged<BlockToolItem> onToggle;

  const BlockToolScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
    required this.onToggle,
  });

  @override
  State<BlockToolScreen> createState() => _BlockToolScreenState();
}

class _BlockToolScreenState extends State<BlockToolScreen> {
  late List<BlockToolItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<BlockToolItem>(
      context: context,
      builder: (_) => _ToolDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  void _toggle(BlockToolItem item) {
    final next = item.copyWith(available: !item.available);
    setState(() {
      _items = [
        for (final row in _items)
          if (row.id == item.id) next else row,
      ];
    });
    widget.onToggle(next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inwentarz narzędzi blokowych')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.add),
        label: const Text('Narzędzie ze składek'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Myjki, zagęszczarki i wiertarki udarowe kupione ze składek klatkowych — wypożycz i oddaj.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.handyman_outlined),
                title: Text(item.kind.label),
                subtitle: Text(
                  '${item.staircase}\n${item.note} · ${item.available ? 'Dostępne' : 'Wypożyczone'}',
                ),
                isThreeLine: true,
                trailing: TextButton(
                  onPressed: () => _toggle(item),
                  child: Text(item.available ? 'Wypożycz' : 'Oddaj'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ToolDialog extends StatefulWidget {
  final String userName;

  const _ToolDialog({required this.userName});

  @override
  State<_ToolDialog> createState() => _ToolDialogState();
}

class _ToolDialogState extends State<_ToolDialog> {
  var _kind = BlockToolKind.washer;
  final _place = TextEditingController();

  @override
  void dispose() {
    _place.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Narzędzie klatkowe'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<BlockToolKind>(
            initialValue: _kind,
            items: [
              for (final kind in BlockToolKind.values)
                DropdownMenuItem(value: kind, child: Text(kind.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _kind = value);
            },
          ),
          TextField(
            controller: _place,
            decoration: const InputDecoration(labelText: 'Klatka'),
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
              BlockToolItem(
                id: 'bt-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                staircase: _place.text.trim().isEmpty
                    ? 'Klatka osiedlowa'
                    : _place.text.trim(),
                available: true,
                note: 'Ze składek klatkowych · ${widget.userName}',
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
