import 'package:flutter/material.dart';

import '../models/pcv_window.dart';

class PcvWindowScreen extends StatefulWidget {
  final List<PcvWindowTip> items;
  final String userName;
  final ValueChanged<PcvWindowTip> onAdd;

  const PcvWindowScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<PcvWindowScreen> createState() => _PcvWindowScreenState();
}

class _PcvWindowScreenState extends State<PcvWindowScreen> {
  late List<PcvWindowTip> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<PcvWindowTip>(
      context: context,
      builder: (_) => _PcvDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Okna PCV i okucia')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.sensor_window),
        label: const Text('Porada / pomoc'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Regulacja okuć przed zimą i latem — fachowcy z osiedla.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.sensor_window),
                title: Text(item.title),
                subtitle: Text(
                  '${item.season.label}\n${item.body} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _PcvDialog extends StatefulWidget {
  final String userName;

  const _PcvDialog({required this.userName});

  @override
  State<_PcvDialog> createState() => _PcvDialogState();
}

class _PcvDialogState extends State<_PcvDialog> {
  var _season = PcvSeason.winter;
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
      title: const Text('Okucia PCV'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<PcvSeason>(
            initialValue: _season,
            items: [
              for (final season in PcvSeason.values)
                DropdownMenuItem(value: season, child: Text(season.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _season = value);
            },
          ),
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Tytuł'),
          ),
          TextField(
            controller: _body,
            decoration: const InputDecoration(labelText: 'Porada'),
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
              PcvWindowTip(
                id: 'pcv-${DateTime.now().millisecondsSinceEpoch}',
                season: _season,
                title: _title.text.trim().isEmpty
                    ? 'Regulacja okien'
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
