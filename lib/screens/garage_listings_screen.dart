import 'package:flutter/material.dart';

import '../models/garage_listing.dart';
import '../theme/widzew_ui.dart';

class GarageListingsScreen extends StatefulWidget {
  final List<GarageListing> items;
  final String userName;
  final ValueChanged<GarageListing> onAdd;

  const GarageListingsScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<GarageListingsScreen> createState() => _GarageListingsScreenState();
}

class _GarageListingsScreenState extends State<GarageListingsScreen> {
  late List<GarageListing> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<GarageListing>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _GarageDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Garaże, miejsca i piwnice')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.garage_outlined),
        label: const Text('Dodaj ogłoszenie'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Wynajmę / dam w użytkowanie miejsce w garażu podziemnym lub box w piwnicy w Twojej okolicy.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.directions_car_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.offer.label} · ${item.space.label}\n${item.place}\n${item.details} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _GarageDialog extends StatefulWidget {
  final String userName;

  const _GarageDialog({required this.userName});

  @override
  State<_GarageDialog> createState() => _GarageDialogState();
}

class _GarageDialogState extends State<_GarageDialog> {
  final _place = TextEditingController();
  final _details = TextEditingController();
  var _offer = GarageOfferKind.rent;
  var _space = GarageSpaceKind.underground;

  @override
  void dispose() {
    _place.dispose();
    _details.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Miejsce postojowe / piwnica'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<GarageOfferKind>(
              initialValue: _offer,
              items: [
                for (final kind in GarageOfferKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _offer = value);
              },
            ),
            DropdownButtonFormField<GarageSpaceKind>(
              initialValue: _space,
              items: [
                for (final kind in GarageSpaceKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _space = value);
              },
            ),
            TextField(
              controller: _place,
              decoration: const InputDecoration(labelText: 'Lokalizacja'),
            ),
            TextField(
              controller: _details,
              decoration: const InputDecoration(labelText: 'Szczegóły'),
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
              GarageListing(
                id: 'gar-${DateTime.now().millisecondsSinceEpoch}',
                offer: _offer,
                space: _space,
                title: '${_offer.label} ${_space.label.toLowerCase()}',
                place: _place.text.trim().isEmpty
                    ? 'Okolica'
                    : _place.text.trim(),
                details: _details.text.trim(),
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
