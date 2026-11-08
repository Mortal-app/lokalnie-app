import 'package:flutter/material.dart';

import '../models/car_oil.dart';

class CarOilScreen extends StatefulWidget {
  final List<CarOilReminder> items;
  final String userName;
  final ValueChanged<CarOilReminder> onAdd;

  const CarOilScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<CarOilScreen> createState() => _CarOilScreenState();
}

class _CarOilScreenState extends State<CarOilScreen> {
  late List<CarOilReminder> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<CarOilReminder>(
      context: context,
      builder: (_) => _OilDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  void _remind(CarOilReminder item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Przypomnienie serwisu: ${item.plateHint} — ${item.nextService}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Olej i filtry w aucie')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.car_repair_outlined),
        label: const Text('Serwis'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Przebieg i zbliżająca się wymiana oleju oraz filtrów — osobno od OC/AC.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.car_repair_outlined),
                title: Text(item.plateHint),
                subtitle: Text(
                  '${item.mileage}\n${item.nextService} · ${item.authorName}',
                ),
                isThreeLine: true,
                trailing: IconButton(
                  tooltip: 'Przypomnij',
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () => _remind(item),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OilDialog extends StatefulWidget {
  final String userName;

  const _OilDialog({required this.userName});

  @override
  State<_OilDialog> createState() => _OilDialogState();
}

class _OilDialogState extends State<_OilDialog> {
  final _plate = TextEditingController();
  final _km = TextEditingController();
  final _next = TextEditingController();

  @override
  void dispose() {
    _plate.dispose();
    _km.dispose();
    _next.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Serwis olejowy'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _plate,
            decoration: const InputDecoration(labelText: 'Auto / tablica'),
          ),
          TextField(
            controller: _km,
            decoration: const InputDecoration(labelText: 'Przebieg'),
          ),
          TextField(
            controller: _next,
            decoration: const InputDecoration(labelText: 'Następny serwis'),
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
              CarOilReminder(
                id: 'co-${DateTime.now().millisecondsSinceEpoch}',
                plateHint: _plate.text.trim().isEmpty
                    ? 'Auto pod blokiem'
                    : _plate.text.trim(),
                mileage: _km.text.trim().isEmpty
                    ? 'Przebieg do uzupełnienia'
                    : _km.text.trim(),
                nextService: _next.text.trim().isEmpty
                    ? 'Olej za 10 000 km'
                    : _next.text.trim(),
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
