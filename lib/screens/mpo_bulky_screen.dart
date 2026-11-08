import 'package:flutter/material.dart';

import '../models/mpo_bulky.dart';

class MpoBulkyScreen extends StatefulWidget {
  final List<MpoBulkySlot> items;
  final String userName;
  final ValueChanged<MpoBulkySlot> onAdd;

  const MpoBulkyScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<MpoBulkyScreen> createState() => _MpoBulkyScreenState();
}

class _MpoBulkyScreenState extends State<MpoBulkyScreen> {
  late List<MpoBulkySlot> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<MpoBulkySlot>(
      context: context,
      builder: (_) => _MpoDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gabaryty i MPO')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.weekend_outlined),
        label: const Text('Termin ulicy'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Wystawianie i odbiór gabarytów przez MPO — Widzew Wschód i Olechów, ulica po ulicy.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.weekend_outlined),
                title: Text('${item.district.label} · ${item.street}'),
                subtitle: Text(
                  '${item.whenText}\n${item.note} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _MpoDialog extends StatefulWidget {
  final String userName;

  const _MpoDialog({required this.userName});

  @override
  State<_MpoDialog> createState() => _MpoDialogState();
}

class _MpoDialogState extends State<_MpoDialog> {
  var _district = MpoDistrict.wschod;
  final _street = TextEditingController();
  final _when = TextEditingController();

  @override
  void dispose() {
    _street.dispose();
    _when.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Odbiór gabarytów'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<MpoDistrict>(
            initialValue: _district,
            items: [
              for (final district in MpoDistrict.values)
                DropdownMenuItem(value: district, child: Text(district.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _district = value);
            },
          ),
          TextField(
            controller: _street,
            decoration: const InputDecoration(labelText: 'Ulica'),
          ),
          TextField(
            controller: _when,
            decoration: const InputDecoration(labelText: 'Termin MPO'),
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
              MpoBulkySlot(
                id: 'mpo-${DateTime.now().millisecondsSinceEpoch}',
                district: _district,
                street: _street.text.trim().isEmpty
                    ? 'ul. osiedlowa'
                    : _street.text.trim(),
                whenText: _when.text.trim().isEmpty
                    ? 'Do ogłoszenia MPO'
                    : _when.text.trim(),
                note: 'Wystawianie wieczorem przed odbiorem.',
                authorName: widget.userName,
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
