import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../models/parcel_locker.dart';
import '../theme/widzew_ui.dart';

class ParcelLockerScreen extends StatefulWidget {
  final List<ParcelLocker> lockers;
  final String userName;
  final String defaultSubDistrict;
  final ValueChanged<ParcelLocker> onAdd;
  final void Function(String id, int occupied) onUpdateOccupied;

  const ParcelLockerScreen({
    super.key,
    required this.lockers,
    required this.userName,
    required this.defaultSubDistrict,
    required this.onAdd,
    required this.onUpdateOccupied,
  });

  @override
  State<ParcelLockerScreen> createState() => _ParcelLockerScreenState();
}

class _ParcelLockerScreenState extends State<ParcelLockerScreen> {
  late List<ParcelLocker> _lockers;

  @override
  void initState() {
    super.initState();
    _lockers = List.of(widget.lockers);
  }

  Future<void> _add() async {
    final created = await showDialog<ParcelLocker>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _LockerDialog(
        userName: widget.userName,
        subDistrict: widget.defaultSubDistrict,
      ),
    );
    if (created == null) return;
    setState(() => _lockers = [created, ..._lockers]);
    widget.onAdd(created);
  }

  void _setOccupied(ParcelLocker locker, int occupied) {
    final next = occupied.clamp(0, locker.slots);
    setState(() {
      _lockers = _lockers
          .map(
            (item) =>
                item.id == locker.id ? item.copyWith(occupied: next) : item,
          )
          .toList();
    });
    widget.onUpdateOccupied(locker.id, next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bezpieczny Punkt Odbioru')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.home_outlined),
        label: const Text('Zgłoś dostępność'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Sąsiedzki locker: tymczasowe przechowanie paczki kurierskiej, gdy nikogo nie ma w domu.',
          ),
          const SizedBox(height: 12),
          for (final locker in _lockers)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locker.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text('${locker.hostName} · ${locker.subDistrict}'),
                    Text(locker.place),
                    Text('Godziny: ${locker.hours}'),
                    if (locker.note.isNotEmpty) Text(locker.note),
                    const SizedBox(height: 8),
                    Chip(
                      visualDensity: VisualDensity.compact,
                      label: Text(
                        '${locker.status.label} · wolne ${locker.freeSlots}/${locker.slots}',
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: locker.occupied <= 0
                              ? null
                              : () => _setOccupied(
                                    locker,
                                    locker.occupied - 1,
                                  ),
                          child: const Text('Zwolnij miejsce'),
                        ),
                        TextButton(
                          onPressed: locker.occupied >= locker.slots
                              ? null
                              : () => _setOccupied(
                                    locker,
                                    locker.occupied + 1,
                                  ),
                          child: const Text('Zajmij miejsce'),
                        ),
                      ],
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

class _LockerDialog extends StatefulWidget {
  final String userName;
  final String subDistrict;

  const _LockerDialog({required this.userName, required this.subDistrict});

  @override
  State<_LockerDialog> createState() => _LockerDialogState();
}

class _LockerDialogState extends State<_LockerDialog> {
  final _title = TextEditingController();
  final _place = TextEditingController();
  final _hours = TextEditingController();
  final _note = TextEditingController();
  var _slots = 2;
  var _occupied = 0;
  String _subDistrict = Announcement.subDistricts.first;

  @override
  void initState() {
    super.initState();
    _subDistrict = widget.subDistrict;
    _title.text = 'Przechowalnia u ${widget.userName}';
  }

  @override
  void dispose() {
    _title.dispose();
    _place.dispose();
    _hours.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zgłoś punkt odbioru'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Nazwa punktu'),
            ),
            TextField(
              controller: _place,
              decoration: const InputDecoration(
                labelText: 'Adres / klatka / dzwonek',
              ),
            ),
            TextField(
              controller: _hours,
              decoration: const InputDecoration(labelText: 'Godziny odbioru'),
            ),
            DropdownButtonFormField<int>(
              initialValue: _slots,
              decoration: const InputDecoration(labelText: 'Liczba miejsc'),
              items: const [1, 2, 3, 4]
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text('$item'),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _slots = value;
                    if (_occupied > _slots) _occupied = _slots;
                  });
                }
              },
            ),
            DropdownButtonFormField<ParcelLockerStatus>(
              initialValue: _occupied >= _slots
                  ? ParcelLockerStatus.occupied
                  : ParcelLockerStatus.free,
              decoration: const InputDecoration(labelText: 'Status'),
              items: ParcelLockerStatus.values
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _occupied = value == ParcelLockerStatus.occupied ? _slots : 0;
                });
              },
            ),
            TextField(
              controller: _note,
              decoration: const InputDecoration(
                labelText: 'Uwagi (waga, godziny ciszy)',
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
            if (_title.text.trim().isEmpty || _place.text.trim().isEmpty) {
              return;
            }
            Navigator.pop(
              context,
              ParcelLocker(
                id: 'locker-${DateTime.now().microsecondsSinceEpoch}',
                title: _title.text.trim(),
                hostName: widget.userName,
                place: _place.text.trim(),
                hours: _hours.text.trim().isEmpty
                    ? 'Do uzgodnienia'
                    : _hours.text.trim(),
                note: _note.text.trim(),
                subDistrict: _subDistrict,
                slots: _slots,
                occupied: _occupied.clamp(0, _slots),
              ),
            );
          },
          child: const Text('Zgłoś'),
        ),
      ],
    );
  }
}
