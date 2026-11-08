import 'package:flutter/material.dart';

import '../models/weekend_trip.dart';

class WeekendTripsScreen extends StatefulWidget {
  final List<WeekendTrip> items;
  final String userName;
  final ValueChanged<WeekendTrip> onAdd;
  final ValueChanged<String> onJoin;

  const WeekendTripsScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
    required this.onJoin,
  });

  @override
  State<WeekendTripsScreen> createState() => _WeekendTripsScreenState();
}

class _WeekendTripsScreenState extends State<WeekendTripsScreen> {
  late List<WeekendTrip> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<WeekendTrip>(
      context: context,
      builder: (_) => _TripDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  void _join(WeekendTrip item) {
    setState(() {
      _items = _items
          .map(
            (entry) =>
                entry.id == item.id ? entry.copyWith(going: entry.going + 1) : entry,
          )
          .toList();
    });
    widget.onJoin(item.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Turystyka weekendowa')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.hiking),
        label: const Text('Nowy wypad'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Autokar lub rower: Mokra Lewa, Zalew Sulejowski, Łagiewniki.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(
                  item.kind == WeekendTripKind.bike
                      ? Icons.pedal_bike
                      : Icons.directions_bus_outlined,
                ),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.destination}\n${item.whenLabel} · ${item.host} · ${item.going} osób',
                ),
                isThreeLine: true,
                trailing: TextButton(
                  onPressed: () => _join(item),
                  child: const Text('Dołączam'),
                ),
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
  var _kind = WeekendTripKind.coach;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Wypad w łódzkie'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<WeekendTripKind>(
              initialValue: _kind,
              items: [
                for (final kind in WeekendTripKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Cel'),
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
              WeekendTrip(
                id: 'wt-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Wypad weekendowy'
                    : _title.text.trim(),
                destination: _title.text.trim().isEmpty
                    ? 'Łódzkie'
                    : _title.text.trim(),
                whenLabel: 'Sobota rano',
                host: widget.userName,
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
