import 'package:flutter/material.dart';

import '../models/mushroom_trip.dart';

class MushroomTripScreen extends StatefulWidget {
  final List<MushroomTrip> items;
  final String userName;
  final ValueChanged<MushroomTrip> onAdd;

  const MushroomTripScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<MushroomTripScreen> createState() => _MushroomTripScreenState();
}

class _MushroomTripScreenState extends State<MushroomTripScreen> {
  late List<MushroomTrip> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<MushroomTrip>(
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
      appBar: AppBar(title: const Text('Grzyby i Las Łagiewnicki')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.park_outlined),
        label: const Text('Nowy wypad'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Sezonowe wyjazdy na grzybobranie i spacery do kompleksów leśnych wokół Łodzi.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.park_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.forest} · ${item.whenText}\n${item.meetingPoint} · ${item.authorName}',
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

  @override
  void dispose() {
    _title.dispose();
    _when.dispose();
    _meet.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Wypad do lasu'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
        ],
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
              MushroomTrip(
                id: 'mt-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? 'Grzybobranie w Łagiewnikach'
                    : _title.text.trim(),
                whenText: _when.text.trim().isEmpty
                    ? 'Sobota rano'
                    : _when.text.trim(),
                meetingPoint: _meet.text.trim().isEmpty
                    ? 'Pętla Widzew Wschód'
                    : _meet.text.trim(),
                forest: 'Las Łagiewnicki',
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
