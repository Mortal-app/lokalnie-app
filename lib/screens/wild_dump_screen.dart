import 'package:flutter/material.dart';

import '../models/bike_station.dart';
import '../models/wild_dump.dart';
import '../theme/widzew_ui.dart';

class WildDumpScreen extends StatefulWidget {
  final List<WildDumpReport> items;
  final String userName;
  final ValueChanged<WildDumpReport> onAdd;

  const WildDumpScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<WildDumpScreen> createState() => _WildDumpScreenState();
}

class _WildDumpScreenState extends State<WildDumpScreen> {
  late List<WildDumpReport> _items;

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
    final created = await showDialog<WildDumpReport>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _DumpDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dzikie wysypiska')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.pin_drop_outlined),
        label: const Text('Pinezka zgłoszenia'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Porzucony gruz i opony w lasach i zieleńcach Widzewa — pinezka na mapie.',
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
                      'Mapa wysypisk',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  for (final item in _items)
                    Align(
                      alignment: _align(item.pos),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Icon(Icons.location_on, color: Color(0xFFC62828)),
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
                leading: const Icon(Icons.delete_outline),
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

class _DumpDialog extends StatefulWidget {
  final String userName;

  const _DumpDialog({required this.userName});

  @override
  State<_DumpDialog> createState() => _DumpDialogState();
}

class _DumpDialogState extends State<_DumpDialog> {
  final _place = TextEditingController();
  final _note = TextEditingController();
  var _kind = WildDumpKind.rubble;

  @override
  void dispose() {
    _place.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zgłoszenie wysypiska'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<WildDumpKind>(
              initialValue: _kind,
              items: [
                for (final kind in WildDumpKind.values)
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
              WildDumpReport(
                id: 'wd-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                place: _place.text.trim().isEmpty
                    ? 'Zieleń na Widzewie'
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
