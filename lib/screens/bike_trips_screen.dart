import 'package:flutter/material.dart';

import '../models/bike_trip.dart';
import '../theme/widzew_ui.dart';

class BikeTripsScreen extends StatefulWidget {
  final List<BikeTrip> items;
  final String userName;
  final ValueChanged<BikeTrip> onAdd;
  final ValueChanged<String> onJoin;

  const BikeTripsScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
    required this.onJoin,
  });

  @override
  State<BikeTripsScreen> createState() => _BikeTripsScreenState();
}

class _BikeTripsScreenState extends State<BikeTripsScreen> {
  late List<BikeTrip> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<BikeTrip>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _TripDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  void _join(BikeTrip item) {
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
      appBar: AppBar(title: const Text('Rowerem po Łodzi')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.directions_bike),
        label: const Text('Nowa trasa'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Wspólne trasy: rzeka, lasy, stawy — tablica wypraw.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.pedal_bike),
                title: Text(item.title),
                subtitle: Text(
                  '${item.route}\n${item.whenLabel} · ${item.host} · ${item.going} osób',
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
  final _route = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _route.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Wyprawa rowerowa'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Nazwa'),
            ),
            TextField(
              controller: _route,
              decoration: const InputDecoration(labelText: 'Trasa'),
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
              BikeTrip(
                id: 'bt-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? 'Wyprawa osiedlowa'
                    : _title.text.trim(),
                route: _route.text.trim().isEmpty
                    ? 'Osiedle — pętla'
                    : _route.text.trim(),
                whenLabel: 'Sobota 9:00',
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
