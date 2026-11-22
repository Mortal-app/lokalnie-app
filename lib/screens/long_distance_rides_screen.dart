import 'package:flutter/material.dart';

import '../models/long_distance_ride.dart';
import '../theme/widzew_ui.dart';

class LongDistanceRidesScreen extends StatefulWidget {
  final List<LongDistanceRide> items;
  final String userName;
  final ValueChanged<LongDistanceRide> onAdd;

  const LongDistanceRidesScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<LongDistanceRidesScreen> createState() =>
      _LongDistanceRidesScreenState();
}

class _LongDistanceRidesScreenState extends State<LongDistanceRidesScreen> {
  late List<LongDistanceRide> _items;
  LongHaulDest? _dest;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  List<LongDistanceRide> get _visible => _dest == null
      ? _items
      : _items.where((item) => item.destination == _dest).toList();

  Future<void> _add() async {
    final created = await showDialog<LongDistanceRide>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _RideDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transport dalekobieżny')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.airport_shuttle_outlined),
        label: const Text('Dodaj kurs'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Wspólne wypady na Łódź Fabryczną, Kaliską lub lotnisko — podział kosztów paliwa.',
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: const Text('Wszystkie'),
                selected: _dest == null,
                onSelected: (_) => setState(() => _dest = null),
              ),
              for (final dest in LongHaulDest.values.take(2))
                FilterChip(
                  label: Text(dest.label),
                  selected: _dest == dest,
                  onSelected: (_) => setState(() => _dest = dest),
                ),
            ],
          ),
          const SizedBox(height: 12),
          for (final item in _visible)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.directions_car_outlined),
                title: Text('${item.fromPlace} → ${item.destination.label}'),
                subtitle: Text(
                  '${item.time} · ${item.seats} miejsca · paliwo ${item.fuelShare.toStringAsFixed(0)} zł/os.\n'
                  '${item.authorName}'
                  '${item.note.isEmpty ? '' : ' · ${item.note}'}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _RideDialog extends StatefulWidget {
  final String userName;

  const _RideDialog({required this.userName});

  @override
  State<_RideDialog> createState() => _RideDialogState();
}

class _RideDialogState extends State<_RideDialog> {
  final _from = TextEditingController(text: 'Okolica');
  final _time = TextEditingController(text: '6:00');
  final _fuel = TextEditingController(text: '15');
  var _dest = LongHaulDest.fabryczna;

  @override
  void dispose() {
    _from.dispose();
    _time.dispose();
    _fuel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Kurs dalekobieżny'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<LongHaulDest>(
              initialValue: _dest,
              items: [
                for (final dest in LongHaulDest.values)
                  DropdownMenuItem(value: dest, child: Text(dest.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _dest = value);
              },
            ),
            TextField(
              controller: _from,
              decoration: const InputDecoration(labelText: 'Skąd'),
            ),
            TextField(
              controller: _time,
              decoration: const InputDecoration(labelText: 'Godzina'),
            ),
            TextField(
              controller: _fuel,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Udział w paliwie (zł/os.)',
              ),
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
              LongDistanceRide(
                id: 'ld-${DateTime.now().millisecondsSinceEpoch}',
                destination: _dest,
                fromPlace: _from.text.trim(),
                time: _time.text.trim(),
                seats: 2,
                fuelShare:
                    double.tryParse(_fuel.text.trim().replaceAll(',', '.')) ??
                    15,
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
