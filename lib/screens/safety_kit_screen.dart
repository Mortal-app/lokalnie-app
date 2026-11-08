import 'package:flutter/material.dart';

import '../models/safety_kit.dart';

class SafetyKitScreen extends StatefulWidget {
  final List<SafetyKitLog> items;
  final String userName;
  final ValueChanged<SafetyKitLog> onAdd;
  final ValueChanged<SafetyKitLog> onReset;

  const SafetyKitScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
    required this.onReset,
  });

  @override
  State<SafetyKitScreen> createState() => _SafetyKitScreenState();
}

class _SafetyKitScreenState extends State<SafetyKitScreen> {
  late List<SafetyKitLog> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<SafetyKitLog>(
      context: context,
      builder: (_) => _KitDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  void _reset(SafetyKitLog item) {
    final reset = SafetyKitLog(
      id: item.id,
      kind: item.kind,
      title: item.title,
      daysUntilReview: 365,
      note: item.note,
      authorName: item.authorName,
    );
    setState(() {
      _items = [
        for (final entry in _items)
          if (entry.id == item.id) reset else entry,
      ];
    });
    widget.onReset(reset);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Przegląd gaśnicy / apteczki zapisany.')),
    );
  }

  void _remind() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Przypomnienie: sprawdź datę legalizacji gaśnicy lub apteczki.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gaśnice i apteczki'),
        actions: [
          IconButton(
            tooltip: 'Przypomnij o przeglądzie',
            onPressed: _remind,
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.health_and_safety_outlined),
        label: const Text('Wpis'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Daty ważności legalizacji gaśnic samochodowych i domowych oraz wyposażenia apteczek pierwszej pomocy.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.health_and_safety_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.daysUntilReview} dni do przeglądu\n'
                  '${item.note} · ${item.authorName}',
                ),
                isThreeLine: true,
                trailing: TextButton(
                  onPressed: () => _reset(item),
                  child: const Text('Po przeglądzie'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _KitDialog extends StatefulWidget {
  final String userName;

  const _KitDialog({required this.userName});

  @override
  State<_KitDialog> createState() => _KitDialogState();
}

class _KitDialogState extends State<_KitDialog> {
  var _kind = SafetyKitKind.homeExtinguisher;
  final _title = TextEditingController();
  final _note = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Gaśnica / apteczka'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<SafetyKitKind>(
            initialValue: _kind,
            items: [
              for (final kind in SafetyKitKind.values)
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
            controller: _note,
            decoration: const InputDecoration(labelText: 'Notatka'),
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
              SafetyKitLog(
                id: 'sk-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                daysUntilReview: 30,
                note: _note.text.trim(),
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
