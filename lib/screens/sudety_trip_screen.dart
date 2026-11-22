import 'package:flutter/material.dart';

import '../models/sudety_trip.dart';
import '../theme/widzew_ui.dart';

class SudetyTripScreen extends StatefulWidget {
  final List<SudetyTrip> items;
  final String userName;
  final ValueChanged<SudetyTrip> onAdd;

  const SudetyTripScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<SudetyTripScreen> createState() => _SudetyTripScreenState();
}

class _SudetyTripScreenState extends State<SudetyTripScreen> {
  late List<SudetyTrip> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<SudetyTrip>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _SudDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sudety i Karkonosze')),
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
            'Dłuższe wyprawy z okolicy na południe — Sudety i Karkonosze, podział paliwa.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.landscape_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.whenText} · ${item.meetingPoint}\n${item.seats} · ${item.fuelShare} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _SudDialog extends StatefulWidget {
  final String userName;

  const _SudDialog({required this.userName});

  @override
  State<_SudDialog> createState() => _SudDialogState();
}

class _SudDialogState extends State<_SudDialog> {
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
      title: const Text('Wyprawa'),
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
              SudetyTrip(
                id: 'su-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? 'Sudety / Karkonosze'
                    : _title.text.trim(),
                whenText: _when.text.trim().isEmpty
                    ? 'Weekend'
                    : _when.text.trim(),
                meetingPoint: 'Pętla osiedlowa',
                seats: 'Miejsca do uzgodnienia',
                fuelShare: 'Paliwo na spółkę',
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
