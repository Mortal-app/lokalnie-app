import 'package:flutter/material.dart';

import '../models/home_duty.dart';

class HomeAssistantScreen extends StatefulWidget {
  final List<HomeDuty> duties;
  final ValueChanged<HomeDuty> onAdd;
  final void Function(String title, String body) onRemind;

  const HomeAssistantScreen({
    super.key,
    required this.duties,
    required this.onAdd,
    required this.onRemind,
  });

  @override
  State<HomeAssistantScreen> createState() => _HomeAssistantScreenState();
}

class _HomeAssistantScreenState extends State<HomeAssistantScreen> {
  late List<HomeDuty> _duties;

  @override
  void initState() {
    super.initState();
    _duties = List.of(widget.duties);
  }

  Future<void> _add() async {
    final created = await showDialog<HomeDuty>(
      context: context,
      builder: (_) => const _DutyDialog(),
    );
    if (created == null) return;
    setState(() => _duties = [created, ..._duties]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asystent domowy')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.event_note_outlined),
        label: const Text('Dodaj termin'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Liczniki wody, gazu i prądu oraz przegląd piecyków. Przypomnienie trafia do powiadomień lokalnych.',
          ),
          const SizedBox(height: 12),
          for (final duty in _duties)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.home_repair_service_outlined),
                title: Text(duty.title),
                subtitle: Text(
                  '${duty.kind.label} · ${duty.dueLabel}'
                  '${duty.note.isEmpty ? '' : '\n${duty.note}'}',
                ),
                isThreeLine: duty.note.isNotEmpty,
                trailing: TextButton(
                  onPressed: () => widget.onRemind(
                    duty.title,
                    '${duty.dueLabel}. ${duty.note}',
                  ),
                  child: const Text('Przypomnij'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DutyDialog extends StatefulWidget {
  const _DutyDialog();

  @override
  State<_DutyDialog> createState() => _DutyDialogState();
}

class _DutyDialogState extends State<_DutyDialog> {
  final _title = TextEditingController();
  final _due = TextEditingController();
  final _note = TextEditingController();
  var _kind = HomeDutyKind.waterMeter;

  @override
  void dispose() {
    _title.dispose();
    _due.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nowy termin'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<HomeDutyKind>(
              initialValue: _kind,
              decoration: const InputDecoration(labelText: 'Rodzaj'),
              items: HomeDutyKind.values
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Tytuł'),
            ),
            TextField(
              controller: _due,
              decoration: const InputDecoration(labelText: 'Termin'),
            ),
            TextField(
              controller: _note,
              decoration: const InputDecoration(labelText: 'Uwagi'),
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
              HomeDuty(
                id: 'duty-${DateTime.now().microsecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                dueLabel: _due.text.trim().isEmpty
                    ? 'wkrótce'
                    : _due.text.trim(),
                note: _note.text.trim(),
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
