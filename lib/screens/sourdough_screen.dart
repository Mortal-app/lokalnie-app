import 'package:flutter/material.dart';

import '../models/sourdough.dart';
import '../theme/widzew_ui.dart';

class SourdoughScreen extends StatefulWidget {
  final List<SourdoughRecipe> items;
  final String userName;
  final ValueChanged<SourdoughRecipe> onAdd;

  const SourdoughScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<SourdoughScreen> createState() => _SourdoughScreenState();
}

class _SourdoughScreenState extends State<SourdoughScreen> {
  late List<SourdoughRecipe> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<SourdoughRecipe>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _BreadDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Domowy chleb i zakwas')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.bakery_dining_outlined),
        label: const Text('Przepis'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Zakwas żytni, wypiek w piekarniku i wymiana starterów między sąsiadami.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.bakery_dining_outlined),
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

class _BreadDialog extends StatefulWidget {
  final String userName;

  const _BreadDialog({required this.userName});

  @override
  State<_BreadDialog> createState() => _BreadDialogState();
}

class _BreadDialogState extends State<_BreadDialog> {
  var _kind = BreadKind.starter;
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
      title: const Text('Chleb / zakwas'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<BreadKind>(
            initialValue: _kind,
            items: [
              for (final kind in BreadKind.values)
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
              SourdoughRecipe(
                id: 'sd-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Wypiek chleba'
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
