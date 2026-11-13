import 'package:flutter/material.dart';

import '../models/bike_station.dart';
import '../models/walk_find.dart';
import '../theme/widzew_ui.dart';

class WalkFindScreen extends StatefulWidget {
  final List<WalkFindReport> items;
  final String userName;
  final ValueChanged<WalkFindReport> onAdd;

  const WalkFindScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<WalkFindScreen> createState() => _WalkFindScreenState();
}

class _WalkFindScreenState extends State<WalkFindScreen> {
  late List<WalkFindReport> _items;

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
    final created = await showDialog<WalkFindReport>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _FindDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Znaleziska ze spaceru')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.vpn_key_outlined),
        label: const Text('Zgłoś znalezisko'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Szybkie zgłoszenia: klucze i przedmioty znalezione na spacerze — zdjęcie (opis) i lokalizacja.',
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF90CAF9)),
              ),
              child: Stack(
                children: [
                  const Positioned(
                    left: 8,
                    top: 8,
                    child: Text(
                      'Mapa spaceru',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  for (final item in _items)
                    Align(
                      alignment: _align(item.pos),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Icon(
                          Icons.location_on,
                          color: Color(0xFF1565C0),
                        ),
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
                leading: const Icon(Icons.vpn_key_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.place}\n${item.photoNote} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _FindDialog extends StatefulWidget {
  final String userName;

  const _FindDialog({required this.userName});

  @override
  State<_FindDialog> createState() => _FindDialogState();
}

class _FindDialogState extends State<_FindDialog> {
  final _title = TextEditingController(
    text: 'Znalazłem pęk kluczy przy wejściu do parku',
  );
  final _place = TextEditingController();
  final _photo = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _place.dispose();
    _photo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Znalezisko'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Co znalazłeś'),
            ),
            TextField(
              controller: _place,
              decoration: const InputDecoration(labelText: 'Lokalizacja'),
            ),
            TextField(
              controller: _photo,
              decoration: const InputDecoration(
                labelText: 'Opis zdjęcia (bez pliku w testach)',
              ),
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
              WalkFindReport(
                id: 'wf-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? 'Znalazłem pęk kluczy przy wejściu do parku'
                    : _title.text.trim(),
                place: _place.text.trim().isEmpty
                    ? 'Park na Widzewie'
                    : _place.text.trim(),
                photoNote: _photo.text.trim().isEmpty
                    ? 'Zdjęcie: pęk kluczy (opis).'
                    : _photo.text.trim(),
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
