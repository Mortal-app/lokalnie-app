import 'package:flutter/material.dart';

import '../models/board_game_night.dart';
import '../theme/widzew_ui.dart';

class BoardGamesScreen extends StatefulWidget {
  final List<BoardGameNight> items;
  final String userName;
  final ValueChanged<BoardGameNight> onAdd;

  const BoardGamesScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<BoardGamesScreen> createState() => _BoardGamesScreenState();
}

class _BoardGamesScreenState extends State<BoardGamesScreen> {
  late List<BoardGameNight> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<BoardGameNight>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _GameDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Klub planszówek')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.casino_outlined),
        label: const Text('Zorganizuj wieczór'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Wieczory z grami planszowymi i karcianymi w świetlicy lub u sąsiadów — bez prądu.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.extension_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.games}\n${item.place} · ${item.whenLabel} · ${item.host}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _GameDialog extends StatefulWidget {
  final String userName;

  const _GameDialog({required this.userName});

  @override
  State<_GameDialog> createState() => _GameDialogState();
}

class _GameDialogState extends State<_GameDialog> {
  final _title = TextEditingController();
  final _games = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _games.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Wieczór gier'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Tytuł'),
            ),
            TextField(
              controller: _games,
              decoration: const InputDecoration(labelText: 'Gry'),
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
              BoardGameNight(
                id: 'bg-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? 'Wieczór planszówek'
                    : _title.text.trim(),
                games: _games.text.trim().isEmpty
                    ? 'Gry bez prądu'
                    : _games.text.trim(),
                place: 'Świetlica osiedlowa',
                whenLabel: 'Piątek 18:30',
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
