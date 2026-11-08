import 'package:flutter/material.dart';

import '../models/senior_shop.dart';

class SeniorShopScreen extends StatefulWidget {
  final List<SeniorShopOffer> items;
  final String userName;
  final ValueChanged<SeniorShopOffer> onAdd;

  const SeniorShopScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<SeniorShopScreen> createState() => _SeniorShopScreenState();
}

class _SeniorShopScreenState extends State<SeniorShopScreen> {
  late List<SeniorShopOffer> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<SeniorShopOffer>(
      context: context,
      builder: (_) => _ShopDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zakupy na telefon')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.elderly_outlined),
        label: const Text('Zgłoszenie'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Patrol seniora: wolontariusze z klatki przynoszą ciężkie zakupy ze sklepu.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.elderly_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.whenText}\n${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _ShopDialog extends StatefulWidget {
  final String userName;

  const _ShopDialog({required this.userName});

  @override
  State<_ShopDialog> createState() => _ShopDialogState();
}

class _ShopDialogState extends State<_ShopDialog> {
  var _kind = SeniorShopKind.volunteer;
  final _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zakupy'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<SeniorShopKind>(
            initialValue: _kind,
            items: [
              for (final kind in SeniorShopKind.values)
                DropdownMenuItem(value: kind, child: Text(kind.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _kind = value);
            },
          ),
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Opis'),
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
              SeniorShopOffer(
                id: 'ss-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? 'Zakupy z klatki'
                    : _title.text.trim(),
                whenText: 'Do uzgodnienia',
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
