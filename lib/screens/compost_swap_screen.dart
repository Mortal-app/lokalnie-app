import 'package:flutter/material.dart';

import '../models/compost_swap.dart';
import '../theme/widzew_ui.dart';

class CompostSwapScreen extends StatefulWidget {
  final List<CompostSwap> items;
  final String userName;
  final ValueChanged<CompostSwap> onAdd;

  const CompostSwapScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<CompostSwapScreen> createState() => _CompostSwapScreenState();
}

class _CompostSwapScreenState extends State<CompostSwapScreen> {
  late List<CompostSwap> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<CompostSwap>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _CompDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kompost i bio-odpad')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.eco_outlined),
        label: const Text('Wymiana'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Kompostowniki, dżdżownice kalifornijskie i wiaderka na bio — ogródki i ROD z Widzewa.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.eco_outlined),
                title: Text(item.title),
                subtitle: Text('${item.kind.label} · ${item.garden}\n${item.authorName}'),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _CompDialog extends StatefulWidget {
  final String userName;

  const _CompDialog({required this.userName});

  @override
  State<_CompDialog> createState() => _CompDialogState();
}

class _CompDialogState extends State<_CompDialog> {
  final _title = TextEditingController();
  var _kind = CompostKind.bin;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Kompost / bio'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<CompostKind>(
              initialValue: _kind,
              items: [
                for (final kind in CompostKind.values)
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
              CompostSwap(
                id: 'cs-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                garden: 'ROD im. Władysława Reymonta',
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
