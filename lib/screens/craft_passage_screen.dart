import 'package:flutter/material.dart';

import '../models/craft_passage.dart';
import '../theme/widzew_ui.dart';

class CraftPassageScreen extends StatefulWidget {
  final List<CraftPassageService> items;
  final ValueChanged<CraftPassageService> onAdd;

  const CraftPassageScreen({
    super.key,
    required this.items,
    required this.onAdd,
  });

  @override
  State<CraftPassageScreen> createState() => _CraftPassageScreenState();
}

class _CraftPassageScreenState extends State<CraftPassageScreen> {
  late List<CraftPassageService> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<CraftPassageService>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _PassageDialog(),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mały pasaż rzemieślniczy')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.storefront_outlined),
        label: const Text('Dodaj warsztat'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Szewc, dorabianie kluczy i ostrzenie noży w Twojej okolicy — mobilnie i stacjonarnie.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(
                  item.mobile
                      ? Icons.local_shipping_outlined
                      : Icons.store_mall_directory_outlined,
                ),
                title: Text(item.name),
                subtitle: Text(
                  '${item.kind.label} · ${item.mobile ? 'Mobilny' : 'Stacjonarny'}\n'
                  '${item.place} · ${item.hours}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _PassageDialog extends StatefulWidget {
  const _PassageDialog();

  @override
  State<_PassageDialog> createState() => _PassageDialogState();
}

class _PassageDialogState extends State<_PassageDialog> {
  final _name = TextEditingController();
  final _place = TextEditingController();
  final _hours = TextEditingController();
  var _kind = PassageCraftKind.cobbler;
  var _mobile = false;

  @override
  void dispose() {
    _name.dispose();
    _place.dispose();
    _hours.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Usługa rzemieślnicza'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<PassageCraftKind>(
              initialValue: _kind,
              items: [
                for (final kind in PassageCraftKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Nazwa'),
            ),
            TextField(
              controller: _place,
              decoration: const InputDecoration(labelText: 'Miejsce'),
            ),
            TextField(
              controller: _hours,
              decoration: const InputDecoration(labelText: 'Godziny'),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Usługa mobilna'),
              value: _mobile,
              onChanged: (value) => setState(() => _mobile = value),
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
              CraftPassageService(
                id: 'cp-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                name: _name.text.trim().isEmpty
                    ? _kind.label
                    : _name.text.trim(),
                place: _place.text.trim().isEmpty
                    ? 'Okolica'
                    : _place.text.trim(),
                hours: _hours.text.trim().isEmpty
                    ? 'Do uzgodnienia'
                    : _hours.text.trim(),
                mobile: _mobile,
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
