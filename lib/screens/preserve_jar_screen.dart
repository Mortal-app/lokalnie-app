import 'package:flutter/material.dart';

import '../models/preserve_jar.dart';

class PreserveJarScreen extends StatefulWidget {
  final List<PreserveJarOffer> items;
  final String userName;
  final ValueChanged<PreserveJarOffer> onAdd;

  const PreserveJarScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<PreserveJarScreen> createState() => _PreserveJarScreenState();
}

class _PreserveJarScreenState extends State<PreserveJarScreen> {
  late List<PreserveJarOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<PreserveJarOffer>(
      context: context,
      builder: (_) => _JarDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Przetwory i słoiki')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.kitchen_outlined),
        label: const Text('Ogłoszenie'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Dżemy, ogórki kiszone i zwrot pustych słoików między sąsiadami.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.kitchen_outlined),
                title: Text(item.title),
                subtitle: Text('${item.kind.label} · ${item.authorName}'),
              ),
            ),
        ],
      ),
    );
  }
}

class _JarDialog extends StatefulWidget {
  final String userName;

  const _JarDialog({required this.userName});

  @override
  State<_JarDialog> createState() => _JarDialogState();
}

class _JarDialogState extends State<_JarDialog> {
  var _kind = PreserveKind.jam;
  final _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Przetwory'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<PreserveKind>(
            initialValue: _kind,
            items: [
              for (final kind in PreserveKind.values)
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
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Anuluj'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(
              context,
              PreserveJarOffer(
                id: 'pj-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Wymiana przetworów'
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
