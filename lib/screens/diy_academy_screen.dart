import 'package:flutter/material.dart';

import '../models/diy_workshop.dart';

class DiyAcademyScreen extends StatefulWidget {
  final List<DiyWorkshop> items;
  final String userName;
  final ValueChanged<DiyWorkshop> onAdd;

  const DiyAcademyScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<DiyAcademyScreen> createState() => _DiyAcademyScreenState();
}

class _DiyAcademyScreenState extends State<DiyAcademyScreen> {
  late List<DiyWorkshop> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<DiyWorkshop>(
      context: context,
      builder: (_) => _DiyDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Akademia DIY')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.school_outlined),
        label: const Text('Chętnie nauczę'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Darmowe warsztaty w klubie osiedlowym: lutowanie, szycie, programowanie, gotowanie.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.handyman_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.skill.label} · ${item.whenLabel}\n${item.place} · ${item.teacher}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _DiyDialog extends StatefulWidget {
  final String userName;

  const _DiyDialog({required this.userName});

  @override
  State<_DiyDialog> createState() => _DiyDialogState();
}

class _DiyDialogState extends State<_DiyDialog> {
  final _when = TextEditingController(text: 'Sobota 11:00');
  var _skill = DiySkill.soldering;

  @override
  void dispose() {
    _when.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Warsztat w klubie'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<DiySkill>(
              initialValue: _skill,
              items: [
                for (final skill in DiySkill.values)
                  DropdownMenuItem(value: skill, child: Text(skill.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _skill = value);
              },
            ),
            TextField(
              controller: _when,
              decoration: const InputDecoration(labelText: 'Termin'),
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
              DiyWorkshop(
                id: 'diy-${DateTime.now().millisecondsSinceEpoch}',
                skill: _skill,
                title: 'Chętnie nauczę ${_skill.label.toLowerCase()}',
                whenLabel: _when.text.trim(),
                place: 'Klub osiedlowy',
                teacher: widget.userName,
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
