import 'package:flutter/material.dart';

import '../models/photo_club.dart';
import '../theme/widzew_ui.dart';

class PhotoClubScreen extends StatefulWidget {
  final List<PhotoClubItem> items;
  final String userName;
  final ValueChanged<PhotoClubItem> onAdd;

  const PhotoClubScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<PhotoClubScreen> createState() => _PhotoClubScreenState();
}

class _PhotoClubScreenState extends State<PhotoClubScreen> {
  late List<PhotoClubItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<PhotoClubItem>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _PhotoDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Klub fotograficzny')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.camera_alt_outlined),
        label: const Text('Sprzęt / plener'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Fotografia miejska, obiektywy, Zenit i Praktica, wspólne plenery analog i cyfra.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(
                  item.isPleinAir
                      ? Icons.wb_sunny_outlined
                      : Icons.photo_camera_outlined,
                ),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.place}\n${item.isPleinAir ? 'Plener' : 'Wymiana'} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _PhotoDialog extends StatefulWidget {
  final String userName;

  const _PhotoDialog({required this.userName});

  @override
  State<_PhotoDialog> createState() => _PhotoDialogState();
}

class _PhotoDialogState extends State<_PhotoDialog> {
  final _title = TextEditingController();
  var _kind = PhotoGearKind.analog;
  var _plein = false;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Klub foto'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<PhotoGearKind>(
              initialValue: _kind,
              items: [
                for (final kind in PhotoGearKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Wspólny plener'),
              value: _plein,
              onChanged: (value) => setState(() => _plein = value),
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
              PhotoClubItem(
                id: 'ph-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                place: 'Okolica',
                authorName: widget.userName,
                isPleinAir: _plein,
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
