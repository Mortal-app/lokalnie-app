import 'package:flutter/material.dart';

import '../models/filament_share.dart';

class FilamentShareScreen extends StatefulWidget {
  final List<FilamentShareOffer> items;
  final String userName;
  final ValueChanged<FilamentShareOffer> onAdd;

  const FilamentShareScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<FilamentShareScreen> createState() => _FilamentShareScreenState();
}

class _FilamentShareScreenState extends State<FilamentShareScreen> {
  late List<FilamentShareOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<FilamentShareOffer>(
      context: context,
      builder: (_) => _FilDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filament i druk 3D')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.linear_scale),
        label: const Text('Zapas filamentu'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'PLA i PETG na szybkie, awaryjne wydruki części u sąsiadów z drukarką.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.linear_scale),
                title: Text(item.title),
                subtitle: Text('${item.kind.label} · ${item.authorName}'),
              ),
            ),
        ],
      ),
    );
  }
}

class _FilDialog extends StatefulWidget {
  final String userName;

  const _FilDialog({required this.userName});

  @override
  State<_FilDialog> createState() => _FilDialogState();
}

class _FilDialogState extends State<_FilDialog> {
  var _kind = FilamentKind.pla;
  final _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filament'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<FilamentKind>(
            initialValue: _kind,
            items: [
              for (final kind in FilamentKind.values)
                DropdownMenuItem(value: kind, child: Text(kind.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _kind = value);
            },
          ),
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Zapas'),
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
              FilamentShareOffer(
                id: 'fl-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Filament na awaryjny wydruk'
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
