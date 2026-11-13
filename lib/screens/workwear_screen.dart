import 'package:flutter/material.dart';

import '../models/workwear.dart';
import '../theme/widzew_ui.dart';

class WorkwearScreen extends StatefulWidget {
  final List<WorkwearItem> items;
  final String userName;
  final ValueChanged<WorkwearItem> onAdd;

  const WorkwearScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<WorkwearScreen> createState() => _WorkwearScreenState();
}

class _WorkwearScreenState extends State<WorkwearScreen> {
  late List<WorkwearItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<WorkwearItem>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _WearDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giełda odzieży roboczej i BHP')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.construction_outlined),
        label: const Text('Oddaj / szukam'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Ubrania robocze, buty z metalowym noskiem i kaski po budowach i remontach.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.engineering_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · rozmiar ${item.size}\n${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _WearDialog extends StatefulWidget {
  final String userName;

  const _WearDialog({required this.userName});

  @override
  State<_WearDialog> createState() => _WearDialogState();
}

class _WearDialogState extends State<_WearDialog> {
  final _title = TextEditingController();
  final _size = TextEditingController();
  var _kind = WorkwearKind.clothes;

  @override
  void dispose() {
    _title.dispose();
    _size.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('BHP / odzież'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<WorkwearKind>(
              initialValue: _kind,
              items: [
                for (final kind in WorkwearKind.values)
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
              WorkwearItem(
                id: 'ww-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                size: _size.text.trim().isEmpty ? 'uniwersalny' : _size.text.trim(),
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
