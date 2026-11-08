import 'package:flutter/material.dart';

import '../models/scam_alert.dart';

class ScamAlertScreen extends StatefulWidget {
  final List<ScamAlert> items;
  final String userName;
  final ValueChanged<ScamAlert> onAdd;
  final ValueChanged<ScamAlert> onNotifyNeighbors;

  const ScamAlertScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
    required this.onNotifyNeighbors,
  });

  @override
  State<ScamAlertScreen> createState() => _ScamAlertScreenState();
}

class _ScamAlertScreenState extends State<ScamAlertScreen> {
  late List<ScamAlert> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<ScamAlert>(
      context: context,
      builder: (_) => _ScamDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ostrzeżenia o oszustwach')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.report_outlined),
        label: const Text('Pilne ostrzeżenie'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Próby wyłudzeń „na wnuczka” i „na urzędnika” — natychmiastowe powiadomienie sąsiadów.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              color: item.urgent ? const Color(0xFFFFEBEE) : null,
              child: ListTile(
                leading: const Icon(Icons.report_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label}\n${item.body} · ${item.authorName}',
                ),
                isThreeLine: true,
                trailing: TextButton(
                  onPressed: () => widget.onNotifyNeighbors(item),
                  child: const Text('Powiadom'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ScamDialog extends StatefulWidget {
  final String userName;

  const _ScamDialog({required this.userName});

  @override
  State<_ScamDialog> createState() => _ScamDialogState();
}

class _ScamDialogState extends State<_ScamDialog> {
  var _kind = ScamKind.grandson;
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
      title: const Text('Ostrzeżenie'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<ScamKind>(
            initialValue: _kind,
            items: [
              for (final kind in ScamKind.values)
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
            decoration: const InputDecoration(labelText: 'Opis'),
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
              ScamAlert(
                id: 'sc-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Próba wyłudzenia na osiedlu'
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
