import 'package:flutter/material.dart';

import '../models/lost_pet.dart';
import '../theme/widzew_ui.dart';

class LostPetScreen extends StatefulWidget {
  final List<LostPetAlert> items;
  final String userName;
  final ValueChanged<LostPetAlert> onAdd;
  final ValueChanged<LostPetAlert> onNotifyNearby;

  const LostPetScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
    required this.onNotifyNearby,
  });

  @override
  State<LostPetScreen> createState() => _LostPetScreenState();
}

class _LostPetScreenState extends State<LostPetScreen> {
  late List<LostPetAlert> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<LostPetAlert>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _PetDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
    widget.onNotifyNearby(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zagubione zwierzęta')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.pets),
        label: const Text('Zdjęcie i alert'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Pies lub kot — opis zdjęcia i push do sąsiadów w promieniu kilku bloków.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.pets),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.place}\n${item.photoNote} · ${item.authorName}',
                ),
                isThreeLine: true,
                trailing: TextButton(
                  onPressed: () => widget.onNotifyNearby(item),
                  child: const Text('Push'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PetDialog extends StatefulWidget {
  final String userName;

  const _PetDialog({required this.userName});

  @override
  State<_PetDialog> createState() => _PetDialogState();
}

class _PetDialogState extends State<_PetDialog> {
  var _kind = LostPetKind.dog;
  final _title = TextEditingController();
  final _photo = TextEditingController();
  final _place = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _photo.dispose();
    _place.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zagubione zwierzę'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<LostPetKind>(
              initialValue: _kind,
              items: [
                for (final kind in LostPetKind.values)
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
              decoration: const InputDecoration(labelText: 'Okolica'),
            ),
            TextField(
              controller: _photo,
              decoration: const InputDecoration(
                labelText: 'Opis zdjęcia (bez pliku)',
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
              LostPetAlert(
                id: 'lp-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Zagubione zwierzę przy blokach'
                    : _title.text.trim(),
                photoNote: _photo.text.trim().isEmpty
                    ? 'Zdjęcie: opis wyglądu.'
                    : _photo.text.trim(),
                place: _place.text.trim().isEmpty
                    ? 'Kilka bloków wokół'
                    : _place.text.trim(),
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
