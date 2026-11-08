import 'package:flutter/material.dart';

import '../models/retro_gaming.dart';

class RetroGamingScreen extends StatefulWidget {
  final List<RetroGamingEvent> items;
  final String userName;
  final ValueChanged<RetroGamingEvent> onAdd;

  const RetroGamingScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<RetroGamingScreen> createState() => _RetroGamingScreenState();
}

class _RetroGamingScreenState extends State<RetroGamingScreen> {
  late List<RetroGamingEvent> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<RetroGamingEvent>(
      context: context,
      builder: (_) => _RetroDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Klub retro-gamingu')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.sports_esports_outlined),
        label: const Text('Turniej / wieczór'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Commodore, Amiga, stary PeCet i retro-konsole — wspólne turnieje na osiedlu.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.videogame_asset_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.platform.label} · ${item.whenLabel}\n${item.place} · ${item.host}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _RetroDialog extends StatefulWidget {
  final String userName;

  const _RetroDialog({required this.userName});

  @override
  State<_RetroDialog> createState() => _RetroDialogState();
}

class _RetroDialogState extends State<_RetroDialog> {
  final _title = TextEditingController();
  var _platform = RetroPlatform.commodore;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Spotkanie retro'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<RetroPlatform>(
              initialValue: _platform,
              items: [
                for (final platform in RetroPlatform.values)
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
              RetroGamingEvent(
                id: 'rg-${DateTime.now().millisecondsSinceEpoch}',
                platform: _platform,
                title: _title.text.trim().isEmpty
                    ? 'Wieczór ${_platform.label}'
                    : _title.text.trim(),
                whenLabel: 'Sobota 17:00',
                place: 'Świetlica',
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
