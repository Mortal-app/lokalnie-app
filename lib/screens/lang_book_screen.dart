import 'package:flutter/material.dart';

import '../models/lang_book.dart';

class LangBookScreen extends StatefulWidget {
  final List<LangBookOffer> items;
  final String userName;
  final ValueChanged<LangBookOffer> onAdd;

  const LangBookScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<LangBookScreen> createState() => _LangBookScreenState();
}

class _LangBookScreenState extends State<LangBookScreen> {
  late List<LangBookOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<LangBookOffer>(
      context: context,
      builder: (_) => _BookDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Książki obcojęzyczne')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.menu_book_outlined),
        label: const Text('Podręcznik'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Literatura EN / DE / IT i słowniki dla uczniów i studentów z osiedla.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.menu_book_outlined),
                title: Text(item.title),
                subtitle: Text('${item.kind.label} · ${item.authorName}'),
              ),
            ),
        ],
      ),
    );
  }
}

class _BookDialog extends StatefulWidget {
  final String userName;

  const _BookDialog({required this.userName});

  @override
  State<_BookDialog> createState() => _BookDialogState();
}

class _BookDialogState extends State<_BookDialog> {
  var _kind = LangBookKind.english;
  final _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Książka / słownik'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<LangBookKind>(
            initialValue: _kind,
            items: [
              for (final kind in LangBookKind.values)
                DropdownMenuItem(value: kind, child: Text(kind.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _kind = value);
            },
          ),
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Tytuł'),
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
              LangBookOffer(
                id: 'lb-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Podręcznik językowy'
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
