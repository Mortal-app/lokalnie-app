import 'package:flutter/material.dart';

import '../models/car_policy.dart';

class CarPolicyScreen extends StatefulWidget {
  final List<CarPolicyReminder> items;
  final String userName;
  final ValueChanged<CarPolicyReminder> onAdd;

  const CarPolicyScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<CarPolicyScreen> createState() => _CarPolicyScreenState();
}

class _CarPolicyScreenState extends State<CarPolicyScreen> {
  late List<CarPolicyReminder> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<CarPolicyReminder>(
      context: context,
      builder: (_) => _PolicyDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  void _remind(CarPolicyReminder item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Przypomnienie: ${item.plateHint} — ${item.ocAcUntil}, ${item.reviewUntil}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OC/AC i przegląd auta')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.directions_car_outlined),
        label: const Text('Polisa'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Daty ważności OC/AC i przeglądów rejestracyjnych aut parkujących pod blokiem.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.directions_car_outlined),
                title: Text(item.plateHint),
                subtitle: Text(
                  '${item.ocAcUntil}\n${item.reviewUntil} · ${item.authorName}',
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

class _PolicyDialog extends StatefulWidget {
  final String userName;

  const _PolicyDialog({required this.userName});

  @override
  State<_PolicyDialog> createState() => _PolicyDialogState();
}

class _PolicyDialogState extends State<_PolicyDialog> {
  final _plate = TextEditingController();
  final _oc = TextEditingController();
  final _review = TextEditingController();

  @override
  void dispose() {
    _plate.dispose();
    _oc.dispose();
    _review.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Polisa / przegląd'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _plate,
            decoration: const InputDecoration(labelText: 'Auto / tablica'),
          ),
          TextField(
            controller: _oc,
            decoration: const InputDecoration(labelText: 'OC/AC do'),
          ),
          TextField(
            controller: _review,
            decoration: const InputDecoration(labelText: 'Przegląd do'),
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
              CarPolicyReminder(
                id: 'cp-${DateTime.now().millisecondsSinceEpoch}',
                plateHint: _plate.text.trim().isEmpty
                    ? 'Auto pod blokiem'
                    : _plate.text.trim(),
                ocAcUntil: _oc.text.trim().isEmpty
                    ? 'OC do uzgodnienia'
                    : _oc.text.trim(),
                reviewUntil: _review.text.trim().isEmpty
                    ? 'Przegląd do uzgodnienia'
                    : _review.text.trim(),
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
