import 'package:flutter/material.dart';

import '../models/grill_event.dart';
import '../theme/widzew_ui.dart';

class GrillZoneScreen extends StatefulWidget {
  final List<GrillEvent> events;
  final List<PortableGrill> grills;
  final String userName;
  final ValueChanged<GrillEvent> onAddEvent;
  final ValueChanged<String> onReserveGrill;

  const GrillZoneScreen({
    super.key,
    required this.events,
    required this.grills,
    required this.userName,
    required this.onAddEvent,
    required this.onReserveGrill,
  });

  @override
  State<GrillZoneScreen> createState() => _GrillZoneScreenState();
}

class _GrillZoneScreenState extends State<GrillZoneScreen> {
  late List<GrillEvent> _events;
  late List<PortableGrill> _grills;

  @override
  void initState() {
    super.initState();
    _events = List.of(widget.events);
    _grills = List.of(widget.grills);
  }

  Future<void> _add() async {
    final created = await showDialog<GrillEvent>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _GrillDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _events = [created, ..._events]);
    widget.onAddEvent(created);
  }

  void _reserve(PortableGrill grill) {
    if (grill.reserved) return;
    setState(() {
      _grills = _grills
          .map(
            (item) =>
                item.id == grill.id ? item.copyWith(reserved: true) : item,
          )
          .toList();
    });
    widget.onReserveGrill(grill.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Strefa grilla i pleneru')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.outdoor_grill_outlined),
        label: const Text('Zorganizuj grilla'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Wspólne wypady: Park Baden-Powella, Stawy Stefańskiego i dziedziniec. Rezerwacja grilli przenośnych.',
          ),
          const SizedBox(height: 12),
          for (final item in _events)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.outdoor_grill),
                title: Text(item.title),
                subtitle: Text(
                  '${item.spot.label} · ${item.whenLabel}\n${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
          const Text(
            'Grille przenośne',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          for (final grill in _grills)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(grill.name),
                subtitle: Text(grill.owner),
                trailing: TextButton(
                  onPressed: grill.reserved ? null : () => _reserve(grill),
                  child: Text(grill.reserved ? 'Zarezerwowany' : 'Rezerwuj'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GrillDialog extends StatefulWidget {
  final String userName;

  const _GrillDialog({required this.userName});

  @override
  State<_GrillDialog> createState() => _GrillDialogState();
}

class _GrillDialogState extends State<_GrillDialog> {
  final _title = TextEditingController();
  var _spot = GrillSpot.badenPowell;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Wypad na grilla'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<GrillSpot>(
              initialValue: _spot,
              items: [
                for (final spot in GrillSpot.values)
                  DropdownMenuItem(value: spot, child: Text(spot.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _spot = value);
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
              GrillEvent(
                id: 'gr-${DateTime.now().millisecondsSinceEpoch}',
                spot: _spot,
                title: _title.text.trim().isEmpty
                    ? 'Grill — ${_spot.label}'
                    : _title.text.trim(),
                whenLabel: 'Wkrótce',
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
