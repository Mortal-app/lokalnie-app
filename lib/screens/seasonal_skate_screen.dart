import 'package:flutter/material.dart';

import '../models/seasonal_skate.dart';

class SeasonalSkateScreen extends StatefulWidget {
  final List<SeasonalSkateOffer> items;
  final String userName;
  final ValueChanged<SeasonalSkateOffer> onAdd;

  const SeasonalSkateScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<SeasonalSkateScreen> createState() => _SeasonalSkateScreenState();
}

class _SeasonalSkateScreenState extends State<SeasonalSkateScreen> {
  late List<SeasonalSkateOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<SeasonalSkateOffer>(
      context: context,
      builder: (_) => _SkateDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rolki, łyżwy i kaski')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.sports_outlined),
        label: const Text('Oddaję'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Łyżwy hokejowe, wrotki, rolki i kaski, z których wyrastają dzieci na osiedlu.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.sports_outlined),
                title: Text(item.title),
                subtitle: Text('${item.kind.label} · ${item.authorName}'),
              ),
            ),
        ],
      ),
    );
  }
}

class _SkateDialog extends StatefulWidget {
  final String userName;

  const _SkateDialog({required this.userName});

  @override
  State<_SkateDialog> createState() => _SkateDialogState();
}

class _SkateDialogState extends State<_SkateDialog> {
  var _kind = SkateKind.inline;
  final _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sprzęt sezonowy'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<SkateKind>(
            initialValue: _kind,
            items: [
              for (final kind in SkateKind.values)
                DropdownMenuItem(value: kind, child: Text(kind.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _kind = value);
            },
          ),
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Opis / rozmiar'),
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
              SeasonalSkateOffer(
                id: 'ss-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Sprzęt sezonowy'
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
