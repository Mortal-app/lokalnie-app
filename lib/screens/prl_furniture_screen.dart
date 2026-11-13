import 'package:flutter/material.dart';

import '../models/prl_furniture.dart';
import '../theme/widzew_ui.dart';

class PrlFurnitureScreen extends StatefulWidget {
  final List<PrlFurniturePost> items;
  final String userName;
  final ValueChanged<PrlFurniturePost> onAdd;

  const PrlFurnitureScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<PrlFurnitureScreen> createState() => _PrlFurnitureScreenState();
}

class _PrlFurnitureScreenState extends State<PrlFurnitureScreen> {
  late List<PrlFurniturePost> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<PrlFurniturePost>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _PrlDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Renowacja mebli PRL')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.chair_outlined),
        label: const Text('Porada / mebel'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Fotele 366, komody, patyczaki — tapicerka i lakier. Nie wyrzucaj, odnów.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.weekend_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label}\n${item.tip} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _PrlDialog extends StatefulWidget {
  final String userName;

  const _PrlDialog({required this.userName});

  @override
  State<_PrlDialog> createState() => _PrlDialogState();
}

class _PrlDialogState extends State<_PrlDialog> {
  final _title = TextEditingController();
  final _tip = TextEditingController();
  var _kind = PrlPieceKind.armchair366;

  @override
  void dispose() {
    _title.dispose();
    _tip.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Meble PRL'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<PrlPieceKind>(
              initialValue: _kind,
              items: [
                for (final kind in PrlPieceKind.values)
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
              controller: _tip,
              decoration: const InputDecoration(labelText: 'Porada (tapicerka / lakier)'),
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
              PrlFurniturePost(
                id: 'prl-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                tip: _tip.text.trim().isEmpty
                    ? 'Szlif, podkład, cienki lakier.'
                    : _tip.text.trim(),
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
