import 'package:flutter/material.dart';

import '../models/bieszczady_trip.dart';

class BieszczadyTripScreen extends StatefulWidget {
  final List<BieszczadyTrip> items;
  final String userName;
  final ValueChanged<BieszczadyTrip> onAdd;

  const BieszczadyTripScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<BieszczadyTripScreen> createState() => _BieszczadyTripScreenState();
}

class _BieszczadyTripScreenState extends State<BieszczadyTripScreen> {
  late List<BieszczadyTrip> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<BieszczadyTrip>(
      context: context,
      builder: (_) => _TripDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carpooling: Bieszczady i Solina')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.directions_car_outlined),
        label: const Text('Wyjazd'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Wspólne dalekie wyprawy z Widzewa w Bieszczady i nad Solinę — miejsca w aucie i koordynacja załadunku bagaży.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.landscape_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.whenText} · ${item.meetingPoint}\n'
                  '${item.seats} · ${item.luggage} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _TripDialog extends StatefulWidget {
  final String userName;

  const _TripDialog({required this.userName});

  @override
  State<_TripDialog> createState() => _TripDialogState();
}

class _TripDialogState extends State<_TripDialog> {
  final _title = TextEditingController();
  final _when = TextEditingController();
  final _meet = TextEditingController();
  final _seats = TextEditingController();
  final _luggage = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _when.dispose();
    _meet.dispose();
    _seats.dispose();
    _luggage.dispose();
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
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Trasa'),
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
            TextField(
              controller: _luggage,
              decoration: const InputDecoration(labelText: 'Bagaż'),
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
              BieszczadyTrip(
                id: 'bz-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? 'Bieszczady / Solina'
                    : _title.text.trim(),
                whenText: _when.text.trim().isEmpty
                    ? 'Weekend'
                    : _when.text.trim(),
                meetingPoint: _meet.text.trim().isEmpty
                    ? 'Widzew Wschód'
                    : _meet.text.trim(),
                seats: _seats.text.trim().isEmpty
                    ? '2 miejsca'
                    : _seats.text.trim(),
                luggage: _luggage.text.trim(),
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
