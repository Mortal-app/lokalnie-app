import 'package:flutter/material.dart';

import '../models/indie_cinema.dart';
import '../theme/widzew_ui.dart';

class IndieCinemaScreen extends StatefulWidget {
  final List<IndieCinemaPost> items;
  final String userName;
  final ValueChanged<IndieCinemaPost> onAdd;

  const IndieCinemaScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<IndieCinemaScreen> createState() => _IndieCinemaScreenState();
}

class _IndieCinemaScreenState extends State<IndieCinemaScreen> {
  late List<IndieCinemaPost> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<IndieCinemaPost>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _IndieDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kino niezależne')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.theaters_outlined),
        label: const Text('Wpis / seans'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Filmy niszowe, Camerimage, Festiwal Form Dokumentalnych i seanse domowe.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.theaters_outlined),
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

class _IndieDialog extends StatefulWidget {
  final String userName;

  const _IndieDialog({required this.userName});

  @override
  State<_IndieDialog> createState() => _IndieDialogState();
}

class _IndieDialogState extends State<_IndieDialog> {
  var _kind = IndieCinemaKind.homeScreening;
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
      title: const Text('Kino amatorskie'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<IndieCinemaKind>(
            initialValue: _kind,
            items: [
              for (final kind in IndieCinemaKind.values)
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
            decoration: const InputDecoration(labelText: 'Opinia / zaproszenie'),
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
              IndieCinemaPost(
                id: 'ic-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Seans w Twojej okolicy'
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
