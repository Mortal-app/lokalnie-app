import 'package:flutter/material.dart';

import '../models/landscape_park_trip.dart';
import '../theme/widzew_ui.dart';

class LandscapeParkTripScreen extends StatefulWidget {
  final List<LandscapeParkTrip> items;
  final String userName;
  final ValueChanged<LandscapeParkTrip> onAdd;

  const LandscapeParkTripScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<LandscapeParkTripScreen> createState() =>
      _LandscapeParkTripScreenState();
}

class _LandscapeParkTripScreenState extends State<LandscapeParkTripScreen> {
  late List<LandscapeParkTrip> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<LandscapeParkTrip>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _ParkTripDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parki krajobrazowe — carpooling')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.directions_car_outlined),
        label: const Text('Wyjazd'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Weekendowe wycieczki piesze i pikniki w otulinie Parku Krajobrazowego Wzniesień Łódzkich oraz Spalskiego.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.terrain_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.whenText}\n'
                  '${item.meetingPoint} · ${item.seats} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _ParkTripDialog extends StatefulWidget {
  final String userName;

  const _ParkTripDialog({required this.userName});

  @override
  State<_ParkTripDialog> createState() => _ParkTripDialogState();
}

class _ParkTripDialogState extends State<_ParkTripDialog> {
  var _kind = LandscapeParkKind.wzniesienia;
  final _title = TextEditingController();
  final _when = TextEditingController();
  final _meet = TextEditingController();
  final _seats = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _when.dispose();
    _meet.dispose();
    _seats.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nowy wyjazd'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<LandscapeParkKind>(
              initialValue: _kind,
              items: [
                for (final kind in LandscapeParkKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Tytuł'),
            ),
            TextField(
              controller: _when,
              decoration: const InputDecoration(labelText: 'Termin'),
            ),
            TextField(
              controller: _meet,
              decoration: const InputDecoration(labelText: 'Zbiórka'),
            ),
            TextField(
              controller: _seats,
              decoration: const InputDecoration(labelText: 'Miejsca'),
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
              LandscapeParkTrip(
                id: 'lp-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                whenText: _when.text.trim().isEmpty
                    ? 'Weekend'
                    : _when.text.trim(),
                meetingPoint: _meet.text.trim().isEmpty
                    ? 'Okolica'
                    : _meet.text.trim(),
                seats: _seats.text.trim().isEmpty
                    ? '2 miejsca'
                    : _seats.text.trim(),
                authorName: widget.userName,
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
