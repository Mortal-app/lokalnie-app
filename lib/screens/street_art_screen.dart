import 'package:flutter/material.dart';

import '../models/bike_station.dart';
import '../models/street_art.dart';
import '../theme/widzew_ui.dart';

class StreetArtScreen extends StatefulWidget {
  final List<StreetArtSpot> items;
  final String userName;
  final ValueChanged<StreetArtSpot> onAdd;

  const StreetArtScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<StreetArtScreen> createState() => _StreetArtScreenState();
}

class _StreetArtScreenState extends State<StreetArtScreen> {
  late List<StreetArtSpot> _items;

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
    final created = await showDialog<StreetArtSpot>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _ArtDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Murale i street art')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.brush_outlined),
        label: const Text('Dodaj miejsce'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Murale, legalne ściany i instalacje artystyczne na Widzewie.',
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFF3E5F5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFCE93D8)),
              ),
              child: Stack(
                children: [
                  const Positioned(
                    left: 8,
                    top: 8,
                    child: Text(
                      'Mapa street artu',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  for (final item in _items)
                    Align(
                      alignment: _align(item.pos),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Icon(Icons.brush, color: Color(0xFF6A1B9A)),
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
                leading: const Icon(Icons.brush_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.place}\n${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _ArtDialog extends StatefulWidget {
  final String userName;

  const _ArtDialog({required this.userName});

  @override
  State<_ArtDialog> createState() => _ArtDialogState();
}

class _ArtDialogState extends State<_ArtDialog> {
  var _kind = StreetArtKind.mural;
  final _title = TextEditingController();
  final _place = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _place.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Street art'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<StreetArtKind>(
            initialValue: _kind,
            items: [
              for (final kind in StreetArtKind.values)
                DropdownMenuItem(value: kind, child: Text(kind.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _kind = value);
            },
          ),
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Tytuł'),
          ),
          TextField(
            controller: _place,
            decoration: const InputDecoration(labelText: 'Miejsce'),
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
              StreetArtSpot(
                id: 'sa-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Mural na Widzewie'
                    : _title.text.trim(),
                place: _place.text.trim().isEmpty
                    ? 'Widzew'
                    : _place.text.trim(),
                authorName: widget.userName,
                pos: StationAlign.center,
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
