import 'package:flutter/material.dart';

import '../models/drone_alert.dart';

class DroneAlertsScreen extends StatefulWidget {
  final List<DroneAlert> items;
  final String userName;
  final ValueChanged<DroneAlert> onAdd;
  final ValueChanged<String> onSpot;

  const DroneAlertsScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
    required this.onSpot,
  });

  @override
  State<DroneAlertsScreen> createState() => _DroneAlertsScreenState();
}

class _DroneAlertsScreenState extends State<DroneAlertsScreen> {
  late List<DroneAlert> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<DroneAlert>(
      context: context,
      builder: (_) => _DroneDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  void _spot(DroneAlert alert) {
    setState(() {
      _items = _items
          .map((item) => item.id == alert.id ? item.spot() : item)
          .toList();
    });
    widget.onSpot(alert.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Poszukiwacze dronów')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.flight_outlined),
        label: const Text('Alert zaginięcia'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Zaginął dron lub model RC — namierzanie przez lokalnych operatorów.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(item.place),
                    Text(item.details),
                    Text(
                      'Operatorzy namierzyli: ${item.operatorSpots} · ${item.authorName}',
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _spot(item),
                        child: const Text('Widziałem / namierzam'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DroneDialog extends StatefulWidget {
  final String userName;

  const _DroneDialog({required this.userName});

  @override
  State<_DroneDialog> createState() => _DroneDialogState();
}

class _DroneDialogState extends State<_DroneDialog> {
  final _details = TextEditingController();
  final _place = TextEditingController(text: 'Park Baden-Powella');

  @override
  void dispose() {
    _details.dispose();
    _place.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Alert modelarski'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _place,
              decoration: const InputDecoration(labelText: 'Miejsce'),
            ),
            TextField(
              controller: _details,
              decoration: const InputDecoration(labelText: 'Opis modelu'),
              maxLines: 3,
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
              DroneAlert(
                id: 'drone-${DateTime.now().millisecondsSinceEpoch}',
                title:
                    'Zaginął dron / model RC w koronie drzew w ${_place.text.trim().isEmpty ? 'Parku Baden-Powella' : _place.text.trim()}',
                place: _place.text.trim().isEmpty
                    ? 'Park Baden-Powella'
                    : _place.text.trim(),
                details: _details.text.trim(),
                authorName: widget.userName,
              ),
            );
          },
          child: const Text('Wyślij alert'),
        ),
      ],
    );
  }
}
