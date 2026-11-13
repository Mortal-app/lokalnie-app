import 'package:flutter/material.dart';

import '../models/console_tourney.dart';
import '../theme/widzew_ui.dart';

class ConsoleTourneyScreen extends StatefulWidget {
  final List<ConsoleTourney> items;
  final String userName;
  final ValueChanged<ConsoleTourney> onAdd;

  const ConsoleTourneyScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<ConsoleTourneyScreen> createState() => _ConsoleTourneyScreenState();
}

class _ConsoleTourneyScreenState extends State<ConsoleTourneyScreen> {
  late List<ConsoleTourney> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<ConsoleTourney>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _CupDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Turnieje konsolowe')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.sports_esports_outlined),
        label: const Text('Nowy turniej'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'FC, Tekken, Mortal Kombat — PS / Xbox / PC na telewizorach w klubach osiedlowych.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.videogame_asset_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.platform.label} · ${item.game}\n${item.place} · ${item.whenLabel} · ${item.host}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _CupDialog extends StatefulWidget {
  final String userName;

  const _CupDialog({required this.userName});

  @override
  State<_CupDialog> createState() => _CupDialogState();
}

class _CupDialogState extends State<_CupDialog> {
  final _title = TextEditingController();
  var _platform = ConsolePlatform.ps;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Turniej'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<ConsolePlatform>(
              initialValue: _platform,
              items: [
                for (final platform in ConsolePlatform.values)
                  DropdownMenuItem(
                    value: platform,
                    child: Text(platform.label),
                  ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _platform = value);
              },
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Tytuł / gra'),
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
              ConsoleTourney(
                id: 'ct-${DateTime.now().millisecondsSinceEpoch}',
                platform: _platform,
                title: _title.text.trim().isEmpty
                    ? 'Turniej ${_platform.label}'
                    : _title.text.trim(),
                game: 'Gry sportowe / bijatyki',
                place: 'Klub osiedlowy, TV',
                whenLabel: 'Sobota 17:00',
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
