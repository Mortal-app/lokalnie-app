import 'package:flutter/material.dart';

import '../models/school_eco_drive.dart';
import '../theme/widzew_ui.dart';

class SchoolEcoScreen extends StatefulWidget {
  final List<SchoolEcoDrive> items;
  final ValueChanged<SchoolEcoDrive> onAdd;

  const SchoolEcoScreen({
    super.key,
    required this.items,
    required this.onAdd,
  });

  @override
  State<SchoolEcoScreen> createState() => _SchoolEcoScreenState();
}

class _SchoolEcoScreenState extends State<SchoolEcoScreen> {
  late List<SchoolEcoDrive> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<SchoolEcoDrive>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _EcoDialog(),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Szkolne eko-zbiórki')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.recycling_outlined),
        label: const Text('Nowa akcja'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Puszki, nakrętki i makulatura — akcje szkół w Twojej okolicy.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.school_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.school}\n${item.whenLabel}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _EcoDialog extends StatefulWidget {
  const _EcoDialog();

  @override
  State<_EcoDialog> createState() => _EcoDialogState();
}

class _EcoDialogState extends State<_EcoDialog> {
  final _title = TextEditingController();
  final _school = TextEditingController();
  var _kind = SchoolEcoKind.cans;

  @override
  void dispose() {
    _title.dispose();
    _school.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Akcja szkolna'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<SchoolEcoKind>(
              initialValue: _kind,
              items: [
                for (final kind in SchoolEcoKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _school,
              decoration: const InputDecoration(labelText: 'Szkoła'),
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Opis'),
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
              SchoolEcoDrive(
                id: 'se-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                school: _school.text.trim().isEmpty
                    ? 'Szkoła w Twojej okolicy'
                    : _school.text.trim(),
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                whenLabel: 'W tym tygodniu',
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
