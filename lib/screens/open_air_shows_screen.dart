import 'package:flutter/material.dart';

import '../models/open_air_show.dart';

class OpenAirShowsScreen extends StatefulWidget {
  final List<OpenAirShow> items;
  final String userName;
  final ValueChanged<OpenAirShow> onAdd;
  final ValueChanged<String> onVote;

  const OpenAirShowsScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
    required this.onVote,
  });

  @override
  State<OpenAirShowsScreen> createState() => _OpenAirShowsScreenState();
}

class _OpenAirShowsScreenState extends State<OpenAirShowsScreen> {
  late List<OpenAirShow> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<OpenAirShow>(
      context: context,
      builder: (_) => _ShowDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  void _vote(OpenAirShow show) {
    final next = show.vote();
    if (next.iVoted == show.iVoted) return;
    setState(() {
      _items = _items.map((item) => item.id == show.id ? next : item).toList();
    });
    widget.onVote(show.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kino pod chmurką i teatrzyk')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.theaters_outlined),
        label: const Text('Propozycja repertuaru'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Letnie pokazy na dziedzińcu lub w świetlicy — głosuj na repertuar.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.movie_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.place} · ${item.whenLabel}\nGłosy: ${item.votes} · ${item.authorName}',
                ),
                isThreeLine: true,
                trailing: TextButton(
                  onPressed: item.iVoted ? null : () => _vote(item),
                  child: Text(item.iVoted ? 'Oddano głos' : 'Głosuj'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ShowDialog extends StatefulWidget {
  final String userName;

  const _ShowDialog({required this.userName});

  @override
  State<_ShowDialog> createState() => _ShowDialogState();
}

class _ShowDialogState extends State<_ShowDialog> {
  final _title = TextEditingController();
  final _place = TextEditingController(text: 'Dziedziniec bloku');

  @override
  void dispose() {
    _title.dispose();
    _place.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pokaz / spektakl'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Repertuar'),
            ),
            TextField(
              controller: _place,
              decoration: const InputDecoration(labelText: 'Miejsce'),
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
              OpenAirShow(
                id: 'oa-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? 'Propozycja repertuaru'
                    : _title.text.trim(),
                place: _place.text.trim(),
                whenLabel: 'Do ustalenia',
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
