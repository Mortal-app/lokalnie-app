import 'package:flutter/material.dart';

import '../models/bike_station.dart';
import '../models/wildlife_shelter.dart';
import '../theme/widzew_ui.dart';

class WildlifeShelterScreen extends StatefulWidget {
  final List<WildlifeShelter> items;
  final String userName;
  final ValueChanged<WildlifeShelter> onAdd;

  const WildlifeShelterScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<WildlifeShelterScreen> createState() => _WildlifeShelterScreenState();
}

class _WildlifeShelterScreenState extends State<WildlifeShelterScreen> {
  late List<WildlifeShelter> _items;

  Alignment _align(StationAlign pos) => switch (pos) {
    StationAlign.topLeft => Alignment.topLeft,
    StationAlign.center => Alignment.center,
    StationAlign.bottomRight => Alignment.bottomRight,
  };

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<WildlifeShelter>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _ShelterDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Domki owadów i budki')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.hive_outlined),
        label: const Text('Nowe schronienie'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Schronienia dla ptaków i owadów pożytecznych w zieleni okolicy.',
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFA5D6A7)),
              ),
              child: Stack(
                children: [
                  const Positioned(
                    left: 8,
                    top: 8,
                    child: Text(
                      'Mapa schronień',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  for (final item in _items)
                    Align(
                      alignment: _align(item.pos),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Icon(Icons.hive_outlined, color: Color(0xFF2E7D32)),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.hive_outlined),
                title: Text(item.kind.label),
                subtitle: Text('${item.place}\n${item.note} · ${item.authorName}'),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _ShelterDialog extends StatefulWidget {
  final String userName;

  const _ShelterDialog({required this.userName});

  @override
  State<_ShelterDialog> createState() => _ShelterDialogState();
}

class _ShelterDialogState extends State<_ShelterDialog> {
  var _kind = ShelterKind.insectHotel;
  final _place = TextEditingController();
  final _note = TextEditingController();

  @override
  void dispose() {
    _place.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Schronienie'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<ShelterKind>(
            initialValue: _kind,
            items: [
              for (final kind in ShelterKind.values)
                DropdownMenuItem(value: kind, child: Text(kind.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _kind = value);
            },
          ),
          TextField(
            controller: _place,
            decoration: const InputDecoration(labelText: 'Lokalizacja'),
          ),
          TextField(
            controller: _note,
            decoration: const InputDecoration(labelText: 'Opis'),
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
              WildlifeShelter(
                id: 'ws-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                place: _place.text.trim().isEmpty
                    ? 'Zieleń w Twojej okolicy'
                    : _place.text.trim(),
                note: _note.text.trim(),
                authorName: widget.userName,
                pos: StationAlign.center,
              ),
            );
          },
          child: const Text('Zgłoś'),
        ),
      ],
    );
  }
}
