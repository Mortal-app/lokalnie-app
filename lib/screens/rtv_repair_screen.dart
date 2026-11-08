import 'package:flutter/material.dart';

import '../models/rtv_repair.dart';

class RtvRepairScreen extends StatefulWidget {
  final List<RtvRepairSession> items;
  final String userName;
  final ValueChanged<RtvRepairSession> onAdd;

  const RtvRepairScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<RtvRepairScreen> createState() => _RtvRepairScreenState();
}

class _RtvRepairScreenState extends State<RtvRepairScreen> {
  late List<RtvRepairSession> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<RtvRepairSession>(
      context: context,
      builder: (_) => _RtvDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Majsterkowanie RTV')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.speaker_outlined),
        label: const Text('Spot lutowania'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Wymiana wiedzy i wspólna naprawa wzmacniaczy, głośników i odbiorników RTV.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.speaker_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.whenText} · ${item.authorName}',
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RtvDialog extends StatefulWidget {
  final String userName;

  const _RtvDialog({required this.userName});

  @override
  State<_RtvDialog> createState() => _RtvDialogState();
}

class _RtvDialogState extends State<_RtvDialog> {
  var _kind = RtvKind.amp;
  final _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Spot RTV'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<RtvKind>(
            initialValue: _kind,
            items: [
              for (final kind in RtvKind.values)
                DropdownMenuItem(value: kind, child: Text(kind.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _kind = value);
            },
          ),
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Temat'),
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
              RtvRepairSession(
                id: 'rtv-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Wspólne lutowanie'
                    : _title.text.trim(),
                whenText: 'Do uzgodnienia',
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
