import 'package:flutter/material.dart';

import '../models/charity_drive.dart';
import '../theme/widzew_ui.dart';

class CharityDrivesScreen extends StatefulWidget {
  final List<CharityDrive> drives;
  final ValueChanged<CharityDrive> onAdd;
  final void Function(String id, int amount) onContribute;

  const CharityDrivesScreen({
    super.key,
    required this.drives,
    required this.onAdd,
    required this.onContribute,
  });

  @override
  State<CharityDrivesScreen> createState() => _CharityDrivesScreenState();
}

class _CharityDrivesScreenState extends State<CharityDrivesScreen> {
  late List<CharityDrive> _drives;

  @override
  void initState() {
    super.initState();
    _drives = List.of(widget.drives);
  }

  Future<void> _add() async {
    final created = await showDialog<CharityDrive>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _DriveDialog(),
    );
    if (created == null) return;
    setState(() => _drives = [created, ..._drives]);
    widget.onAdd(created);
  }

  Future<void> _contribute(CharityDrive drive) async {
    final amount = await showDialog<int>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _ContributeDialog(unit: drive.unit),
    );
    if (amount == null || amount <= 0) return;
    final next = drive.collected + amount;
    setState(() {
      _drives = _drives
          .map(
            (item) =>
                item.id == drive.id ? item.copyWith(collected: next) : item,
          )
          .toList();
    });
    widget.onContribute(drive.id, amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sąsiedzka Pomoc Rodzinom')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.volunteer_activism_outlined),
        label: const Text('Nowa zbiórka'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Zbiórki rzeczowe i finansowe: karma dla schronisk, wyprawka szkolna, pomoc sąsiadom.',
          ),
          const SizedBox(height: 12),
          for (final drive in _drives)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      drive.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(drive.kind.label),
                    Text(drive.description),
                    Text('Dla: ${drive.beneficiary}'),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: drive.progress),
                    const SizedBox(height: 6),
                    Text(
                      'Zebrano ${drive.collected} / ${drive.goal} ${drive.unit}',
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _contribute(drive),
                        child: const Text('Dodaj pomoc'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DriveDialog extends StatefulWidget {
  const _DriveDialog();

  @override
  State<_DriveDialog> createState() => _DriveDialogState();
}

class _DriveDialogState extends State<_DriveDialog> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _beneficiary = TextEditingController();
  final _goal = TextEditingController(text: '10');
  final _unit = TextEditingController(text: 'szt.');
  var _kind = CharityDriveKind.goods;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _beneficiary.dispose();
    _goal.dispose();
    _unit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nowa zbiórka celowa'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Tytuł'),
            ),
            DropdownButtonFormField<CharityDriveKind>(
              initialValue: _kind,
              decoration: const InputDecoration(labelText: 'Rodzaj'),
              items: CharityDriveKind.values
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
              controller: _beneficiary,
              decoration: const InputDecoration(labelText: 'Dla kogo'),
            ),
            TextField(
              controller: _goal,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cel'),
            ),
            TextField(
              controller: _unit,
              decoration: const InputDecoration(
                labelText: 'Jednostka (kg, zł, szt.)',
              ),
            ),
            TextField(
              controller: _description,
              maxLines: 3,
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
            if (_title.text.trim().isEmpty) return;
            Navigator.pop(
              context,
              CharityDrive(
                id: 'drive-${DateTime.now().microsecondsSinceEpoch}',
                title: _title.text.trim(),
                description: _description.text.trim(),
                kind: _kind,
                goal: int.tryParse(_goal.text.trim()) ?? 1,
                collected: 0,
                unit: _unit.text.trim().isEmpty ? 'szt.' : _unit.text.trim(),
                beneficiary: _beneficiary.text.trim().isEmpty
                    ? 'Sąsiedzi'
                    : _beneficiary.text.trim(),
              ),
            );
          },
          child: const Text('Utwórz'),
        ),
      ],
    );
  }
}

class _ContributeDialog extends StatefulWidget {
  final String unit;

  const _ContributeDialog({required this.unit});

  @override
  State<_ContributeDialog> createState() => _ContributeDialogState();
}

class _ContributeDialogState extends State<_ContributeDialog> {
  final _amount = TextEditingController(text: '1');

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Dodaj pomoc'),
      content: TextField(
        controller: _amount,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: 'Ilość (${widget.unit})'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Anuluj'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context, int.tryParse(_amount.text.trim()) ?? 0);
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
