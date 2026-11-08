import 'package:flutter/material.dart';

import '../models/sport_kit.dart';

class SportKitScreen extends StatefulWidget {
  final List<SportKitOffer> items;
  final String userName;
  final ValueChanged<SportKitOffer> onAdd;

  const SportKitScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<SportKitScreen> createState() => _SportKitScreenState();
}

class _SportKitScreenState extends State<SportKitScreen> {
  late List<SportKitOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<SportKitOffer>(
      context: context,
      builder: (_) => _KitDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stroje sportowe dzieci')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.sports_soccer_outlined),
        label: const Text('Oddaję strój'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Stroje na WF, korki i ochraniacze — dzieci szybko z nich wyrastają.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.sports_soccer_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.size}\n${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _KitDialog extends StatefulWidget {
  final String userName;

  const _KitDialog({required this.userName});

  @override
  State<_KitDialog> createState() => _KitDialogState();
}

class _KitDialogState extends State<_KitDialog> {
  var _kind = SportKitKind.peKit;
  final _title = TextEditingController();
  final _size = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _size.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Strój sportowy'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<SportKitKind>(
            initialValue: _kind,
            items: [
              for (final kind in SportKitKind.values)
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
          TextField(
            controller: _size,
            decoration: const InputDecoration(labelText: 'Rozmiar'),
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
              SportKitOffer(
                id: 'sk-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Strój sportowy'
                    : _title.text.trim(),
                size: _size.text.trim().isEmpty ? 'do uzgodnienia' : _size.text.trim(),
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
