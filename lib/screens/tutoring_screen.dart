import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../models/tutoring_offer.dart';
import '../theme/widzew_ui.dart';

class TutoringScreen extends StatefulWidget {
  final List<TutoringOffer> offers;
  final String userName;
  final String defaultSubDistrict;
  final ValueChanged<TutoringOffer> onAdd;

  const TutoringScreen({
    super.key,
    required this.offers,
    required this.userName,
    required this.defaultSubDistrict,
    required this.onAdd,
  });

  @override
  State<TutoringScreen> createState() => _TutoringScreenState();
}

class _TutoringScreenState extends State<TutoringScreen> {
  late List<TutoringOffer> _offers;
  TutoringAudience? _audience;
  TutoringMode? _mode;

  @override
  void initState() {
    super.initState();
    _offers = List.of(widget.offers);
  }

  List<TutoringOffer> get _visible => _offers.where((item) {
    final matchesAudience = _audience == null || item.audience == _audience;
    final matchesMode = _mode == null || item.mode == _mode;
    return matchesAudience && matchesMode;
  }).toList();

  Future<void> _add() async {
    final created = await showDialog<TutoringOffer>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _TutorDialog(
        userName: widget.userName,
        subDistrict: widget.defaultSubDistrict,
      ),
    );
    if (created == null) return;
    setState(() => _offers = [created, ..._offers]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Korepetycje i nauka sąsiedzka')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.school_outlined),
        label: const Text('Dodaj zajęcia'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Matematyka, języki, gitara, programowanie — wiedza za wiedzę albo za przysługę.',
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              FilterChip(
                label: const Text('Wszyscy'),
                selected: _audience == null,
                onSelected: (_) => setState(() => _audience = null),
              ),
              for (final audience in TutoringAudience.values.take(2))
                FilterChip(
                  label: Text(audience.label),
                  selected: _audience == audience,
                  onSelected: (_) => setState(
                    () =>
                        _audience = _audience == audience ? null : audience,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          for (final offer in _visible)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.menu_book_outlined),
                title: Text(offer.title),
                subtitle: Text(
                  '${offer.subject} · ${offer.audience.label} · ${offer.mode.label}\n'
                  '${offer.authorName}, ${offer.subDistrict}'
                  '${offer.note.isEmpty ? '' : '\n${offer.note}'}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _TutorDialog extends StatefulWidget {
  final String userName;
  final String subDistrict;

  const _TutorDialog({required this.userName, required this.subDistrict});

  @override
  State<_TutorDialog> createState() => _TutorDialogState();
}

class _TutorDialogState extends State<_TutorDialog> {
  final _title = TextEditingController();
  final _subject = TextEditingController();
  final _note = TextEditingController();
  var _audience = TutoringAudience.youth;
  var _mode = TutoringMode.onsite;
  late String _subDistrict;

  @override
  void initState() {
    super.initState();
    _subDistrict = widget.subDistrict;
  }

  @override
  void dispose() {
    _title.dispose();
    _subject.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nowe zajęcia'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Tytuł'),
            ),
            TextField(
              controller: _subject,
              decoration: const InputDecoration(labelText: 'Przedmiot'),
            ),
            DropdownButtonFormField<TutoringAudience>(
              initialValue: _audience,
              decoration: const InputDecoration(labelText: 'Dla kogo'),
              items: TutoringAudience.values
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _audience = value);
              },
            ),
            DropdownButtonFormField<TutoringMode>(
              initialValue: _mode,
              decoration: const InputDecoration(labelText: 'Tryb'),
              items: TutoringMode.values
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _mode = value);
              },
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
            if (_title.text.trim().isEmpty) return;
            Navigator.pop(
              context,
              TutoringOffer(
                id: 'tutor-${DateTime.now().microsecondsSinceEpoch}',
                title: _title.text.trim(),
                subject: _subject.text.trim().isEmpty
                    ? 'Inne'
                    : _subject.text.trim(),
                audience: _audience,
                mode: _mode,
                authorName: widget.userName,
                subDistrict: _subDistrict,
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
