import 'package:flutter/material.dart';

import '../models/polish_film.dart';

class PolishFilmScreen extends StatefulWidget {
  final List<PolishFilmPost> items;
  final String userName;
  final ValueChanged<PolishFilmPost> onAdd;

  const PolishFilmScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<PolishFilmScreen> createState() => _PolishFilmScreenState();
}

class _PolishFilmScreenState extends State<PolishFilmScreen> {
  late List<PolishFilmPost> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<PolishFilmPost>(
      context: context,
      builder: (_) => _FilmDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Film polski i Teatr TV')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.movie_outlined),
        label: const Text('Wpis'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Wymiana płyt DVD, klasyka polskiej kinematografii, Teatr TV i seanse w osiedlowych domach kultury.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.movie_outlined),
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

class _FilmDialog extends StatefulWidget {
  final String userName;

  const _FilmDialog({required this.userName});

  @override
  State<_FilmDialog> createState() => _FilmDialogState();
}

class _FilmDialogState extends State<_FilmDialog> {
  var _kind = PolishFilmKind.dvd;
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
      title: const Text('Film / Teatr TV'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<PolishFilmKind>(
            initialValue: _kind,
            items: [
              for (final kind in PolishFilmKind.values)
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
              PolishFilmPost(
                id: 'pfl-${DateTime.now().millisecondsSinceEpoch}',
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
