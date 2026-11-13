import 'package:flutter/material.dart';

import '../models/thermal_trip.dart';
import '../theme/widzew_ui.dart';

class ThermalTripScreen extends StatefulWidget {
  final List<ThermalTrip> items;
  final String userName;
  final ValueChanged<ThermalTrip> onAdd;

  const ThermalTripScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<ThermalTripScreen> createState() => _ThermalTripScreenState();
}

class _ThermalTripScreenState extends State<ThermalTripScreen> {
  late List<ThermalTrip> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<ThermalTrip>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _TermDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Termy i baseny')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.hot_tub_outlined),
        label: const Text('Wyjazd'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Carpooling do Uniejowa i Mszczonowa — miejsca w aucie i podział kosztów.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.hot_tub_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.place} · ${item.whenText}\n${item.seats} · ${item.costShare} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _TermDialog extends StatefulWidget {
  final String userName;

  const _TermDialog({required this.userName});

  @override
  State<_TermDialog> createState() => _TermDialogState();
}

class _TermDialogState extends State<_TermDialog> {
  final _title = TextEditingController();
  final _place = TextEditingController();
  final _when = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _place.dispose();
    _when.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Termy'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Tytuł'),
          ),
          TextField(
            controller: _place,
            decoration: const InputDecoration(labelText: 'Uniejów / Mszczonów'),
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
              ThermalTrip(
                id: 'th-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? 'Wyjazd do term'
                    : _title.text.trim(),
                place: _place.text.trim().isEmpty
                    ? 'Uniejów'
                    : _place.text.trim(),
                whenText: _when.text.trim().isEmpty
                    ? 'Weekend'
                    : _when.text.trim(),
                seats: 'Miejsca do uzgodnienia',
                costShare: 'Paliwo na spółkę',
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
