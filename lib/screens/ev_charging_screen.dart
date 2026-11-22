import 'package:flutter/material.dart';

import '../models/ev_charging.dart';
import '../theme/widzew_ui.dart';

class EvChargingScreen extends StatefulWidget {
  final List<EvChargingOffer> items;
  final String userName;
  final ValueChanged<EvChargingOffer> onAdd;
  final ValueChanged<String> onConsent;

  const EvChargingScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
    required this.onConsent,
  });

  @override
  State<EvChargingScreen> createState() => _EvChargingScreenState();
}

class _EvChargingScreenState extends State<EvChargingScreen> {
  late List<EvChargingOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<EvChargingOffer>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _EvDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  void _consent(EvChargingOffer item) {
    if (item.neighborConsent) return;
    setState(() {
      _items = _items
          .map(
            (entry) => entry.id == item.id
                ? entry.copyWith(neighborConsent: true)
                : entry,
          )
          .toList();
    });
    widget.onConsent(item.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ładowanie EV i kabel balkonowy')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.ev_station_outlined),
        label: const Text('Dodaj ofertę'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Koordynacja ładowania EV/hybryd i bezpieczny kabel z parteru — za zgodą sąsiadów.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.electrical_services_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label}\n${item.place} · ${item.hours} · ${item.authorName}',
                ),
                isThreeLine: true,
                trailing: TextButton(
                  onPressed: item.neighborConsent
                      ? null
                      : () => _consent(item),
                  child: Text(
                    item.neighborConsent ? 'Zgoda sąsiadów' : 'Wyrażam zgodę',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EvDialog extends StatefulWidget {
  final String userName;

  const _EvDialog({required this.userName});

  @override
  State<_EvDialog> createState() => _EvDialogState();
}

class _EvDialogState extends State<_EvDialog> {
  final _title = TextEditingController();
  var _kind = EvChargeKind.balconyCable;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ładowanie przy bloku'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<EvChargeKind>(
              initialValue: _kind,
              items: [
                for (final kind in EvChargeKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Opis'),
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
              EvChargingOffer(
                id: 'ev-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                place: 'Okolica',
                hours: 'Po 18:00',
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
