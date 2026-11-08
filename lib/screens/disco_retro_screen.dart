import 'package:flutter/material.dart';

import '../models/disco_retro.dart';

class DiscoRetroScreen extends StatefulWidget {
  final List<DiscoRetroPost> items;
  final String userName;
  final ValueChanged<DiscoRetroPost> onAdd;

  const DiscoRetroScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<DiscoRetroScreen> createState() => _DiscoRetroScreenState();
}

class _DiscoRetroScreenState extends State<DiscoRetroScreen> {
  late List<DiscoRetroPost> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<DiscoRetroPost>(
      context: context,
      builder: (_) => _DiscoDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pop i disco 80/90')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.album_outlined),
        label: const Text('Wpis'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Kasety VHS z festiwali, płyty CD i domówki w klimacie retro — osobno od rocka i ambientu.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.album_outlined),
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

class _DiscoDialog extends StatefulWidget {
  final String userName;

  const _DiscoDialog({required this.userName});

  @override
  State<_DiscoDialog> createState() => _DiscoDialogState();
}

class _DiscoDialogState extends State<_DiscoDialog> {
  var _kind = DiscoKind.cd;
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
      title: const Text('Disco / pop'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<DiscoKind>(
            initialValue: _kind,
            items: [
              for (final kind in DiscoKind.values)
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
            decoration: const InputDecoration(labelText: 'Szczegóły'),
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
              DiscoRetroPost(
                id: 'dr-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Wpis retro'
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
