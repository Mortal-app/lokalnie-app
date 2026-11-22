import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../models/plant_swap.dart';
import '../theme/widzew_ui.dart';

class PlantSwapScreen extends StatefulWidget {
  final List<PlantSwapOffer> offers;
  final String userName;
  final String defaultSubDistrict;
  final ValueChanged<PlantSwapOffer> onAdd;

  const PlantSwapScreen({
    super.key,
    required this.offers,
    required this.userName,
    required this.defaultSubDistrict,
    required this.onAdd,
  });

  @override
  State<PlantSwapScreen> createState() => _PlantSwapScreenState();
}

class _PlantSwapScreenState extends State<PlantSwapScreen> {
  late List<PlantSwapOffer> _offers;
  PlantSwapKind? _kind;

  @override
  void initState() {
    super.initState();
    _offers = List.of(widget.offers);
  }

  List<PlantSwapOffer> get _visible => _kind == null
      ? _offers
      : _offers.where((item) => item.kind == _kind).toList();

  Future<void> _add() async {
    final created = await showDialog<PlantSwapOffer>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _PlantDialog(
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
      appBar: AppBar(title: const Text('Zielona okolica')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.yard_outlined),
        label: const Text('Dodaj roślinę / poradę'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Szczepki, sadzonki, balkony i ROD. Porady o uprawie w łódzkim klimacie.',
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
              for (final kind in PlantSwapKind.values.take(2))
                FilterChip(
                  label: Text(kind.label),
                  selected: _kind == kind,
                  onSelected: (_) => setState(
                    () => _kind = _kind == kind ? null : kind,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          for (final offer in _visible)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(
                  offer.kind == PlantSwapKind.guide
                      ? Icons.menu_book_outlined
                      : Icons.spa_outlined,
                ),
                title: Text(offer.title),
                subtitle: Text(
                  '${offer.kind.label} · ${offer.authorName}, ${offer.subDistrict}\n'
                  '${offer.description}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _PlantDialog extends StatefulWidget {
  final String userName;
  final String subDistrict;

  const _PlantDialog({required this.userName, required this.subDistrict});

  @override
  State<_PlantDialog> createState() => _PlantDialogState();
}

class _PlantDialogState extends State<_PlantDialog> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  var _kind = PlantSwapKind.cuttings;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zielona okolica'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<PlantSwapKind>(
              initialValue: _kind,
              decoration: const InputDecoration(labelText: 'Rodzaj'),
              items: PlantSwapKind.values
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
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Opis / porada'),
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
              PlantSwapOffer(
                id: 'plant-${DateTime.now().microsecondsSinceEpoch}',
                title: _title.text.trim(),
                description: _description.text.trim(),
                kind: _kind,
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
