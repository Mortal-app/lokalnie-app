import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../models/carpool_ride.dart';
import '../theme/widzew_ui.dart';

class CarpoolScreen extends StatefulWidget {
  final List<CarpoolRide> rides;
  final String userName;
  final String defaultSubDistrict;
  final ValueChanged<CarpoolRide> onAdd;

  const CarpoolScreen({
    super.key,
    required this.rides,
    required this.userName,
    required this.defaultSubDistrict,
    required this.onAdd,
  });

  @override
  State<CarpoolScreen> createState() => _CarpoolScreenState();
}

class _CarpoolScreenState extends State<CarpoolScreen> {
  late List<CarpoolRide> _rides;

  @override
  void initState() {
    super.initState();
    _rides = List.of(widget.rides);
  }

  Future<void> _add() async {
    final created = await showDialog<CarpoolRide>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _RideDialog(
        userName: widget.userName,
        subDistrict: widget.defaultSubDistrict,
      ),
    );
    if (created == null) return;
    setState(() => _rides = [created, ..._rides]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jedziemy razem / Carpooling')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.directions_car_outlined),
        label: const Text('Dodaj trasę'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Wspólne dojazdy: wolne miejsca w aucie, stałe trasy do centrum i z powrotem na osiedle.',
          ),
          const SizedBox(height: 12),
          for (final ride in _rides)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(
                  ride.seekingSeat
                      ? Icons.hail_outlined
                      : Icons.airline_seat_recline_normal_outlined,
                ),
                title: Text(ride.title),
                subtitle: Text(
                  '${ride.fromPlace} → ${ride.toPlace}\n'
                  '${ride.time} · ${ride.seekingSeat ? 'Szukam miejsca' : 'Wolne miejsca: ${ride.seats}'} · ${ride.authorName}'
                  '${ride.note.isEmpty ? '' : '\n${ride.note}'}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _RideDialog extends StatefulWidget {
  final String userName;
  final String subDistrict;

  const _RideDialog({required this.userName, required this.subDistrict});

  @override
  State<_RideDialog> createState() => _RideDialogState();
}

class _RideDialogState extends State<_RideDialog> {
  final _title = TextEditingController();
  final _from = TextEditingController();
  final _to = TextEditingController();
  final _note = TextEditingController();
  var _time = const TimeOfDay(hour: 7, minute: 30);
  var _seats = 1;
  var _seeking = false;
  String _subDistrict = Announcement.subDistricts.first;

  @override
  void initState() {
    super.initState();
    _subDistrict = widget.subDistrict;
    _from.text = widget.subDistrict;
    _to.text = 'Centrum Łodzi';
  }

  @override
  void dispose() {
    _title.dispose();
    _from.dispose();
    _to.dispose();
    _note.dispose();
    super.dispose();
  }

  String get _timeLabel {
    final hour = _time.hour.toString().padLeft(2, '0');
    final minute = _time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nowa trasa carpoolingu'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Szukam miejsca w aucie'),
              value: _seeking,
              onChanged: (value) => setState(() => _seeking = value),
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Tytuł ogłoszenia'),
            ),
            TextField(
              controller: _from,
              decoration: const InputDecoration(labelText: 'Skąd'),
            ),
            TextField(
              controller: _to,
              decoration: const InputDecoration(labelText: 'Dokąd'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Godzina'),
              subtitle: Text(_timeLabel),
              trailing: const Icon(Icons.schedule_outlined),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: _time,
                );
                if (picked != null) setState(() => _time = picked);
              },
            ),
            DropdownButtonFormField<int>(
              initialValue: _seats,
              decoration: const InputDecoration(labelText: 'Wolne miejsca'),
              items: const [1, 2, 3, 4]
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text('$item'),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _seats = value);
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
            final from = _from.text.trim();
            final to = _to.text.trim();
            if (from.isEmpty || to.isEmpty) return;
            final title = _title.text.trim().isEmpty
                ? (_seeking
                      ? 'Szukam kogoś na wolne miejsce w aucie'
                      : 'Dojazd $from → $to o $_timeLabel')
                : _title.text.trim();
            Navigator.pop(
              context,
              CarpoolRide(
                id: 'ride-${DateTime.now().microsecondsSinceEpoch}',
                title: title,
                fromPlace: from,
                toPlace: to,
                time: _timeLabel,
                seats: _seeking ? 1 : _seats,
                seekingSeat: _seeking,
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
