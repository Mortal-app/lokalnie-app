import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../models/odd_job.dart';
import '../utils/submit_guard.dart';
import '../utils/utf8_text_guard.dart';
import '../theme/widzew_ui.dart';

class OddJobsScreen extends StatefulWidget {
  final List<OddJob> jobs;
  final String userName;
  final String defaultSubDistrict;
  final ValueChanged<OddJob> onAdd;

  const OddJobsScreen({
    super.key,
    required this.jobs,
    required this.userName,
    required this.defaultSubDistrict,
    required this.onAdd,
  });

  @override
  State<OddJobsScreen> createState() => _OddJobsScreenState();
}

class _OddJobsScreenState extends State<OddJobsScreen> with SubmitGuard {
  late List<OddJob> _jobs;
  OddJobKind? _kind;
  OddJobBudget? _budget;

  @override
  void initState() {
    super.initState();
    _jobs = List.of(widget.jobs);
  }

  List<OddJob> get _visible => _jobs.where((item) {
    final matchesKind = _kind == null || item.kind == _kind;
    final matchesBudget = _budget == null || item.budgetBand == _budget;
    return matchesKind && matchesBudget;
  }).toList();

  Future<void> _add() async {
    await runExclusive(() async {
      final created = await showDialog<OddJob>(
        context: context,
        barrierDismissible: true,
        builder: (_) => _JobDialog(
          userName: widget.userName,
          subDistrict: widget.defaultSubDistrict,
        ),
      );
      if (created == null || !mounted) return;
      setState(() => _jobs = [created, ..._jobs]);
      widget.onAdd(created);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Praca i drobne zlecenia')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: submitLocked ? null : _add,
        icon: const Icon(Icons.work_outline),
        label: const Text('Dodaj zlecenie'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Szukam / oferuję pracę doraźną: ROD, przeprowadzka, pies.',
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              FilterChip(
                label: const Text('Wszystkie kategorie'),
                selected: _kind == null,
                onSelected: (_) => setState(() => _kind = null),
              ),
              for (final kind in OddJobKind.values.take(2))
                FilterChip(
                  label: Text(kind.label),
                  selected: _kind == kind,
                  onSelected: (_) =>
                      setState(() => _kind = _kind == kind ? null : kind),
                ),
            ],
          ),
          const SizedBox(height: 12),
          for (final job in _visible)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(
                  job.offering ? Icons.handyman_outlined : Icons.search,
                ),
                title: Text(job.title),
                subtitle: Text(
                  '${job.offering ? 'Oferuję' : 'Szukam'} · ${job.kind.label} · ${job.budget} zł\n'
                  '${job.place} · ${job.authorName}\n'
                  '${job.description}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _JobDialog extends StatefulWidget {
  final String userName;
  final String subDistrict;

  const _JobDialog({required this.userName, required this.subDistrict});

  @override
  State<_JobDialog> createState() => _JobDialogState();
}

class _JobDialogState extends State<_JobDialog> with SubmitGuard {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _place = TextEditingController();
  final _budget = TextEditingController(text: '50');
  var _kind = OddJobKind.other;
  var _offering = false;
  late String _subDistrict;

  @override
  void initState() {
    super.initState();
    _subDistrict = widget.subDistrict;
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _place.dispose();
    _budget.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zlecenie doraźne'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Oferuję pracę (zamiast szukam)'),
              value: _offering,
              onChanged: (value) => setState(() => _offering = value),
            ),
            DropdownButtonFormField<OddJobKind>(
              initialValue: _kind,
              decoration: const InputDecoration(labelText: 'Kategoria'),
              items: OddJobKind.values
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
              controller: _place,
              decoration: const InputDecoration(labelText: 'Miejsce'),
            ),
            TextField(
              controller: _budget,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Budżet (zł)'),
            ),
            DropdownButtonFormField<String>(
              initialValue: _subDistrict,
              decoration: const InputDecoration(labelText: 'Osiedle'),
              items: Announcement.subDistricts
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _subDistrict = value);
              },
            ),
            TextField(
              controller: _description,
              maxLines: 2,
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
          onPressed: submitLocked
              ? null
              : () {
                  if (Utf8TextGuard.sanitize(_title.text).isEmpty) return;
                  runExclusive(() async {
                    Navigator.pop(
                      context,
                      OddJob(
                        id: 'job-${DateTime.now().microsecondsSinceEpoch}',
                        title: Utf8TextGuard.sanitize(_title.text),
                        description: Utf8TextGuard.sanitize(_description.text),
                        kind: _kind,
                        budget: int.tryParse(_budget.text.trim()) ?? 0,
                        offering: _offering,
                        authorName: widget.userName,
                        subDistrict: _subDistrict,
                        place: _place.text.trim().isEmpty
                            ? _subDistrict
                            : _place.text.trim(),
                      ),
                    );
                  });
                },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
