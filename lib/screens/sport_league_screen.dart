import 'package:flutter/material.dart';

import '../models/sport_league.dart';

class SportLeagueScreen extends StatefulWidget {
  final List<SportHubItem> items;
  final String userName;
  final ValueChanged<SportHubItem> onAdd;
  final void Function(String id, String pick) onPick;

  const SportLeagueScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
    required this.onPick,
  });

  @override
  State<SportLeagueScreen> createState() => _SportLeagueScreenState();
}

class _SportLeagueScreenState extends State<SportLeagueScreen> {
  late List<SportHubItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<SportHubItem>(
      context: context,
      builder: (_) => _SportDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  void _pick(SportHubItem item, String pick) {
    setState(() {
      _items = _items
          .map(
            (entry) =>
                entry.id == item.id ? entry.copyWith(userPick: pick) : entry,
          )
          .toList();
    });
    widget.onPick(item.id, pick);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liga sportowa i typer')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.sports_soccer),
        label: const Text('Mecz / turniej'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Typy lokalnych meczów oraz amatorskie turnieje e-sport i szachy na osiedlu.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.emoji_events_outlined),
                      title: Text(item.title),
                      subtitle: Text(
                        '${item.kind.label} · ${item.whenLabel}\n${item.host}',
                      ),
                      isThreeLine: true,
                    ),
                    if (item.kind == SportHubKind.tip)
                      OverflowBar(
                        children: [
                          for (final pick in ['1', 'X', '2'])
                            ChoiceChip(
                              label: Text(pick),
                              selected: item.userPick == pick,
                              onSelected: (_) => _pick(item, pick),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SportDialog extends StatefulWidget {
  final String userName;

  const _SportDialog({required this.userName});

  @override
  State<_SportDialog> createState() => _SportDialogState();
}

class _SportDialogState extends State<_SportDialog> {
  final _title = TextEditingController();
  var _kind = SportHubKind.tip;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Liga osiedlowa'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<SportHubKind>(
              initialValue: _kind,
              items: [
                for (final kind in SportHubKind.values)
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
              SportHubItem(
                id: 'sl-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                whenLabel: 'Wkrótce',
                host: widget.userName,
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
