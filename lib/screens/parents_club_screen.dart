import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../models/parent_meetup.dart';
import '../theme/widzew_ui.dart';

class ParentsClubScreen extends StatefulWidget {
  final List<ParentMeetup> meetups;
  final String userName;
  final String defaultSubDistrict;
  final ValueChanged<ParentMeetup> onAdd;

  const ParentsClubScreen({
    super.key,
    required this.meetups,
    required this.userName,
    required this.defaultSubDistrict,
    required this.onAdd,
  });

  @override
  State<ParentsClubScreen> createState() => _ParentsClubScreenState();
}

class _ParentsClubScreenState extends State<ParentsClubScreen> {
  late List<ParentMeetup> _meetups;
  ChildAgeBand? _age;

  @override
  void initState() {
    super.initState();
    _meetups = List.of(widget.meetups);
  }

  List<ParentMeetup> get _visible => _age == null
      ? _meetups
      : _meetups.where((item) => item.ageBand == _age).toList();

  Future<void> _add() async {
    final created = await showDialog<ParentMeetup>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _ParentDialog(
        userName: widget.userName,
        subDistrict: widget.defaultSubDistrict,
      ),
    );
    if (created == null) return;
    setState(() => _meetups = [created, ..._meetups]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dzieciaki z Widzewa / Rodzice Razem')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.child_care_outlined),
        label: const Text('Dodaj ogłoszenie'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Plac zabaw, wymiana ubranek i sąsiedzkie zastępstwo przy odbiorze ze szkoły.',
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              FilterChip(
                label: const Text('Wszystkie grupy wiekowe'),
                selected: _age == null,
                onSelected: (_) => setState(() => _age = null),
              ),
              for (final band in ChildAgeBand.values.take(2))
                FilterChip(
                  label: Text(band.label),
                  selected: _age == band,
                  onSelected: (_) => setState(
                    () => _age = _age == band ? null : band,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          for (final meetup in _visible)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.family_restroom_outlined),
                title: Text(meetup.title),
                subtitle: Text(
                  '${meetup.kind.label} · ${meetup.ageBand.label}\n'
                  '${meetup.place}\n'
                  '${meetup.description} · ${meetup.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _ParentDialog extends StatefulWidget {
  final String userName;
  final String subDistrict;

  const _ParentDialog({required this.userName, required this.subDistrict});

  @override
  State<_ParentDialog> createState() => _ParentDialogState();
}

class _ParentDialogState extends State<_ParentDialog> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _place = TextEditingController();
  var _kind = ParentMeetupKind.playground;
  var _age = ChildAgeBand.preschool;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ogłoszenie dla rodziców'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<ParentMeetupKind>(
              initialValue: _kind,
              decoration: const InputDecoration(labelText: 'Rodzaj'),
              items: ParentMeetupKind.values
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
            DropdownButtonFormField<ChildAgeBand>(
              initialValue: _age,
              decoration: const InputDecoration(labelText: 'Wiek dzieci'),
              items: ChildAgeBand.values
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _age = value);
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
          onPressed: () {
            if (_title.text.trim().isEmpty) return;
            Navigator.pop(
              context,
              ParentMeetup(
                id: 'parent-${DateTime.now().microsecondsSinceEpoch}',
                title: _title.text.trim(),
                description: _description.text.trim(),
                kind: _kind,
                ageBand: _age,
                place: _place.text.trim().isEmpty
                    ? _subDistrict
                    : _place.text.trim(),
                authorName: widget.userName,
                subDistrict: _subDistrict,
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
