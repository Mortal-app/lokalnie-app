import 'package:flutter/material.dart';

import '../models/jar_swap.dart';
import '../theme/widzew_ui.dart';

class JarSwapScreen extends StatefulWidget {
  final List<JarSwapOffer> items;
  final String userName;
  final ValueChanged<JarSwapOffer> onAdd;

  const JarSwapScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<JarSwapScreen> createState() => _JarSwapScreenState();
}

class _JarSwapScreenState extends State<JarSwapScreen> {
  late List<JarSwapOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<JarSwapOffer>(
      context: context,
      barrierDismissible: true,
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
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.inventory_2_outlined),
        label: const Text('Wymiana słoików'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Dam puste słoiki po konfiturach za słoik domowego dżemu lub kompotu.',
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
  final _title = TextEditingController();
  var _kind = JarSwapKind.empty;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Słoiki / przetwory'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<JarSwapKind>(
              initialValue: _kind,
              items: [
                for (final kind in JarSwapKind.values)
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
              JarSwapOffer(
                id: 'js-${DateTime.now().millisecondsSinceEpoch}',
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
