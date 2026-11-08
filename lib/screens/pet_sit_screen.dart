import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../models/pet_sit_offer.dart';

class PetSitScreen extends StatefulWidget {
  final List<PetSitOffer> offers;
  final String userName;
  final String defaultSubDistrict;
  final ValueChanged<PetSitOffer> onAdd;

  const PetSitScreen({
    super.key,
    required this.offers,
    required this.userName,
    required this.defaultSubDistrict,
    required this.onAdd,
  });

  @override
  State<PetSitScreen> createState() => _PetSitScreenState();
}

class _PetSitScreenState extends State<PetSitScreen> {
  late List<PetSitOffer> _offers;
  PetSitKind? _kind;

  @override
  void initState() {
    super.initState();
    _offers = List.of(widget.offers);
  }

  List<PetSitOffer> get _visible {
    if (_kind == null) return _offers;
    return _offers.where((item) => item.kind == _kind).toList();
  }

  Future<void> _add() async {
    final created = await showDialog<PetSitOffer>(
      context: context,
      builder: (_) => _PetDialog(
        userName: widget.userName,
        subDistrict: widget.defaultSubDistrict,
      ),
    );
    if (created == null) return;
    setState(() => _offers = [created, ..._offers]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sąsiedzki Patrol Zwierzaków')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.pets),
        label: const Text('Dodaj ogłoszenie'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Opieka, wyprowadzanie i znalezione zwierzaki w okolicy.',
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              FilterChip(
                label: const Text('Wszystkie'),
                selected: _kind == null,
                onSelected: (_) => setState(() => _kind = null),
              ),
              FilterChip(
                label: const Text('Szukam opiekuna'),
                selected: _kind == PetSitKind.lookingForSitter,
                onSelected: (_) => setState(
                  () => _kind = _kind == PetSitKind.lookingForSitter
                      ? null
                      : PetSitKind.lookingForSitter,
                ),
              ),
              FilterChip(
                label: const Text('Mogę pomóc / wyprowadzić'),
                selected: _kind == PetSitKind.canHelp,
                onSelected: (_) => setState(
                  () => _kind = _kind == PetSitKind.canHelp
                      ? null
                      : PetSitKind.canHelp,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final offer in _visible)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.pets_outlined),
                title: Text(offer.title),
                subtitle: Text(
                  '${offer.kind.label} · ${offer.animal} · ${offer.whenLabel}\n'
                  '${offer.description}\n'
                  '${offer.authorName}, ${offer.subDistrict}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _PetDialog extends StatefulWidget {
  final String userName;
  final String subDistrict;

  const _PetDialog({required this.userName, required this.subDistrict});

  @override
  State<_PetDialog> createState() => _PetDialogState();
}

class _PetDialogState extends State<_PetDialog> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _when = TextEditingController();
  var _kind = PetSitKind.lookingForSitter;
  var _animal = 'pies';
  late String _subDistrict;

  @override
  void initState() {
    super.initState();
    _subDistrict = widget.subDistrict;
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _when.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ogłoszenie o zwierzaku'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<PetSitKind>(
              initialValue: _kind,
              decoration: const InputDecoration(labelText: 'Typ'),
              items: PetSitKind.values
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Tytuł'),
            ),
            DropdownButtonFormField<String>(
              initialValue: _animal,
              decoration: const InputDecoration(labelText: 'Zwierzę'),
              items: const ['pies', 'kot', 'inne']
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _animal = value);
              },
            ),
            TextField(
              controller: _when,
              decoration: const InputDecoration(labelText: 'Kiedy'),
            ),
            DropdownButtonFormField<String>(
              initialValue: _subDistrict,
              decoration: const InputDecoration(labelText: 'Osiedle'),
              items: Announcement.subDistricts
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _subDistrict = value);
              },
            ),
            TextField(
              controller: _description,
              maxLines: 2,
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
            if (_title.text.trim().isEmpty) return;
            Navigator.pop(
              context,
              PetSitOffer(
                id: 'pet-${DateTime.now().microsecondsSinceEpoch}',
                title: _title.text.trim(),
                description: _description.text.trim(),
                kind: _kind,
                animal: _animal,
                whenLabel: _when.text.trim().isEmpty
                    ? 'Do uzgodnienia'
                    : _when.text.trim(),
                authorName: widget.userName,
                subDistrict: _subDistrict,
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
