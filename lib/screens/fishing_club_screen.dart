import 'package:flutter/material.dart';

import '../models/fishing_club.dart';
import '../theme/widzew_ui.dart';

class FishingClubScreen extends StatefulWidget {
  final List<FishingPost> items;
  final String userName;
  final ValueChanged<FishingPost> onAdd;

  const FishingClubScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<FishingClubScreen> createState() => _FishingClubScreenState();
}

class _FishingClubScreenState extends State<FishingClubScreen> {
  late List<FishingPost> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<FishingPost>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _FishDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Klub wędkarzy')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.water_outlined),
        label: const Text('Wpis'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Akweny na Olechowie i zbiorniki na Widzewie — przynęty i wspólne wyjazdy.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.water_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.place} · ${item.authorName}',
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FishDialog extends StatefulWidget {
  final String userName;

  const _FishDialog({required this.userName});

  @override
  State<_FishDialog> createState() => _FishDialogState();
}

class _FishDialogState extends State<_FishDialog> {
  var _kind = FishingKind.spot;
  final _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Wędkarstwo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<FishingKind>(
            initialValue: _kind,
            items: [
              for (final kind in FishingKind.values)
                DropdownMenuItem(value: kind, child: Text(kind.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _kind = value);
            },
          ),
          TextField(
            controller: _title,
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
              FishingPost(
                id: 'fi-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Wpis wędkarski'
                    : _title.text.trim(),
                place: 'Widzew',
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
