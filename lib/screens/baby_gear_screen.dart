import 'package:flutter/material.dart';

import '../models/baby_gear.dart';
import '../theme/widzew_ui.dart';

class BabyGearScreen extends StatefulWidget {
  final List<BabyGearItem> items;
  final String userName;
  final ValueChanged<BabyGearItem> onAdd;

  const BabyGearScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<BabyGearScreen> createState() => _BabyGearScreenState();
}

class _BabyGearScreenState extends State<BabyGearScreen> {
  late List<BabyGearItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<BabyGearItem>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _BabyDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wózki i foteliki')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.child_friendly_outlined),
        label: const Text('Oddaj / sprzedaj'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Foteliki samochodowe, wózki głębokie, spacerówki i nosidełka — dla rodziców z okolicy.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.child_friendly_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.kind.label} · ${item.forSale ? 'Odsprzedaż' : 'Przekazanie'}\n${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _BabyDialog extends StatefulWidget {
  final String userName;

  const _BabyDialog({required this.userName});

  @override
  State<_BabyDialog> createState() => _BabyDialogState();
}

class _BabyDialogState extends State<_BabyDialog> {
  final _title = TextEditingController();
  var _kind = BabyGearKind.stroller;
  var _sale = false;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sprzęt dziecięcy'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<BabyGearKind>(
              initialValue: _kind,
              items: [
                for (final kind in BabyGearKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Odsprzedaż (nie darmo)'),
              value: _sale,
              onChanged: (value) => setState(() => _sale = value),
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
              BabyGearItem(
                id: 'bg-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                title: _title.text.trim().isEmpty
                    ? _kind.label
                    : _title.text.trim(),
                authorName: widget.userName,
                forSale: _sale,
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
