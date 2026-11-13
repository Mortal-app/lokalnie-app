import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../models/barter_offer.dart';
import '../theme/widzew_ui.dart';

class BarterScreen extends StatefulWidget {
  final List<BarterOffer> offers;
  final String userName;
  final String defaultSubDistrict;
  final ValueChanged<BarterOffer> onAdd;

  const BarterScreen({
    super.key,
    required this.offers,
    required this.userName,
    required this.defaultSubDistrict,
    required this.onAdd,
  });

  @override
  State<BarterScreen> createState() => _BarterScreenState();
}

class _BarterScreenState extends State<BarterScreen> {
  late List<BarterOffer> _offers;

  @override
  void initState() {
    super.initState();
    _offers = List.of(widget.offers);
  }

  Future<void> _add() async {
    final created = await showDialog<BarterOffer>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _BarterDialog(
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
      appBar: AppBar(title: const Text('Sąsiedzki Barter')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.swap_horiz),
        label: const Text('Nowa wymiana'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Wymiana rzecz za rzecz, bez gotówki. Na karcie widać, co dajesz i czego szukasz.',
          ),
          const SizedBox(height: 12),
          for (final offer in _offers)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Chip(
                          visualDensity: VisualDensity.compact,
                          avatar: const Icon(Icons.north_east, size: 16),
                          label: Text('Daję: ${offer.offerItem}'),
                        ),
                        Chip(
                          visualDensity: VisualDensity.compact,
                          avatar: const Icon(Icons.south_west, size: 16),
                          label: Text('Szukam: ${offer.wantItem}'),
                        ),
                      ],
                    ),
                    Text('${offer.authorName} · ${offer.subDistrict}'),
                    if (offer.note.isNotEmpty) Text(offer.note),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BarterDialog extends StatefulWidget {
  final String userName;
  final String subDistrict;

  const _BarterDialog({required this.userName, required this.subDistrict});

  @override
  State<_BarterDialog> createState() => _BarterDialogState();
}

class _BarterDialogState extends State<_BarterDialog> {
  final _title = TextEditingController();
  final _offer = TextEditingController();
  final _want = TextEditingController();
  final _note = TextEditingController();
  late String _subDistrict;

  @override
  void initState() {
    super.initState();
    _subDistrict = widget.subDistrict;
  }

  @override
  void dispose() {
    _title.dispose();
    _offer.dispose();
    _want.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Wymiana bezgotówkowa'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Tytuł'),
            ),
            TextField(
              controller: _offer,
              decoration: const InputDecoration(labelText: 'Co daję'),
            ),
            TextField(
              controller: _want,
              decoration: const InputDecoration(labelText: 'Czego szukam'),
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
              controller: _note,
              decoration: const InputDecoration(labelText: 'Uwagi'),
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
            if (_offer.text.trim().isEmpty || _want.text.trim().isEmpty) {
              return;
            }
            Navigator.pop(
              context,
              BarterOffer(
                id: 'barter-${DateTime.now().microsecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? '${_offer.text.trim()} za ${_want.text.trim()}'
                    : _title.text.trim(),
                offerItem: _offer.text.trim(),
                wantItem: _want.text.trim(),
                authorName: widget.userName,
                subDistrict: _subDistrict,
                note: _note.text.trim(),
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
