import 'package:flutter/material.dart';

import '../models/lego_swap.dart';

class LegoSwapScreen extends StatefulWidget {
  final List<LegoSwapItem> items;
  final String userName;
  final ValueChanged<LegoSwapItem> onAdd;

  const LegoSwapScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<LegoSwapScreen> createState() => _LegoSwapScreenState();
}

class _LegoSwapScreenState extends State<LegoSwapScreen> {
  late List<LegoSwapItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<LegoSwapItem>(
      context: context,
      builder: (_) => _LegoDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LEGO i zabawki edukacyjne')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.extension_outlined),
        label: const Text('Wymiana'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Kompletne zestawy klocków, gry planszowe dla dzieci i zabawki dydaktyczne.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.child_care_outlined),
                title: Text(item.title),
                subtitle: Text('${item.kind.label} · ${item.authorName}'),
              ),
            ),
        ],
      ),
    );
  }
}

class _LegoDialog extends StatefulWidget {
  final String userName;

  const _LegoDialog({required this.userName});

  @override
  State<_LegoDialog> createState() => _LegoDialogState();
}

class _LegoDialogState extends State<_LegoDialog> {
  final _title = TextEditingController();
  var _kind = KidsToyKind.lego;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zabawki'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<KidsToyKind>(
              initialValue: _kind,
              items: [
                for (final kind in KidsToyKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Opis zestawu'),
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
              LegoSwapItem(
                id: 'lg-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
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
