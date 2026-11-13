import 'package:flutter/material.dart';

import '../models/holy_cross_trip.dart';
import '../theme/widzew_ui.dart';

class HolyCrossTripScreen extends StatefulWidget {
  final List<HolyCrossTrip> items;
  final String userName;
  final ValueChanged<HolyCrossTrip> onAdd;

  const HolyCrossTripScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<HolyCrossTripScreen> createState() => _HolyCrossTripScreenState();
}

class _HolyCrossTripScreenState extends State<HolyCrossTripScreen> {
  late List<HolyCrossTrip> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<HolyCrossTrip>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _TripDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Góry Świętokrzyskie')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.landscape_outlined),
        label: const Text('Wyjazd'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Wspólne weekendy i carpooling na piesze wędrówki poza województwo łódzkie.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.landscape_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.whenText} · ${item.meetingPoint}\n${item.seats} · ${item.authorName}',
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

  @override
  void dispose() {
    _title.dispose();
    _when.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Wycieczka'),
      content: Column(
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
              HolyCrossTrip(
                id: 'hc-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? 'Góry Świętokrzyskie'
                    : _title.text.trim(),
                whenText: _when.text.trim().isEmpty
                    ? 'Weekend'
                    : _when.text.trim(),
                meetingPoint: 'Pętla Widzew Wschód',
                seats: 'Miejsca do uzgodnienia',
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
