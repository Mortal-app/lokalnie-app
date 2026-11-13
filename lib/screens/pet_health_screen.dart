import 'package:flutter/material.dart';

import '../models/pet_health.dart';
import '../theme/widzew_ui.dart';

class PetHealthScreen extends StatefulWidget {
  final List<PetVaccineReminder> reminders;
  final List<VetClinic> clinics;
  final ValueChanged<PetVaccineReminder> onAdd;
  final ValueChanged<String> onRemind;

  const PetHealthScreen({
    super.key,
    required this.reminders,
    required this.clinics,
    required this.onAdd,
    required this.onRemind,
  });

  @override
  State<PetHealthScreen> createState() => _PetHealthScreenState();
}

class _PetHealthScreenState extends State<PetHealthScreen> {
  late List<PetVaccineReminder> _reminders;

  @override
  void initState() {
    super.initState();
    _reminders = List.of(widget.reminders);
  }

  Future<void> _add() async {
    final created = await showDialog<PetVaccineReminder>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _VaccineDialog(),
    );
    if (created == null) return;
    setState(() => _reminders = [created, ..._reminders]);
    widget.onAdd(created);
  }

  void _remind(PetVaccineReminder reminder) {
    if (reminder.reminded) return;
    setState(() {
      _reminders = _reminders
          .map(
            (item) =>
                item.id == reminder.id ? item.copyWith(reminded: true) : item,
          )
          .toList();
    });
    widget.onRemind(reminder.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Przypomnienie o szczepieniu zapisane.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zdrowy zwierzak')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.vaccines_outlined),
        label: const Text('Termin szczepienia'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text('Kalendarz szczepień i polecane gabinety weterynaryjne.'),
          const SizedBox(height: 12),
          for (final item in _reminders)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.pets_outlined),
                title: Text('${item.petName} — ${item.vaccine}'),
                subtitle: Text('Termin: ${item.dateLabel}'),
                trailing: TextButton(
                  onPressed: item.reminded ? null : () => _remind(item),
                  child: Text(item.reminded ? 'Zapisano' : 'Przypomnij'),
                ),
              ),
            ),
          const SizedBox(height: 8),
          const Text(
            'Gabinety w okolicy',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          for (final clinic in widget.clinics)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.local_hospital_outlined),
                title: Text(clinic.name),
                subtitle: Text('${clinic.address}\n${clinic.note}'),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _VaccineDialog extends StatefulWidget {
  const _VaccineDialog();

  @override
  State<_VaccineDialog> createState() => _VaccineDialogState();
}

class _VaccineDialogState extends State<_VaccineDialog> {
  final _pet = TextEditingController();
  final _vaccine = TextEditingController(text: 'Wścieklizna');
  final _date = TextEditingController();

  @override
  void dispose() {
    _pet.dispose();
    _vaccine.dispose();
    _date.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Szczepienie'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _pet,
              decoration: const InputDecoration(labelText: 'Imię zwierzaka'),
            ),
            TextField(
              controller: _vaccine,
              decoration: const InputDecoration(labelText: 'Szczepionka'),
            ),
            TextField(
              controller: _date,
              decoration: const InputDecoration(
                labelText: 'Data',
                hintText: 'np. 12.11.2026',
              ),
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
              PetVaccineReminder(
                id: 'vac-${DateTime.now().millisecondsSinceEpoch}',
                petName: _pet.text.trim().isEmpty ? 'Zwierzak' : _pet.text.trim(),
                vaccine: _vaccine.text.trim(),
                dateLabel: _date.text.trim().isEmpty
                    ? 'Do ustalenia'
                    : _date.text.trim(),
              ),
            );
          },
          child: const Text('Zapisz'),
        ),
      ],
    );
  }
}
