import 'package:flutter/material.dart';

import '../models/blood_drive.dart';
import '../theme/widzew_ui.dart';

class BloodClubScreen extends StatefulWidget {
  final List<BloodDrive> items;
  final ValueChanged<BloodDrive> onAdd;

  const BloodClubScreen({
    super.key,
    required this.items,
    required this.onAdd,
  });

  @override
  State<BloodClubScreen> createState() => _BloodClubScreenState();
}

class _BloodClubScreenState extends State<BloodClubScreen> {
  late List<BloodDrive> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<BloodDrive>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _BloodDialog(),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    final urgent = _items.where((item) => item.urgent).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Klub Honorowego Dawcy Krwi')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.add),
        label: const Text('Dodaj krwiobus'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Mobilne punkty poboru przy centrach handlowych w Twojej okolicy i pilne zapotrzebowania.',
          ),
          if (urgent.isNotEmpty) ...[
            const SizedBox(height: 12),
            for (final item in urgent)
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: ListTile(
                  leading: const Icon(Icons.priority_high),
                  title: Text(item.place),
                  subtitle: Text(
                    'Pilne zapotrzebowanie · ${item.whenLabel} ${item.hours}\n${item.note}',
                  ),
                  isThreeLine: true,
                ),
              ),
          ],
          const SizedBox(height: 12),
          for (final item in _items.where((entry) => !entry.urgent))
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.bloodtype_outlined),
                title: Text(item.place),
                subtitle: Text(
                  '${item.whenLabel} · ${item.hours}'
                  '${item.note.isEmpty ? '' : '\n${item.note}'}',
                ),
                isThreeLine: item.note.isNotEmpty,
              ),
            ),
        ],
      ),
    );
  }
}

class _BloodDialog extends StatefulWidget {
  const _BloodDialog();

  @override
  State<_BloodDialog> createState() => _BloodDialogState();
}

class _BloodDialogState extends State<_BloodDialog> {
  final _place = TextEditingController();
  final _when = TextEditingController();
  final _hours = TextEditingController(text: '10:00–16:00');
  var _urgent = false;

  @override
  void dispose() {
    _place.dispose();
    _when.dispose();
    _hours.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Punkt poboru'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _place,
              decoration: const InputDecoration(labelText: 'Miejsce'),
            ),
            TextField(
              controller: _when,
              decoration: const InputDecoration(labelText: 'Dzień'),
            ),
            TextField(
              controller: _hours,
              decoration: const InputDecoration(labelText: 'Godziny'),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Pilne zapotrzebowanie'),
              value: _urgent,
              onChanged: (value) => setState(() => _urgent = value),
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
              BloodDrive(
                id: 'blood-${DateTime.now().millisecondsSinceEpoch}',
                place: _place.text.trim().isEmpty
                    ? 'Krwiobus w Twojej okolicy'
                    : _place.text.trim(),
                whenLabel: _when.text.trim().isEmpty
                    ? 'Wkrótce'
                    : _when.text.trim(),
                hours: _hours.text.trim(),
                urgent: _urgent,
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
