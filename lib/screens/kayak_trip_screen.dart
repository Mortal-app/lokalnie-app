import 'package:flutter/material.dart';

import '../models/kayak_trip.dart';

class KayakTripScreen extends StatefulWidget {
  final List<KayakTrip> items;
  final String userName;
  final ValueChanged<KayakTrip> onAdd;

  const KayakTripScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<KayakTripScreen> createState() => _KayakTripScreenState();
}

class _KayakTripScreenState extends State<KayakTripScreen> {
  late List<KayakTrip> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<KayakTrip>(
      context: context,
      builder: (_) => _KayakDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spływy kajakowe')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.directions_boat_outlined),
        label: const Text('Spływ'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Carpooling na Pilicę i Wartę — miejsca w aucie i podział kosztów sprzętu.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.directions_boat_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.river} · ${item.whenText}\n${item.seats} · ${item.gearShare} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _KayakDialog extends StatefulWidget {
  final String userName;

  const _KayakDialog({required this.userName});

  @override
  State<_KayakDialog> createState() => _KayakDialogState();
}

class _KayakDialogState extends State<_KayakDialog> {
  final _title = TextEditingController();
  final _river = TextEditingController();
  final _when = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _river.dispose();
    _when.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Spływ'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Tytuł'),
          ),
          TextField(
            controller: _river,
            decoration: const InputDecoration(labelText: 'Rzeka'),
          ),
          TextField(
            controller: _when,
            decoration: const InputDecoration(labelText: 'Termin'),
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
              KayakTrip(
                id: 'kt-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? 'Spływ kajakowy'
                    : _title.text.trim(),
                river: _river.text.trim().isEmpty
                    ? 'Pilica'
                    : _river.text.trim(),
                whenText: _when.text.trim().isEmpty
                    ? 'Weekend'
                    : _when.text.trim(),
                seats: 'Miejsca do uzgodnienia',
                gearShare: 'Sprzęt do zrzutki',
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
