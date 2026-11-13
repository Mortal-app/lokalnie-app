import 'package:flutter/material.dart';

import '../models/found_plate.dart';

class FoundPlatesScreen extends StatefulWidget {
  final List<FoundPlateAlert> items;
  final String userName;
  final ValueChanged<FoundPlateAlert> onAdd;

  const FoundPlatesScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<FoundPlatesScreen> createState() => _FoundPlatesScreenState();
}

class _FoundPlatesScreenState extends State<FoundPlatesScreen> {
  late List<FoundPlateAlert> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _quick({required FoundPlateKind kind}) async {
    final created = FoundPlateAlert(
      id: 'fp-${DateTime.now().millisecondsSinceEpoch}',
      kind: kind,
      place: 'Przy klatce / parkingu — do odbioru u zgłaszającego',
      note: kind == FoundPlateKind.plate
          ? 'Znaleziona tablica — bez pełnego numeru w ogłoszeniu.'
          : 'Znaleziony kluczyk — odbiór za opisem auta.',
      authorName: widget.userName,
      weather: 'Po ulewie lub śniegu',
    );
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Wysłano alert: ${kind.label}.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tablice i kluczyki')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          const Text(
            'Szybki alert o tablicach rejestracyjnych i kluczykach znalezionych po ulewach lub śniegu.',
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => _quick(kind: FoundPlateKind.plate),
            icon: const Icon(Icons.directions_car_outlined),
            label: const Text('Alert: znaleziona tablica'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _quick(kind: FoundPlateKind.carKey),
            icon: const Icon(Icons.vpn_key_outlined),
            label: const Text('Alert: znaleziony kluczyk'),
          ),
          const SizedBox(height: 16),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(
                  item.kind == FoundPlateKind.plate
                      ? Icons.directions_car_outlined
                      : Icons.vpn_key_outlined,
                ),
                title: Text(item.kind.label),
                subtitle: Text(
                  '${item.weather} · ${item.place}\n${item.note} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}
