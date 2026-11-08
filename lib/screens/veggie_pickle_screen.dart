import 'package:flutter/material.dart';

import '../models/veggie_pickle.dart';

class VeggiePickleScreen extends StatefulWidget {
  final List<VeggiePickleRecipe> items;
  final String userName;
  final ValueChanged<VeggiePickleRecipe> onAdd;

  const VeggiePickleScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<VeggiePickleScreen> createState() => _VeggiePickleScreenState();
}

class _VeggiePickleScreenState extends State<VeggiePickleScreen> {
  late List<VeggiePickleRecipe> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<VeggiePickleRecipe>(
      context: context,
      builder: (_) => _PickleDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kiszonki warzywne')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.kitchen_outlined),
        label: const Text('Przepis'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Kiszone kalafiory, rzodkiewki, kimchi oraz wymiana solanek i starterów fermentacji mlekowej.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.kitchen_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label}\n${item.body} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _PickleDialog extends StatefulWidget {
  final String userName;

  const _PickleDialog({required this.userName});

  @override
  State<_PickleDialog> createState() => _PickleDialogState();
}

class _PickleDialogState extends State<_PickleDialog> {
  var _kind = PickleKind.cauliflower;
  final _title = TextEditingController();
  final _body = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Kiszonka / starter'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<PickleKind>(
            initialValue: _kind,
            items: [
              for (final kind in PickleKind.values)
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
          TextField(
            controller: _body,
            decoration: const InputDecoration(labelText: 'Przepis'),
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
              VeggiePickleRecipe(
                id: 'vp-${DateTime.now().millisecondsSinceEpoch}',
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
