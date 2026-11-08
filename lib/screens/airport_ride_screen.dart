import 'package:flutter/material.dart';

import '../models/airport_ride.dart';

class AirportRideScreen extends StatefulWidget {
  final List<AirportRide> items;
  final String userName;
  final ValueChanged<AirportRide> onAdd;

  const AirportRideScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<AirportRideScreen> createState() => _AirportRideScreenState();
}

class _AirportRideScreenState extends State<AirportRideScreen> {
  late List<AirportRide> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<AirportRide>(
      context: context,
      builder: (_) => _AirDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carpooling na lotnisko')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.flight_takeoff_outlined),
        label: const Text('Kurs'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Modlin, Okęcie i Łódź-Lublinek — podział kosztów autostrady i parkingu.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.flight_takeoff_outlined),
                title: Text(item.hub.label),
                subtitle: Text(
                  '${item.whenText}\n${item.costNote} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _AirDialog extends StatefulWidget {
  final String userName;

  const _AirDialog({required this.userName});

  @override
  State<_AirDialog> createState() => _AirDialogState();
}

class _AirDialogState extends State<_AirDialog> {
  var _hub = AirportHub.lublinek;
  final _when = TextEditingController();
  final _cost = TextEditingController();

  @override
  void dispose() {
    _when.dispose();
    _cost.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Kurs na lotnisko'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<AirportHub>(
            initialValue: _hub,
            items: [
              for (final hub in AirportHub.values)
                DropdownMenuItem(value: hub, child: Text(hub.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _hub = value);
            },
          ),
          TextField(
            controller: _when,
            decoration: const InputDecoration(labelText: 'Termin'),
          ),
          TextField(
            controller: _cost,
            decoration: const InputDecoration(labelText: 'Koszty'),
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
              AirportRide(
                id: 'ar-${DateTime.now().millisecondsSinceEpoch}',
                hub: _hub,
                whenText: _when.text.trim().isEmpty
                    ? 'Do uzgodnienia'
                    : _when.text.trim(),
                costNote: _cost.text.trim().isEmpty
                    ? 'Dzielimy autostradę i parking'
                    : _cost.text.trim(),
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
