import 'package:flutter/material.dart';

import '../models/parking_share.dart';

class ParkingShareScreen extends StatefulWidget {
  final List<ParkingShareOffer> items;
  final String userName;
  final ValueChanged<ParkingShareOffer> onAdd;

  const ParkingShareScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<ParkingShareScreen> createState() => _ParkingShareScreenState();
}

class _ParkingShareScreenState extends State<ParkingShareScreen> {
  late List<ParkingShareOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<ParkingShareOffer>(
      context: context,
      builder: (_) => _ParkDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Współdzielenie miejsc postojowych')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.local_parking),
        label: const Text('Oddaję miejsce'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Gdy wyjeżdżasz autem z osiedla w godzinach pracy — udostępnij miejsce sąsiadowi.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.local_parking),
                title: Text(item.title),
                subtitle: Text(
                  '${item.hours} · ${item.place}\n${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _ParkDialog extends StatefulWidget {
  final String userName;

  const _ParkDialog({required this.userName});

  @override
  State<_ParkDialog> createState() => _ParkDialogState();
}

class _ParkDialogState extends State<_ParkDialog> {
  final _place = TextEditingController();
  final _hours = TextEditingController(text: '8:00 - 16:00');

  @override
  void dispose() {
    _place.dispose();
    _hours.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Miejsce w godzinach pracy'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _hours,
            decoration: const InputDecoration(labelText: 'Godziny'),
          ),
          TextField(
            controller: _place,
            decoration: const InputDecoration(labelText: 'Lokalizacja'),
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
              ParkingShareOffer(
                id: 'pk-${DateTime.now().millisecondsSinceEpoch}',
                title: ParkingShareOffer.shareTitle,
                hours: _hours.text.trim().isEmpty
                    ? '8:00 - 16:00'
                    : _hours.text.trim(),
                place: _place.text.trim().isEmpty
                    ? 'Osiedle Widzew'
                    : _place.text.trim(),
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
