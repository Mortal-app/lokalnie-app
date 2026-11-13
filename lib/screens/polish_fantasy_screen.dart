import 'package:flutter/material.dart';

import '../models/polish_fantasy.dart';
import '../theme/widzew_ui.dart';

class PolishFantasyScreen extends StatefulWidget {
  final List<PolishFantasyOffer> items;
  final String userName;
  final ValueChanged<PolishFantasyOffer> onAdd;

  const PolishFantasyScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<PolishFantasyScreen> createState() => _PolishFantasyScreenState();
}

class _PolishFantasyScreenState extends State<PolishFantasyScreen> {
  late List<PolishFantasyOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<PolishFantasyOffer>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _FantasyDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fantastyka i komiksy')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.auto_stories_outlined),
        label: const Text('Wymiana'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Relax, Kajko i Kokosz, Thorgal oraz polska fantastyka i science-fiction.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.auto_stories_outlined),
                title: Text(item.title),
                subtitle: Text('${item.kind.label} · ${item.authorName}'),
              ),
            ),
        ],
      ),
    );
  }
}

class _FantasyDialog extends StatefulWidget {
  final String userName;

  const _FantasyDialog({required this.userName});

  @override
  State<_FantasyDialog> createState() => _FantasyDialogState();
}

class _FantasyDialogState extends State<_FantasyDialog> {
  var _kind = FantasyKind.kajko;
  final _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Komiks / książka'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<FantasyKind>(
            initialValue: _kind,
            items: [
              for (final kind in FantasyKind.values)
                DropdownMenuItem(value: kind, child: Text(kind.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _kind = value);
            },
          ),
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Tytuł serii'),
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
              PolishFantasyOffer(
                id: 'pf-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Seria do wymiany'
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
