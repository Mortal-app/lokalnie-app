import 'package:flutter/material.dart';

import '../models/garden_note.dart';
import '../theme/widzew_ui.dart';

class GardenNotesScreen extends StatefulWidget {
  final List<GardenNote> items;
  final ValueChanged<GardenNote> onAdd;

  const GardenNotesScreen({
    super.key,
    required this.items,
    required this.onAdd,
  });

  @override
  State<GardenNotesScreen> createState() => _GardenNotesScreenState();
}

class _GardenNotesScreenState extends State<GardenNotesScreen> {
  late List<GardenNote> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<GardenNote>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _GardenDialog(),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes ogrodnika')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.local_florist_outlined),
        label: const Text('Przypomnienie'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Kalendarz prac, podlewanie ziół na balkonie i wysiew warzyw w klimacie łódzkim.',
          ),
          const SizedBox(height: 8),
          const Card(
            child: ListTile(
              leading: Icon(Icons.menu_book_outlined),
              title: Text('Poradnik wysiewu — Łódź'),
              subtitle: Text(
                'Marzec: rzodkiew, sałata. Kwiecień: marchew. Maj (po 15.): pomidor, ogórek. Agrowłóknina do przymrozków.',
              ),
              isThreeLine: true,
            ),
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(
                  item.kind == GardenNoteKind.water
                      ? Icons.water_drop_outlined
                      : Icons.eco_outlined,
                ),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.whenLabel}\n${item.tip}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _GardenDialog extends StatefulWidget {
  const _GardenDialog();

  @override
  State<_GardenDialog> createState() => _GardenDialogState();
}

class _GardenDialogState extends State<_GardenDialog> {
  final _title = TextEditingController();
  var _kind = GardenNoteKind.water;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Wpis do notesu'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<GardenNoteKind>(
              initialValue: _kind,
              items: [
                for (final kind in GardenNoteKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Co zrobić?'),
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
              GardenNote(
                id: 'gn-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                whenLabel: 'Dziś',
                tip: 'Przypomnienie z balkonu / działki.',
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
