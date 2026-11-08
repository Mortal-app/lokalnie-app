import 'package:flutter/material.dart';

import '../models/neighbor_recipe.dart';

class RecipeClubScreen extends StatefulWidget {
  final List<NeighborRecipe> items;
  final String userName;
  final ValueChanged<NeighborRecipe> onAdd;

  const RecipeClubScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<RecipeClubScreen> createState() => _RecipeClubScreenState();
}

class _RecipeClubScreenState extends State<RecipeClubScreen> {
  late List<NeighborRecipe> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<NeighborRecipe>(
      context: context,
      builder: (_) => _RecipeDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Klub książki i przepisów')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.menu_book_outlined),
        label: const Text('Dodaj przepis'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Sprawdzone przepisy sąsiadów: obiady, przetwory i ciasta.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.cake_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.authorName}\n${item.body}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _RecipeDialog extends StatefulWidget {
  final String userName;

  const _RecipeDialog({required this.userName});

  @override
  State<_RecipeDialog> createState() => _RecipeDialogState();
}

class _RecipeDialogState extends State<_RecipeDialog> {
  final _title = TextEditingController();
  final _body = TextEditingController();
  var _kind = RecipeKind.cake;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Przepis sąsiedzki'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<RecipeKind>(
              initialValue: _kind,
              items: [
                for (final kind in RecipeKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Nazwa'),
            ),
            TextField(
              controller: _body,
              decoration: const InputDecoration(labelText: 'Przepis'),
              maxLines: 3,
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
              NeighborRecipe(
                id: 'rec-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                body: _body.text.trim(),
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
