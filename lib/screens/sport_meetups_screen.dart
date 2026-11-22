import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../models/sport_meetup.dart';
import '../theme/widzew_ui.dart';

class SportMeetupsScreen extends StatefulWidget {
  final List<SportMeetup> meetups;
  final String userName;
  final String defaultSubDistrict;
  final ValueChanged<SportMeetup> onAdd;
  final ValueChanged<String> onToggleJoin;

  const SportMeetupsScreen({
    super.key,
    required this.meetups,
    required this.userName,
    required this.defaultSubDistrict,
    required this.onAdd,
    required this.onToggleJoin,
  });

  @override
  State<SportMeetupsScreen> createState() => _SportMeetupsScreenState();
}

class _SportMeetupsScreenState extends State<SportMeetupsScreen> {
  late List<SportMeetup> _meetups;

  @override
  void initState() {
    super.initState();
    _meetups = List.of(widget.meetups);
  }

  Future<void> _add() async {
    final created = await showDialog<SportMeetup>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _SportDialog(
        userName: widget.userName,
        subDistrict: widget.defaultSubDistrict,
      ),
    );
    if (created == null) return;
    setState(() => _meetups = [created, ..._meetups]);
    widget.onAdd(created);
  }

  void _toggle(SportMeetup meetup) {
    final next = meetup.toggleJoin();
    if (next.joinedCount == meetup.joinedCount &&
        next.isJoined == meetup.isJoined) {
      return;
    }
    setState(() {
      _meetups = _meetups
          .map((item) => item.id == meetup.id ? next : item)
          .toList();
    });
    widget.onToggleJoin(meetup.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sport i rekreacja')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.sports_soccer_outlined),
        label: const Text('Nowa ustawka'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Piłka na Orliku, bieganie w parku, rowerowa masa — z limitem miejsc.',
          ),
          const SizedBox(height: 12),
          for (final meetup in _meetups)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meetup.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text('${meetup.place} · ${meetup.whenLabel}'),
                    Text(
                      'Uczestnicy: ${meetup.joinedCount}/${meetup.participantLimit} · ${meetup.authorName}',
                    ),
                    if (meetup.note.isNotEmpty) Text(meetup.note),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: meetup.isFull && !meetup.isJoined
                            ? null
                            : () => _toggle(meetup),
                        child: Text(
                          meetup.isJoined
                              ? 'Wypisz się'
                              : meetup.isFull
                                  ? 'Limit miejsc'
                                  : 'Dołącz',
                        ),
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

class _SportDialog extends StatefulWidget {
  final String userName;
  final String subDistrict;

  const _SportDialog({required this.userName, required this.subDistrict});

  @override
  State<_SportDialog> createState() => _SportDialogState();
}

class _SportDialogState extends State<_SportDialog> {
  final _title = TextEditingController();
  final _place = TextEditingController();
  final _when = TextEditingController();
  final _note = TextEditingController();
  var _limit = 10;
  late String _subDistrict;

  @override
  void initState() {
    super.initState();
    _subDistrict = widget.subDistrict;
  }

  @override
  void dispose() {
    _title.dispose();
    _place.dispose();
    _when.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Wydarzenie sportowe'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Tytuł'),
            ),
            TextField(
              controller: _place,
              decoration: const InputDecoration(labelText: 'Miejsce'),
            ),
            TextField(
              controller: _when,
              decoration: const InputDecoration(
                labelText: 'Termin (np. Wtorek, 18:00)',
              ),
            ),
            DropdownButtonFormField<int>(
              initialValue: _limit,
              decoration: const InputDecoration(labelText: 'Limit uczestników'),
              items: const [4, 6, 8, 10, 12, 16, 20]
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text('$item osób'),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _limit = value);
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
              SportMeetup(
                id: 'sport-${DateTime.now().microsecondsSinceEpoch}',
                title: _title.text.trim(),
                place: _place.text.trim().isEmpty
                    ? _subDistrict
                    : _place.text.trim(),
                whenLabel: _when.text.trim().isEmpty
                    ? 'Do uzgodnienia'
                    : _when.text.trim(),
                participantLimit: _limit,
                joinedCount: 1,
                isJoined: true,
                authorName: widget.userName,
                subDistrict: _subDistrict,
                note: _note.text.trim(),
              ),
            );
          },
          child: const Text('Utwórz'),
        ),
      ],
    );
  }
}
