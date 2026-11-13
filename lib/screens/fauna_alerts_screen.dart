import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../models/fauna_sighting.dart';
import '../theme/widzew_ui.dart';

class FaunaAlertsScreen extends StatefulWidget {
  final List<FaunaSighting> items;
  final String userName;
  final String defaultSubDistrict;
  final ValueChanged<FaunaSighting> onAdd;

  const FaunaAlertsScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.defaultSubDistrict,
    required this.onAdd,
  });

  @override
  State<FaunaAlertsScreen> createState() => _FaunaAlertsScreenState();
}

class _FaunaAlertsScreenState extends State<FaunaAlertsScreen> {
  late List<FaunaSighting> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<FaunaSighting>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _FaunaDialog(
        userName: widget.userName,
        subDistrict: widget.defaultSubDistrict,
      ),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  Alignment _align(String subDistrict) {
    return switch (subDistrict) {
      'Olechów' => Alignment.bottomRight,
      'Widzew Wschód' => Alignment.topRight,
      'Janów' => Alignment.bottomLeft,
      'Stary Widzew' => Alignment.topLeft,
      'Księży Młyn' => Alignment.centerLeft,
      _ => Alignment.center,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alert fauny miejskiej')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.pets),
        label: const Text('Zgłoś dzika / zwierzę'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Zgłoszenia dzików i dzikich zwierząt przy parkach i blokowiskach Widzewa. Nie dokarmiać.',
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
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
                      'Mapa zgłoszeń Widzewa',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  for (final item in _items)
                    Align(
                      alignment: _align(item.subDistrict),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item.kind == FaunaKind.boar
                                  ? Icons.warning_amber_rounded
                                  : Icons.pets,
                              color: const Color(0xFF2E7D32),
                            ),
                            Text(
                              item.kind.label,
                              style: const TextStyle(fontSize: 11),
                            ),
                          ],
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
                leading: const Icon(Icons.park_outlined),
                title: Text('${item.kind.label} · ${item.place}'),
                subtitle: Text(
                  '${item.subDistrict} · ${item.note}\n${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _FaunaDialog extends StatefulWidget {
  final String userName;
  final String subDistrict;

  const _FaunaDialog({required this.userName, required this.subDistrict});

  @override
  State<_FaunaDialog> createState() => _FaunaDialogState();
}

class _FaunaDialogState extends State<_FaunaDialog> {
  final _place = TextEditingController();
  final _note = TextEditingController();
  var _kind = FaunaKind.boar;
  late String _subDistrict;

  @override
  void initState() {
    super.initState();
    _subDistrict = widget.subDistrict;
  }

  @override
  void dispose() {
    _place.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zgłoszenie fauny'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<FaunaKind>(
              initialValue: _kind,
              items: [
                for (final kind in FaunaKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            DropdownButtonFormField<String>(
              initialValue: Announcement.subDistricts.contains(_subDistrict)
                  ? _subDistrict
                  : Announcement.subDistricts.first,
              items: [
                for (final name in Announcement.subDistricts)
                  DropdownMenuItem(value: name, child: Text(name)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _subDistrict = value);
              },
            ),
            TextField(
              controller: _place,
              decoration: const InputDecoration(
                labelText: 'Miejsce (park, blok)',
              ),
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
              FaunaSighting(
                id: 'fn-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                place: _place.text.trim().isEmpty
                    ? 'Okoliczne bloki'
                    : _place.text.trim(),
                subDistrict: _subDistrict,
                note: _note.text.trim(),
                authorName: widget.userName,
                seenAt: DateTime(2026, 10, 28, 20),
              ),
            );
          },
          child: const Text('Zgłoś'),
        ),
      ],
    );
  }
}
