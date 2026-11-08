import 'package:flutter/material.dart';

import '../models/trailer_share.dart';

class TrailerShareScreen extends StatefulWidget {
  final List<TrailerShare> items;
  final ValueChanged<TrailerShare> onAdd;
  final ValueChanged<String> onBorrow;

  const TrailerShareScreen({
    super.key,
    required this.items,
    required this.onAdd,
    required this.onBorrow,
  });

  @override
  State<TrailerShareScreen> createState() => _TrailerShareScreenState();
}

class _TrailerShareScreenState extends State<TrailerShareScreen> {
  late List<TrailerShare> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<TrailerShare>(
      context: context,
      builder: (_) => const _TrailDialog(),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  void _borrow(TrailerShare item) {
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
      appBar: AppBar(title: const Text('Przyczepki, boxy i lawety')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.airport_shuttle_outlined),
        label: const Text('Udostępniam'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Przyczepka, box dachowy i platforma rowerowa na hak — pożycz od sąsiada.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.local_shipping_outlined),
                title: Text(item.title),
                subtitle: Text('${item.kind.label} · ${item.owner}'),
                trailing: TextButton(
                  onPressed: item.borrowed ? null : () => _borrow(item),
                  child: Text(item.borrowed ? 'Zarezerwowano' : 'Pożycz'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TrailDialog extends StatefulWidget {
  const _TrailDialog();

  @override
  State<_TrailDialog> createState() => _TrailDialogState();
}

class _TrailDialogState extends State<_TrailDialog> {
  final _title = TextEditingController();
  var _kind = TrailerKind.trailer;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Przyczepka / box'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<TrailerKind>(
              initialValue: _kind,
              items: [
                for (final kind in TrailerKind.values)
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
              TrailerShare(
                id: 'ts-${DateTime.now().millisecondsSinceEpoch}',
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
